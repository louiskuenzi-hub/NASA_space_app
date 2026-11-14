# Landing Site Finder

An interactive map of places on Earth that resemble the Moon or Mars, built by **Helvetic Dynamics** for the **NASA Space Apps Challenge**.

It answers one practical question: when you need to test a rover, train astronauts or study a landing area, where on Earth can you find terrain that looks like the Moon or Mars?

The main resource is ESA's **The Catalogue of Planetary Analogues** (CAFE study, The Open University, final version December 2012): 30 field sites on Earth with their location, climate, geology and the lunar or Martian features each one imitates. NASA elevation and imagery data drive the 3D globes.

## What is in the site

- **Home**: animated contour lines and starfield, three live map previews (the Moon and Mars previews rotate), key figures, a four-step "How it works", a gallery of the 30 catalogue sites with their photos, a footer and a Contact dialog. Sections reveal as you scroll; everything respects `prefers-reduced-motion`.
- **Earth map** (`#carte`): flat world map of the analogue sites. Switch Moon / Mars, tick criteria (terrain & geology from the catalogue, plus climate type, temperature, precipitation, humidity, wind, insolation and altitude bands), and countries and glowing disks are tinted by how well each site covers them. Click a point to zoom and open its sheet.
- **3D Moon and Mars** (`#lune`, `#mars`): globes with real relief. Click anywhere to read the terrain (altitude, slope, local relief, brightness), get a terrain profile and the closest catalogue site on Earth. Glowing zones show where a catalogue site matches above a chosen threshold.
- **Site sheet** (`#site-N`): Earth photo beside a Moon or Mars image, the catalogue data, the lunar and Martian features the site covers.
- **Guide** (`#guide`): step-by-step use, how to read the percentages, limits, sources and image credits.

## Run it

`index.html` is a single self-contained page plus the `images/` folder. Open `index.html` in a browser. An internet connection is needed for the d3, topojson and three.js libraries (jsDelivr / cdnjs) and the Google Fonts.

To publish it, upload `index.html` and `images/` to any static host (Porkbun static hosting, Netlify, GitHub Pages, ...). With GitHub Pages: Settings > Pages > Deploy from a branch > `main` / root.

## Rebuild

`index.html` is generated. To rebuild it after editing `src/template.html` or the data files, use either script (they produce the same file):

```bash
node src/build.mjs
```

```powershell
powershell -ExecutionPolicy Bypass -File src\build.ps1
```

The script embeds the data (sites, outlines, Moon and Mars elevation grids and colour maps, logo, credits) into the template. No other tool is needed.

## Repository layout

| Path | Content |
|---|---|
| `index.html` | The built site (generated) |
| `images/` | Site photos and Moon/Mars images, resized to 1000 px |
| `src/template.html` | Page source with placeholders for the embedded data |
| `src/build.mjs` | Builds `index.html` (Node, any OS) |
| `src/build.ps1` | Builds `index.html` (Windows PowerShell) |
| `data/sites.json` | The 30 catalogue sites in structured form: location, quoted climate values, Moon/Mars features, relevance notes |
| `data/folder.json` | Image paths, captions and notes per site |
| `data/credits.html` | Image credits shown in the guide |
| `data/countries-110m.json` | Country outlines (world-atlas, derived from Natural Earth) |
| `data/moon/` | LRO LOLA elevation grid (4 px/deg) and LROC colour map |
| `data/mars/` | MGS MOLA elevation grid (4 px/deg) and Viking MDIM 2.1 colour map |
| `assets/` | Logo (original and white-on-transparent version) |
| `tools/` | Scripts that document how the data files were prepared |

## How the matching works

- **Earth map**: each category with at least one tick counts equally. For terrain, the score is the share of ticked items the catalogue lists for the site; for the other categories it is 1 if a quoted value falls in a ticked band. Map colour is relative to the best site; the percentage shown is absolute.
- **3D globes**: at the clicked point the page reads altitude, slope, local relief and brightness, derives a terrain profile with simple rules, and ranks the catalogue sites by the share of the profile's elements they cover. Ties go to the driest site (and, for Mars, then the coldest) using the quoted values. The rules and thresholds were defined for this project, not by ESA or NASA, and are listed in the "How the site is chosen" panel of each globe.

## Limits

- The catalogue is a 2012 literature compilation and some entries are incomplete. 14 of the 30 sites have no usable coordinates, and one set of coordinates (Yellowstone) is printed wrongly in the document, so it is not used.
- The catalogue gives no reference values for the Moon or Mars and does not measure UV. The climate bands are thresholds defined for this project from the quoted values.
- The elevation grids are coarse (about 7.6 km per pixel on the Moon, 14.8 km on Mars). NASA describes its Moon Kit maps as optimised for aesthetics, not science.
- Site photos are the lead image of a Wikipedia page, and some are maps or satellite views. The Moon and Mars images are proposed associations, not official equivalences. One site (Golden Deposit) has no photo.
- This is an independent project, not an official NASA or ESA product.

## Data sources and credits

- ESA, *The Catalogue of Planetary Analogues* (CAFE study, The Open University): https://www.esa.int/Our_Activities/Preparing_for_the_Future/Discovery_and_Preparation/Cataloguing_otherworldly_landscapes_on_Earth
- NASA/GSFC Scientific Visualization Studio, CGI Moon Kit (LRO LOLA elevation, LROC colour map): https://svs.gsfc.nasa.gov/4720
- NASA Planetary Data System, MGS MOLA gridded topography (MEGDR, 4 px/deg): https://pds-geosciences.wustl.edu/mgs/urn-nasa-pds-mgs_mola_topography_derived/meg004/
- NASA/JPL/USGS, Viking MDIM 2.1 colour mosaic, via Wikimedia Commons: https://commons.wikimedia.org/wiki/File:Mars_Viking_MDIM21_ClrMosaic_1km.jpg
- Photos: Wikipedia and Wikimedia Commons contributors. The list of source pages is in `data/credits.html` and in the site's guide. Many files carry Creative Commons licences that require attribution; check each file's page before reusing it.
- Libraries: d3, topojson, three.js. Fonts: Archivo, Hanken Grotesk, JetBrains Mono (Google Fonts).

## Licence

No licence file has been chosen yet, so all rights are reserved by default. Add one before inviting reuse. Data and images keep their original licences (see credits above).