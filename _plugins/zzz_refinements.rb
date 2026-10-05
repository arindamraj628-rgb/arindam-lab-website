# frozen_string_literal: true

# RAJ website refinements -- ONE-FILE, JAVASCRIPT-FREE EDITION
# Prepared for arindamraj628-rgb/arindam-lab-website on 2026-10-05.
#
# INSTALL: Add this file as _plugins/zzz_refinements.rb on main, commit,
# and let the existing GitHub Actions workflow rebuild and deploy the site.
# Keep all your existing plugins, stylesheets, pages, and data files.
# Do NOT install the earlier multi-file refinements package as well.
# If already installed, revert that package first to recover a clean baseline.
#
# UNDO: Delete ONLY _plugins/zzz_refinements.rb, commit, and let the site
# rebuild and deploy. Local `jekyll serve` users must stop and restart it.
# This plugin edits only Jekyll's in-memory content and generated HTML.
# It never writes to the source pages, YAML data, or other plugins.
# It adds no browser JavaScript and no gem dependencies.
#
# INCLUDES: Compact photo credits, gradient footer, dated news entries, quieter
# header, shorter prose lines, consistent research cards and short summaries,
# "Additional research" heading, and left-aligned narrow/mobile prose.
# Your fonts, 1200px outer layout, logo, and existing header layout are retained.
#
# CUSTOMIZE: Research subtitles/summaries are in PROJECT_TEXT below; while
# active these replace the displayed values for projects with matching titles.
# News entries still come from news/index.md, in its existing numbered format:
# 1. Headline, <a href="https://example.org">Outlet, October 5, 2026</a>
# Styling is in CSS at the bottom. No _config.yaml edit is required.

require "cgi"
require "date"
require "json"

