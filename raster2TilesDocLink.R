# Setup Guide: https://cran.r-project.org/web/packages/tiler/vignettes/tiler-intro.html
## install: OSGeo4W from https://download.osgeo.org/osgeo4w/v2/osgeo4w-setup.exe

# Requirements: Windows
# - Python 3.11 (mandatory)
# - Install GDAL for Python from: https://github.com/wajahat16079/rasters2tilesR
#   (GDAL-3.4.3-cp311-cp311-win_amd64.whl)

# Load required libraries
library(tiler)    # For tiling raster data
library(raster)   # For working with raster data
library(leaflet)  # For interactive maps
library(mapview)  # For interactive maps

# Setup tiler options (change the directory to where "OSGeo4W.bat" is)
tiler_options(osgeo4w = "C:/OSGeo4W/OSGeo4W.bat")
tiler_options()

# Define Coordinate Reference System (CRS) 
crs <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs" # (change as per your data)

# Define Output Directory and Input File
outDir <- "checkRastersTiles/www/fileName"  # Output directory for tiles (change to your dir)
tempIn <- "fileName.tif"  # Input raster file (change to your dir)

# Load Raster Data
r <- raster(tempIn)  # Load raster data

# Visualize Data Distribution
plot(r)  # Plot the raster
vals <- getValues(r)  # Get raster values
hist(vals, breaks = 20, main = "Histogram of Raster Values")  # Plot histogram
summary(vals)  # Summarize raster values

# Define Color List for Visualization
colorList <- c('#1C6FF8', '#27BBE0', '#31DB92', '#FFFB79', '#FF7F50', '#FF5B5B', '#FF0000')

# Generate Tiles with custom color ramp (can take hours based on the data)
tile(file = tempIn, tiles = outDir, zoom = "0-10", crs = crs, col = colorList)  # Generate tiles

# URL for accessing generated tiles hosted on GitHub
tempURL <- "https://raw.githubusercontent.com/githubUserName/repoName/branch/fileName/{z}/{x}/{-y}.png"

# Create Leaflet Map
leaflet() %>%
  addProviderTiles(providers$Esri.WorldTopoMap, group = "base") %>%
  addTiles(urlTemplate = tempURL, group = 'overlay', tileOptions(opacity = 0.7)) %>%
  setView(lat = 0.382122, lng = -72.063001, zoom = 2)

## if files are hosted locally (file must be in www folder of the shiny app)
tempURL <- "fileName/{z}/{x}/{-y}.png"

leaflet() %>%
  addProviderTiles(providers$Esri.WorldTopoMap, group = "base") %>%
  addTiles(urlTemplate = tempURL, group = 'overlay', tileOptions(opacity = 0.7)) %>%
  setView(lat = 0.382122, lng = -72.063001, zoom = 2)

