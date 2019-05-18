#!/usr/bin/env Rscript
# Task: 
# 1. Set the path to rawdata, output, project name
# 2. Load libraries.
# 3. Create the folders.
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  fn.prj='project.txt'
  # stop("At least one argument must be supplied (input file).n", 
  #      call.=FALSE)
}else{
  print(args)
  fn.prj = args[1]
}
message('Reading project file ', fn.prj)
if(file.exists(fn.prj)){
  tmp=as.matrix(read.table(fn.prj, header = F, row.names = 1))
  cdir = tmp[,1]
  print(cdir)
}else{
  stop('File missing: ', fn.prj)
}


dir.rawdata=cdir['dir.rawdata']
dir.soil = cdir['dir.soil']
dir.fldas = cdir['dir.fldas']
dir.out = cdir['dir.out']

prjname=cdir['prjname']
years=as.numeric(cdir['startyear']): as.numeric(cdir['endyear'])

fsp.wbd = cdir['fsp.wbd']
fsp.stm = cdir['fsp.stm']

fr.dem=cdir['fr.dem']
fr.landuse = cdir['fr.landuse']

# years=2017:2018
dir.png =file.path(dir.out, 'Image')
dir.pihmgis = file.path(dir.out, 'PIHMgis' )
dir.pihmin <- file.path(dir.out, 'input', prjname)
dir.pihmout <- file.path(dir.out, 'output', paste0(prjname, '.out') )
dir.forc <- file.path(dir.out, 'forcing')

tmp=lapply(list(dir.out,dir.png, dir.pihmgis, dir.pihmin, dir.pihmout, dir.forc), dir.create, showWarnings=F, recursive=T)


library(raster)
library(sp)
library(rgeos)
library(rgdal)
library(PIHMgisR)
library(lattice)
library(ggplot2)
library(GGally)
library(hydroTSM)
library(hydroGOF)


fin <- PIHM.filein(prjname, indir = dir.pihmin)
x=list.files(dir.pihmin, pattern = glob2rx(paste0(prjname, '.*.*')), full.names = T)
file.remove(x)
