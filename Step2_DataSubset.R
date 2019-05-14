# Task:
# 1.
# 2.
# 3.
# 4.
# 5.
# 6.
# 7.
# 8.
# pick a subwatershed from the wbd0. Assume the 107-109 sub watersheds in data.
id=107:109  
wbd=wbd0[id,]
writeshape(wbd, file = file.path(dir.pihmgis, 'wbd'))

wbd.dis = gUnaryUnion(wbd) # dissolve the wbd.
#buffer of the wbd, distance=2000m
wbd.buf = gBuffer(wbd.dis, width = 2000) 
writeshape(wbd.buf, file = file.path(dir.pihmgis, 'wbd_buf'))

wbd.gcs=spTransform(wbd.buf, CRSobj = CRS('+init=EPSG:4326'))
writeshape(wbd.gcs, file = file.path(dir.pihmgis, 'wbd_gcs'))

writeshape(stm, file = file.path(dir.pihmgis, 'stm'))
writeRaster(dem,file = file.path(dir.pihmgis, 'dem.tif'), overwrite=T)

# the stream inside of the wbd.
tmp=over(stm0, wbd)
stm=stm0[!is.na(tmp[,1]),]

# crop the elevation data
dem = crop(dem1, wbd.buf)

png.control(fn='Rawdata_Subset.png', path = dir.png, ratio=1)
plot(dem)
plot(wbd.buf, add=T, axes=T, lwd=2)
plot(wbd, add=T, border=3, lwd=2)
plot(stm, add=T, col=2, lwd=2)
title('DEM-WBD-STM')
dev.off()

# =======Soil=============
source('Step2.1_Soil.R')

# =======Land Cover=============
source('Step2.2_Landcover.R')

# =======Forcing=============
source('Step2.3_Forcing.R')

