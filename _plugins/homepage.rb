# frozen_string_literal: true

# A removable homepage overlay for arindam-lab-website.
# Jekyll runs this during the build. It adds no browser JavaScript and never
# writes to the original index.md, layout, header, or stylesheet files.

require "cgi"

module RajPersonalHomepage
  DIRECTORY = File.expand_path(__dir__)
  MARKER = 'id="raj-personal-homepage-styles"'

  def self.add_class(opening_tag, name)
    class_attribute = /(\sclass\s*=\s*)(["'])(.*?)\2/m
    if opening_tag.match?(class_attribute)
      opening_tag.sub(class_attribute) do
        "#{Regexp.last_match(1)}#{Regexp.last_match(2)}#{Regexp.last_match(3)} #{name}#{Regexp.last_match(2)}"
      end
    else
      opening_tag.sub(/>\z/, " class=\"#{name}\">")
    end
  end

  def self.render(page)
    return unless page.url == "/"

    original = page.output.to_s
    return if original.include?(MARKER)

    # Work only on this template's homepage header. If its structure changes,
    # leave the original page intact rather than changing unrelated markup.
    header = original.match(%r{(<header\b[^>]*>)(.*?)(</header>)}m)
    unless header && header[1].match?(/\bdata-big(?:\s|=|>)/) && original.include?("</head>")
      Jekyll.logger.warn("Personal homepage:", "Expected homepage header not found; original page retained.")
      return
    end

    root = page.site.config.fetch("baseurl", "").to_s.sub(%r{/+\z}, "")
    hero = File.read(File.join(DIRECTORY, "intro.html"), encoding: "UTF-8")
    hero = hero.gsub("{{RESEARCH_URL}}", CGI.escapeHTML("#{root}/research/"))
               .gsub("{{CV_URL}}", CGI.escapeHTML("#{root}/cv/"))
    css = File.read(File.join(DIRECTORY, "homepage.css"), encoding: "UTF-8")

    # Keep the existing header contents byte-for-byte, including the animated
    # SVG. Avoid parsing/re-serializing the SVG, which can alter its attributes.
    replacement = add_class(header[1], "raj-personal-homepage") + header[2] + hero + header[3]
    output = original.sub(header[0]) { replacement }
    output = output.sub("</head>") do
      "<style #{MARKER}>\n#{css}\n</style>\n</head>"
    end

    # Add a future-vision label to the first section and make its original H1
    # an H2 beneath the new name heading. Preserve its text, ID, and links.
    main_start = output.index(/<main\b/)
    if main_start
      before_main = output[0...main_start]
      main_and_after = output[main_start..-1]
      section_pattern = %r{(<section\b[^>]*>)(.*?)(</section>)}m
      main_and_after = main_and_after.sub(section_pattern) do |section|
        opening = Regexp.last_match(1)
        body = Regexp.last_match(2)
        closing = Regexp.last_match(3)
        heading = body.match(%r{(<h1\b[^>]*>)(.*?)(</h1>)}m)
        if heading
          title_opening = add_class(heading[1].sub("<h1", "<h2"), "raj-personal-vision-title")
          label = '<p class="raj-personal-vision-label">Vision for my future research group</p>'
          title = "#{label}\n#{title_opening}#{heading[2]}</h2>"
          body = body.sub(heading[0]) { title }
          add_class(opening, "raj-personal-vision") + body + closing
        else
          section
        end
      end
      output = before_main + main_and_after
    end

    page.output = output
  end
end

Jekyll::Hooks.register :pages, :post_render do |page|
  RajPersonalHomepage.render(page)
end
