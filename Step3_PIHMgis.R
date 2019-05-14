# Task:
# 1.
# 2.
# 3.
# 4.
# 5.
# 6.
# 7.
# 8.
rm(list=ls())
source('GetReady.R')
source('Rfunction/SoilGeol.R')
wbd=readOGR(file.path(dir.pihmgis, 'wbd.shp'))
riv=readOGR(file.path(dir.pihmgis, 'stm.shp'))
dem=raster(file.path(dir.pihmgis, 'dem.tif'))
sp.forc=readOGR(file.path(dir.pihmgis, 'FLDAS.shp') )
sp.forc
wbd.buf=gBuffer(wbd, width=2000)

png.control(fn=paste0('PIHMgis_','data', '.png'), path = dir.png, ratio=1)
plot(dem);grid()
plot(wbd.buf, add=T, axes=T, lwd=2)
plot(wbd, add=T, border=3, lwd=2)
plot(riv, add=T, col=2, lwd=2)
plot(sp.forc, add=T, lwd=0.5, lty=2)
title('DEM-WBD-RIV')
dev.off()

forc.fns=paste0('X', round(sp.forc$xcenter, 2) * 100, 'Y', round(sp.forc$ycenter,2)*100, '.csv')

indata =list(wbd=wbd, riv=riv, dem=dem)
graphics.off()

pihmout <- dir.pihmin
fin <- PIHM.filein(prjname, indir = pihmout)
x=list.files(pihmout, pattern = glob2rx(paste0(prjname, '.*.*')), full.names = T)
file.remove(x)

pngout = file.path(pihmout, 'fig')
gisout = file.path(pihmout, 'gis')
dir.create(pihmout, showWarnings = F, recursive = T)
dir.create(pngout, showWarnings = F, recursive = T)
dir.create(gisout, showWarnings = F, recursive = T)

AA1=gArea(wbd)
a.max = AA1/1000;
q.min = 33;
tol.riv = sqrt(a.max)/2
tol.wb = sqrt(a.max)/2
tol.len = sqrt(a.max)/2
AqDepth = 10
ny=length(years)
nday = 365*ny +round(ny/4)

rlc = raster(file.path(dir.pihmgis, 'Landuse_nlcd.tif'))
# alc = unique(rlc)

wbbuf = rgeos::gBuffer(wbd, width = 2000)
dem = raster::crop(dem, wbbuf)

png(file = file.path(pngout, 'data_0.png'), height=11, width=11, res=100, unit='in')
plot(dem); plot(wbd, add=T, border=2, lwd=2); plot(riv, add=T, lwd=2, col=4)
dev.off()

riv.s1 = rgeos::gSimplify(riv, tol=tol.riv, topologyPreserve = T)
# riv.s2 = sp.simplifyLen(riv, tol.len)
# plot(riv.s1); plot(riv.s2, add=T, col=3)
riv.s2=riv.s1

wb.dis = rgeos::gUnionCascaded(wbd)
wb.s1 = rgeos::gSimplify(wb.dis, tol=tol.wb, topologyPreserve = T)
wb.s2 = sp.simplifyLen(wb.s1, tol.len)

png(file = file.path(pngout, 'data_1.png'), height=11, width=11, res=100, unit='in')
plot(dem); plot(wb.s2, add=T, border=2, lwd=2); 
plot(riv.s2, add=T, lwd=2, col=4)
dev.off()


# shp.riv =raster::crop(riv.simp, wb.simp)
# shp.wb = raster::intersect( wb.simp, riv.simp)
wb.simp = wb.s2
riv.simp = riv.s2

tri = m.DomainDecomposition(wb=wb.simp,q=q.min, a=a.max)
# plot(tri, asp=1)

