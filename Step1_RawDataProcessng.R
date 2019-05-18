# Task:
# 1. Load the rawdata
# 2. 
# 3.
# 4.
# 5.
# 6.
# 7.
# 8.
# Notice:
# 1. The DEM data is merged before this step. The country-wide DEM should be merged.
# 2. Te wbd and stm data must be ready before this step.

source('GetReady.R')
# Elevation
dem0=raster(fr.dem)

# Watershed Boundary
wbd0 = readOGR(fsp.wbd)

# Stream Network
stm0 = readOGR(fsp.stm)

# reproject the dem data from GCS to PCS
dem1=projectRaster(from=dem0, crs=crs(wbd0))
# # save the data
writeRaster(dem1,filename = file.path(dir.pihmgis, 'dem.tif'), overwrite=TRUE)
dem1= raster(file.path(dir.pihmgis, 'dem.tif'))

png.control(fn='Rawdata_Elevation.png', path = dir.png, ratio = 1)
plot(dem1)
plot(wbd0, add=T, border=2)
plot(stm0, add=T, col=4)
dev.off()

