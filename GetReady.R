# Task: 
# 1. Set the path to rawdata, output, project name
# 2. Load libraries.
# 3. Create the folders.
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

# dir.rawdata = '/Users/leleshu/Box/South_Sudan/RawData'
dir.rawdata = '/Volumes/WD4T/Box\ Sync/South_Sudan/RawData'

prjname = 'Example'
years = 2017
# years=2017:2018
dir.out = file.path('.', prjname)
dir.png =file.path(dir.out, 'Image')
dir.pihmgis = file.path(dir.out, 'PIHMgis' )
dir.pihmin <- file.path(dir.out, 'input', prjname)
dir.forc <- file.path(dir.out, 'forcing')
dir.fldas = '/Volumes/WD4T/GESDISC_data/data/FLDAS/FLDAS_NOAH01_A_EA_D.001'

fin <- PIHM.filein(prjname, indir = dir.pihmin)
x=list.files(dir.pihmin, pattern = glob2rx(paste0(prjname, '.*.*')), full.names = T)
file.remove(x)
dir.pihmout=dirname(fin['md.mesh'])

tmp=lapply(list(dir.out,dir.png, dir.pihmgis, dir.pihmin, dir.pihmout, dir.forc), dir.create, showWarnings=F, recursive=T)
