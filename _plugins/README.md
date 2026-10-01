# Personal homepage — no browser JavaScript required

This folder adds the “Personal first” homepage layout during the Jekyll build.
The deployed page contains ordinary HTML and CSS, so the introduction, layout,
and links work even with browser JavaScript disabled.

## Install

1. If you installed the earlier JavaScript version, remove only
   `_scripts/personal-homepage/` first. Keep all other scripts.
2. Add this folder to your repository at `_plugins/personal-homepage/`.
3. Commit and let the existing GitHub Actions workflow build and deploy.

The folder contains `homepage.rb`, `intro.html`, `homepage.css`, and this README.
No existing files, Gemfile entries, configuration, or workflow changes are needed
for the repository's current custom GitHub Actions build.

Do not put this version under `_scripts`.

## Customize

- Edit `intro.html` to change your name, role, institution, or introductory text.
- Keep `{{RESEARCH_URL}}` and `{{CV_URL}}`: the plugin fills these using the
  site's base URL, including GitHub project paths when needed.
- Edit `homepage.css` to adjust this homepage layout.
- The future-vision label is in `homepage.rb`.

The existing animated logo, header background, navigation, other research text,
highlights, and footer are retained. Other pages are left unchanged.

## Undo

Delete only `_plugins/personal-homepage/`, commit, and let the site deploy again.
Then refresh the homepage. With the old JavaScript add-on also removed, the
original layout returns. Original source files are never overwritten.

## Compatibility

Checked against this repository's October 1, 2026 configuration: its workflow
runs `bundle exec jekyll build` without safe mode and already uses `_plugins`.
Jekyll automatically discovers Ruby plugins in subfolders of `_plugins`.

A switch to GitHub Pages' restricted built-in Jekyll build / safe mode would
disable this plugin. Keep the existing custom GitHub Actions build workflow.

This removes JavaScript dependence for the new layout only. Any unrelated site
feature that already requires JavaScript still has its original requirements.
