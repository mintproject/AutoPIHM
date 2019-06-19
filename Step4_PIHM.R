# Task:
# 1. Download PIHM++ from GitHub.
# 2. Compile PIHM++ locally. PIHM++ requires Sundials v3.1;  OpenMP and MPI is recommended if using parallel PIHM.
# 3. Run PIHM. And export the screen output of PIHM.
# 4.
# 5.
# 6.
# 7.
# 8.
source('GetReady.R')
cdir=getwd()
# download PIHM++ from github.
destfile=file.path(dir.out, 'PIHM_github.zip')
download.file(url='https://github.com/shulele/PIHM-4.0/archive/master.zip',
              destfile = destfile)

# unzip and compile PIHM++.
unzip(zipfile = destfile, exdir = dir.out)
setwd(file.path(dir.out, 'PIHM-4.0-master'))
cmd='make clean & make pihm'
message('Compile PIHM: ')
message('\t', cmd)
system(cmd, wait = T)
file.rename(from='pihm++', to ='../pihm++')
# Run PIHM
setwd('../')
cmd = paste( paste('./pihm++ ', prjname) )
message('Run PIHM: ')
message('\t', cmd)
sout <-system(cmd, wait = T,intern=TRUE, ignore.stdout = FALSE,
              ignore.stderr = FALSE)
sout
setwd(cdir)