module RajRemovableRefinements
  STYLE_ID = "raj-removable-refinements"

  # Only these two project fields are overridden; images, links, tags, titles,
  # group membership, and all other data continue to come from your YAML.
  PROJECT_TEXT = JSON.parse(<<~'PROJECTS_JSON').freeze
    {
      "High-Throughput Local Diffusion Mapping": {
        "subtitle": "Spatially resolved transport in alloy microstructures",
        "description": "Local deformation mapping uses thermomechanical nanomolding to reveal spatial variations in atomic transport across alloy microstructures, connecting nanoscale features with larger-scale transport behavior."
      },
      "Top-down Thermomechanical Nanofabrication": {
        "subtitle": "Low-temperature nanomolding through eutectic interface diffusion",
        "description": "Enhanced diffusion at gold–silicon eutectic interfaces enables thermomechanical nanomolding at low temperatures, including room-temperature fabrication of gold and gold–silicon nanostructures."
      },
      "Bottom-up Assembly of Nanomaterials": {
        "subtitle": "DNA-programmed organization of nanoparticles",
        "description": "DNA-mediated interactions guide nanoparticles into extended assemblies. This research explores how programmable bonds control nanoscale organization and the formation of ordered materials."
      },
      "Metallic Glass under Irradiation": {
        "subtitle": "Dose-dependent changes in metallic-glass hardness",
        "description": "Low-dose helium irradiation increases hardness in zirconium-based metallic glass without observed nanocrystals. At higher doses, nanoindentation measurements show a decrease in hardness."
      },
      "Machine learning performance in metallic glass physics": {
        "subtitle": "Physical insight for predicting glass formation",
        "description": "Comparing machine learning with physical insight shows the limits of elemental descriptors for predicting glass formation and highlights the importance of alloy mixing behavior."
      }
    }
  PROJECTS_JSON

  def self.warn(message)
    Jekyll.logger.warn("RAJ refinements:", message)
  end

  def self.home(content)
    return content if content.include?('class="raj-prose"')

    # The current homepage has ordinary text immediately after </p>. Give it
    # a real paragraph and a shared wrapper, keeping every word unchanged.
    pattern = %r{(<p\b[^>]*>.*?</p>)[ \t]+(My research[^\n]+)}m
    content.sub(pattern) do
      questions, prose = Regexp.last_match.captures
      %(<div class="raj-prose">\n#{questions}\n\n<p>#{prose.strip}</p>\n</div>)
    end
  end

  def self.contact(content)
    return content if content.include?('class="photo-credits"')

    marker = content.match(/\{%\s*include\s+section\.html\s+dark=true\s*%\}/)
    unless marker
      warn("Contact credit section not found; contact content retained.")
      return content
    end
    # Limit all edits to the credit section after the photographs.
    tail = content[marker.end(0)..-1]
    columns = /\{%\s*include\s+cols\.html\s+col1=col1\s+col2=col2\s+col3=col3\s*%\}/
    unless tail.match?(columns)
      warn("Contact credit columns not found; contact content retained.")
      return content
    end
    tail = tail.sub(columns) { |tag| %(<div class="photo-credits">\n#{tag}\n</div>) }
    tail = tail.sub("NiteshSingh-<br>6789", "NiteshSingh6789")
    content[0...marker.begin(0)] +
      '{% include section.html dark=true size="credits" %}' + tail
  end

  def self.research(content)
    unless content.include?('class="project-grid"')
      content = content.gsub(/\{%\s*include\s+list\.html\b.*?%\}/m) do |tag|
        if tag.match?(/\bcomponent=["']card["']/) && tag.match?(/\bdata=["']projects["']/)
          tag = tag.sub(/\s+style=["']small["']/, "")
          %(<div class="project-grid">\n#{tag}\n</div>)
        else
          tag
        end
      end
    end
    content.sub(/^##[ \t]+More[ \t]*$/, "## Additional research")
  end

  def self.news_entry(line)
    # Supports the current source's missing closing </a> as well as valid tags.
    match = line.strip.match(%r{\A\d+\.\s+(.*?)\s*,\s*<a\b[^>]*\bhref=["']([^"']+)["'][^>]*>(.*?)\s*,\s*([A-Za-z]+\s+\d{1,2},\s+\d{4})\s*(?:</a>)?\s*\z})
    return nil unless match

    title, url, outlet, date_label = match.captures
    date = Date.strptime(date_label, "%B %d, %Y").iso8601
    title, url, outlet, date_label = [title, url, outlet, date_label].map do |value|
      CGI.escapeHTML(CGI.unescapeHTML(value.strip))
    end
    <<~HTML
      <article class="news-entry">
        <h2 class="news-title"><a href="#{url}">#{title}</a></h2>
        <p class="news-meta">#{outlet} · <time datetime="#{date}">#{date_label}</time></p>
      </article>
    HTML
  rescue ArgumentError
    nil
  end

  def self.news(content)
    return content if content.include?('class="news-list"')

    # Transform consecutive numbered news items; retain headings, comments,
    # and any other page content. Unrecognized list blocks stay untouched.
    content.gsub(/^(?:[ \t]*\d+\.[ \t]+[^\n]+(?:\n|\z))+/) do |block|
      entries = block.lines.map { |line| news_entry(line) }
      if entries.all?
        %(<div class="news-list">\n#{entries.join("\n")}</div>\n)
      else
        warn("A news list did not match the expected format; that list was retained.")
        block
      end
    end
  end

  def self.prepare(site)
    Array(site.data["projects"]).each do |project|
      next unless project.is_a?(Hash)
      overrides = PROJECT_TEXT[project["title"]]
      project.merge!(overrides) if overrides
    end

    site.pages.each do |page|
      # Match page URLs without depending on a custom domain or baseurl.
      case page.url
      when "/", "/index.html"
        page.content = home(page.content.to_s)
      when "/contact/", "/contact/index.html", "/contact.html"
        page.content = contact(page.content.to_s)
      when "/research/", "/research/index.html", "/research.html"
        page.content = research(page.content.to_s)
      when "/news/", "/news/index.html", "/news.html"
        page.content = news(page.content.to_s)
      end
    end
  end

  def self.finish(site)
    # Site post_render runs after the existing page-level homepage plugin,
    # so these CSS refinements are added after its injected stylesheet.
    documents = site.collections.values.flat_map(&:docs)
    (site.pages + documents).each do |page|
      html = page.output.to_s
      next unless html.match?(%r{</head>}i)
      next if html.include?(%(id="#{STYLE_ID}"))
      page.output = html.sub(%r{</head>}i) do
        %(<style id="#{STYLE_ID}">\n#{CSS}\n</style>\n</head>)
      end
    end
  end

  CSS = <<~'REFINEMENT_CSS'
    /* RAJ website refinements. Injected by this build-time plugin.
       The numbered sections correspond to the requested changes.
       Existing fonts, 1200px layout, and mobile header centering are retained. */
    
    /* 1. Compact, left-aligned contact photo credits. */
    body main > section[data-size="credits"] {
      padding-block: 24px;
      flex-grow: 0;
    }
    
    body .photo-credits .cols {
      margin: 0;
      gap: 24px;
    }
    
    body .photo-credits p {
      margin: 0;
      font-size: 0.875rem;
      line-height: 1.6;
      text-align: left;
      text-align-last: auto;
      -webkit-hyphens: none;
      hyphens: none;
      overflow-wrap: anywhere;
    }
    
    /* 2. Keep the footer image on all pages. A dark overlay covers the top
       75%, then fades so more of the micrograph shows near the bottom. */
    body footer.background {
      background: #101820;
      color: #e4edf6;
      --text: #e4edf6;
    }
    
    body footer.background::before {
      display: block;
      background-image:
        linear-gradient(to bottom,
          rgba(8, 12, 18, 0.96) 0%,
          rgba(8, 12, 18, 0.94) 75%,
          rgba(8, 12, 18, 0.50) 100%),
        var(--image);
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
      opacity: 1;
      pointer-events: none;
    }
    
    /* 3. News: headline, then outlet and date. */
    body .news-list {
      max-width: 78ch;
      margin: 24px auto 0;
      text-align: left;
    }
    
    body .news-entry {
      padding: 24px 0;
      border-bottom: 1px solid var(--light-gray);
    }
    
    body .news-entry:first-child { padding-top: 0; }
    body .news-entry:last-child { border-bottom: 0; }
    
    body .news-title {
      margin: 0 0 8px;
      padding: 0;
      border: 0;
      font-size: 1.25rem;
      line-height: 1.4;
      font-weight: 600;
      text-align: left;
    }
    
    body .news-title a {
      color: var(--text);
      text-decoration: none;
    }
    
    body .news-title a:hover,
    body .news-title a:focus-visible {
      color: var(--primary);
      text-decoration: underline;
    }
    
    body .news-meta {
      margin: 0;
      font-size: 0.9375rem;
      line-height: 1.5;
      color: var(--dark-gray);
      text-align: left;
    }
    
    /* 4. Quieter header micrograph, darkest behind the central text.
       Both selectors are needed because the homepage plugin adds later CSS. */
    body header.background {
      background-color: #101820;
    }
    
    body header.background::before,
    body header.raj-personal-homepage[data-big]::before {
      background-image:
        radial-gradient(ellipse at center,
          rgba(16, 24, 32, 0.55) 0%,
          rgba(16, 24, 32, 0.10) 80%),
        var(--image);
      opacity: 0.22;
    }
    
    /* 5. A readable measure for prose, within the existing wider layout.
       The homepage vision label keeps its current width and centering. */
    body .raj-prose,
    body main > section > p:not(.raj-personal-vision-label) {
      max-width: 76ch;
      margin-inline: auto;
    }
    
    /* 6. Research cards: three equal widths, with incomplete rows centered. */
    body .project-grid {
      display: flex;
      flex-wrap: wrap;
      align-items: stretch;
      justify-content: center;
      gap: 24px;
      margin: 28px 0 0;
    }
    
    body .project-grid > .card {
      display: flex;
      flex-direction: column;
      width: calc((100% - 48px) / 3);
      max-width: none;
      min-width: 0;
      margin: 0;
    }
    
    body .project-grid .card-image {
      display: block;
      flex: 0 0 auto;
      width: 100%;
      aspect-ratio: 16 / 10;
      background: #fff;
    }
    
    body .project-grid .card-image img {
      display: block;
      width: 100%;
      height: 100%;
      aspect-ratio: auto;
      object-fit: contain;
      padding: 12px;
    }
    
    body .project-grid .card-text {
      flex: 1;
      width: 100%;
      align-items: stretch;
      gap: 14px;
      padding: 22px;
    }
    
    body .project-grid .card-title {
      min-height: 2.9em;
      line-height: 1.45;
    }
    
    body .project-grid .card-subtitle {
      margin-top: 0 !important;
      min-height: 3em;
      line-height: 1.5;
    }
    
    body .project-grid .card-text > .tags {
      /* Override the template's margin: 0 !important on card children. */
      margin-top: auto !important;
      padding-top: 8px;
      justify-content: flex-start;
    }
    
    /* 7. Left alignment and natural wrapping inside narrow cards. */
    body .project-grid .card-title,
    body .project-grid .card-subtitle,
    body .project-grid .card-text p {
      text-align: left;
      text-align-last: auto;
      -webkit-hyphens: none;
      hyphens: none;
      overflow-wrap: break-word;
    }
    
    @media (max-width: 1000px) {
      body .project-grid > .card {
        width: calc((100% - 24px) / 2);
      }
    }
    
    @media (max-width: 650px) {
      body .project-grid > .card {
        width: 100%;
        max-width: 440px;
      }
    
      body .project-grid .card-title,
      body .project-grid .card-subtitle {
        min-height: 0;
      }
    }
    
    @media (max-width: 700px) {
      body main p {
        text-align: left;
        text-align-last: auto;
        -webkit-hyphens: none;
        hyphens: none;
      }
    
      /* Keep photo captions centered. Inline-centered introductions also win. */
      body main .figure-caption,
      body main .figure-caption p {
        text-align: center;
      }
    }
  REFINEMENT_CSS
end

Jekyll::Hooks.register :site, :post_read do |site|
  RajRemovableRefinements.prepare(site)
end

Jekyll::Hooks.register :site, :post_render do |site|
  RajRemovableRefinements.finish(site)
end
