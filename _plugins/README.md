# Search visibility add-on

## Install

Upload this entire `search-visibility` folder inside the repository's existing
`_plugins` folder. The Ruby file must end up at:

`_plugins/search-visibility/search_visibility.rb`

Commit and let the existing GitHub Actions build deploy. Keep your separate
`_plugins/personal-homepage/` folder: this add-on works alongside it.
No browser JavaScript is needed, and no existing source files need editing.

## Changes

- Gives the homepage the title "Arindam Raj | Materials Scientist".
- Sets its description to "Arindam Raj, Northwestern postdoctoral fellow
  researching atomic transport, interfaces, nanofabrication, and programmable
  materials."
- Updates matching homepage social metadata and WebSite structured data.
- Adds `data-nosnippet` to the homepage's logo wrapper and replaces the logo's
  verbose title/description with concise accessibility text in the built HTML.
  The animation, logo appearance, and visible homepage text are retained.
- Adds `<meta name="robots" content="noindex, follow">` to the Team page.
- Excludes Team from the generated sitemap. The Team URL remains accessible
  directly, so search engines can read its noindex instruction.

Edit HOME_TITLE and HOME_DESCRIPTION near the top of search_visibility.rb to
change the homepage metadata later. These do not change the visible headline.

## Verify after deployment

1. Open the homepage's page source. Inside `<head>`, check the title and meta
   description. The homepage should NOT have a noindex tag from this add-on.
2. Open the source of https://arindamraj.com/team/ and check that its `<head>`
   contains the robots noindex tag.
3. Open https://arindamraj.com/sitemap.xml and check that /team/ is absent.

## Refresh Google

In https://search.google.com/search-console/ select your verified property.
Inspect https://arindamraj.com/ and request indexing after the successful deploy.
For quicker hiding of Team, use Removals > New request > Temporarily remove URL
for https://arindamraj.com/team/ only. Keep the noindex tag in place for lasting
exclusion. Do not request removal of the homepage.

Do not disallow /team/ in robots.txt: Google must crawl it to see noindex.
Removing it from the menu or sitemap alone does not remove it from search.
Search changes are not instant; Google must recrawl/reprocess the pages and
can choose a different search title or snippet from the metadata supplied.

## Undo

Delete only `_plugins/search-visibility/` and rebuild. Original source files
and the personal homepage layout remain available. Search engines will reflect
the reversal on their own crawling schedule.

## Compatibility

This uses the repository's existing custom GitHub Actions Jekyll build and
jekyll-sitemap plugin. Jekyll safe mode would disable local plugins.

## References

https://developers.google.com/search/docs/crawling-indexing/block-indexing
https://developers.google.com/search/docs/appearance/snippet
https://developers.google.com/search/docs/appearance/title-link
https://support.google.com/webmasters/answer/9689846
