# frozen_string_literal: true

# Build-time search metadata for arindamraj.com. Delete this folder and rebuild
# to undo. Works alongside the separate personal-homepage add-on.
require "cgi"
require "json"

module RajSearchVisibility
  HOME_TITLE = "Arindam Raj | Materials Scientist"
  HOME_DESCRIPTION = "Arindam Raj, Northwestern postdoctoral fellow researching atomic transport, interfaces, nanofabrication, and programmable materials."
  SITE_NAME = "Arindam Raj"
  TEAM_URLS = ["/team/", "/team/index.html", "/team.html"].freeze

  def self.team?(page)
    TEAM_URLS.include?(page.url)
  end

  def self.prepare(site)
    site.pages.each do |page|
      # jekyll-sitemap respects sitemap: false when rendering its URL list.
      page.data["sitemap"] = false if team?(page)
    end
  end

  def self.set_meta(head, attribute, key, value)
    escaped = CGI.escapeHTML(value)
    replacement = %(<meta #{attribute}="#{key}" content="#{escaped}">)
    pattern = /<meta\b(?=[^>]*\s#{Regexp.escape(attribute)}\s*=\s*["']#{Regexp.escape(key)}["'])[^>]*>/i
    if head.match?(pattern)
      head.gsub(pattern) { replacement }
    else
      head + "\n" + replacement
    end
  end

  def self.home_metadata(head, page)
    title = "<title>#{CGI.escapeHTML(HOME_TITLE)}</title>"
    if head.match?(%r{<title\b[^>]*>.*?</title>}mi)
      head = head.gsub(%r{<title\b[^>]*>.*?</title>}mi) { title }
    else
      head += "\n" + title
    end

    [
      ["name", "title", HOME_TITLE],
      ["name", "description", HOME_DESCRIPTION],
      ["property", "og:title", HOME_TITLE],
      ["property", "og:description", HOME_DESCRIPTION],
      ["property", "og:site_title", SITE_NAME],
      ["property", "og:site_name", SITE_NAME],
      ["property", "twitter:title", HOME_TITLE],
      ["property", "twitter:description", HOME_DESCRIPTION]
    ].each { |attribute, key, value| head = set_meta(head, attribute, key, value) }

    # Correct the existing WebSite structured data as well as the HTML tags.
    origin = page.site.config.fetch("url", "https://arindamraj.com").to_s.sub(%r{/+\z}, "")
    base = page.site.config.fetch("baseurl", "").to_s.sub(%r{/+\z}, "")
    home_url = origin + base + "/"
    head = head.gsub(%r{(<script\b[^>]*type=["']application/ld\+json["'][^>]*>)(.*?)(</script>)}mi) do |script|
      opening, json, closing = Regexp.last_match.captures
      begin
        data = JSON.parse(json)
        if data.is_a?(Hash) && data["@type"] == "WebSite"
          data["name"] = SITE_NAME
          data["headline"] = HOME_TITLE
          data["description"] = HOME_DESCRIPTION
          data["url"] = home_url
          opening + JSON.generate(data).gsub("<", '\u003c') + closing
        else
          script
        end
      rescue JSON::ParserError
        script
      end
    end
    head
  end

  def self.render(page)
    return unless page.url == "/" || team?(page)

    html = page.output.to_s
    head_match = html.match(%r{(<head\b[^>]*>)(.*?)(</head>)}mi)
    return unless head_match

    opening, head, closing = head_match.captures
    if team?(page)
      head = set_meta(head, "name", "robots", "noindex, follow")
    else
      head = home_metadata(head, page)
    end
    html = html.sub(head_match[0]) { opening + head + closing }

    if page.url == "/"
      # Google supports data-nosnippet on span elements. The existing logo and
      # every animation node remain in place; only descriptive metadata changes.
      html = html.gsub(/<span\b[^>]*>/i) do |tag|
        class_name = tag[/\bclass\s*=\s*["']([^"']*)["']/i, 1]
        if class_name && class_name.split.include?("logo") && !tag.match?(/\bdata-nosnippet\b/i)
          tag.sub(/>\z/, " data-nosnippet>")
        else
          tag
        end
      end
      html = html.gsub(%r{(<title\b[^>]*id=["']raj-lab-living-underline-title["'][^>]*>).*?(</title>)}mi) do
        Regexp.last_match(1) + "RAJ LAB logo" + Regexp.last_match(2)
      end
      html = html.gsub(%r{(<desc\b[^>]*id=["']raj-lab-living-underline-desc["'][^>]*>).*?(</desc>)}mi) do
        Regexp.last_match(1) + "Animated RAJ LAB logo illustrating crystallization, deformation, and atomic diffusion." + Regexp.last_match(2)
      end
    end

    page.output = html
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  RajSearchVisibility.prepare(site)
end

Jekyll::Hooks.register :pages, :post_render do |page|
  RajSearchVisibility.render(page)
end
