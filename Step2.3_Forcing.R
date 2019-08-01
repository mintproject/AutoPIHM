
ext = extent(wbd.gcs)
xloc=seq(ext.fldas[1], ext.fldas[2], by=res)
yloc=seq(ext.fldas[3], ext.fldas[4], by=res)
fx <- function(x, xx, LB=TRUE){
  if(LB){
    dx = xx - x
    dx[dx > 0] = min(dx)
    return(xx[which(dx>=max(dx)) ])
  }else{
    dx = xx - x
    dx[dx < 0] = max(dx)
    return(xx[which(dx<=min(dx) )])
  }
}

ext.fn=c(fx(ext[1], xloc, LB=T),
         fx(ext[2], xloc, LB=F),
         fx(ext[3], yloc, LB=T),
         fx(ext[4], yloc, LB=F))

sp.fn =fishnet(crs =crs(wbd.gcs), dx=.1, ext = ext.fn)
id=which(gIntersects(sp.fn, wbd.gcs, byid = T))
sp.fldas = sp.fn[id,]
writeshape(sp.fldas, file=file.path(dir.pihmgis, 'FLDAS_GCS'))

sp.fldas.pcs = spTransform(sp.fldas, crs(wbd.buf))
writeshape(sp.fldas.pcs, file=file.path(dir.pihmgis, 'FLDAS'))

png.control(fn=paste0('Rawdata','_FLDAS.png'), path = file.path(dir.png), ratio=1)
plot(sp.fn, axes=T); grid()
plot(sp.fldas, add=T, col=3)
plot(wbd.gcs, add=T, border=4, lwd=2)
title('FLDAS')
dev.off()

if (res == 0.1) {
  source('Rfunction/FLDAS_nc2RDS.R') # read the orginal fldas data and save to .RDS file.
  source('Rfunction/FLDAS_RDS2csv.R') # read the RDS above, to save as .csv file.
} else {
  source('Rfunction/GLDAS_nc2RDS.R') # read the orginal fldas data and save to .RDS file.
  source('Rfunction/GLDAS_RDS2csv.R') # read the RDS above, to save as .csv file.
}