# generate PIHM .mesh 
pm=pihmMesh(tri,dem=dem, AqDepth = AqDepth)
spm = sp.mesh2Shape(pm, crs = crs(riv))
writeshape(spm, crs(wbd), file=file.path(gisout, 'domain'))
plot_sp(spm, 'Zmax')
plot(riv.simp, add=T, col=2, lwd=2)
png.control(fn=paste0('PIHMgis','_domain.png'), path = file.path(dir.png), ratio=1)
plot_sp(spm, 'Zmax')
plot(riv.simp, add=T, col=2, lwd=2)
dev.off()

# generate PIHM .att
# debug(pihmAtt)
pa=pihmAtt(tri, r.soil = spm, r.geol = spm, r.lc = rlc, r.forc = sp.forc )

# write forc file.
writeforc(forc.fns, path='forcing', file=fin['md.forc'])

# generate PIHM .riv
pr=pihmRiver(riv.simp, dem)
# Correct river slope to avoid negative slope
# pr = correctRiverSlope(pr)

# PIHMriver to Shapefile
# spr = sp.riv2shp(pr)
spr = riv
writeshape(spr, crs(wbd), file=file.path(gisout, 'river'))

# Cut the rivers with triangles
# sp.seg = sp.RiverSeg(pm, pr)
sp.seg=sp.RiverSeg(spm, spr)
writeshape(sp.seg, crs(wbd), file=file.path(gisout, 'seg'))

# Generate the River segments table
prs = pihmRiverSeg(sp.seg)

# Generate initial condition
pic = pihm.init(nrow(pm@mesh), nrow(pr@river))

# Generate shapefile of river
# spr = sp.riv2shp(pr); 

# Generate shapefile of mesh domain
sp.dm = sp.mesh2Shape(pm)
png(file = file.path(pngout, 'data_2.png'), height=11, width=11, res=100, unit='in')
zz = sp.dm@data[,'Zsurf']
ord=order(zz)
col=terrain.colors(length(sp.dm))
plot(sp.dm[ord, ], col = col)
plot(spr, add=T, lwd=3)
dev.off()

# model configuration, parameter
cfg.para = pihmpara(nday = nday)
# calibration
cfg.calib = pihmcalib()


#soil/geol/landcover
# lc = unlist(alc)
# para.lc = PTF.lc(lc)
para.lc = read.table(file.path(dir.pihmgis,'LanduseTable.csv'), header = T)

asoil=SoilGeol(spm=spm, rdsfile = file.path(dir.pihmgis, 'Soil_sl1.RDS')  )
ageol=SoilGeol(spm=spm, rdsfile = file.path(dir.pihmgis, 'Soil_sl7.RDS')  )

para.soil = PTF.soil(asoil)
para.geol = PTF.geol(ageol)

# 43-mixed forest in NLCD classification
# 23-developed, medium           
# 81-crop land
# 11-water
lr=fun.lairl(lc, years=years)
png(file = file.path(pngout, 'data_lairl.png'), height=11, width=11, res=100, unit='in')
par(mfrow=c(2,1))
col=1:length(lc)
plot(lr$LAI, col=col, main='LAI'); legend('top', paste0(lc), col=col, lwd=1)
plot(lr$RL, col=col, main='Roughness Length'); legend('top', paste0(lc), col=col, lwd=1)
dev.off()
write.tsd(lr$LAI, file = fin['md.lai'])
write.tsd(lr$RL, file = fin['md.rl'])

#MeltFactor
mf = MeltFactor(years = years)
write.tsd(mf, file=fin['md.mf'])

# write PIHM input files.
writemesh(pm, file = fin['md.mesh'])
writeriv(pr, file=fin['md.riv'])
writeinit(pic, file=fin['md.ic'])

write.df(pa, file=fin['md.att'])
write.df(prs, file=fin['md.rivseg'])
write.df(para.lc, file=fin['md.lc'])
write.df(para.soil, file=fin['md.soil'])
write.df(para.geol, file=fin['md.geol'])

write.pc(cfg.para, fin['md.para'])
write.pc(cfg.calib, fin['md.calib'])
print(nrow(pm@mesh))
