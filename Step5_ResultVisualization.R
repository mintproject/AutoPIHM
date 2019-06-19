# Task:
# 1.
# 2.
# 3.
# 4.
# 5.
# 6.
# 7.
# 8.
source('GetReady.R')
PIHM(prjname = prjname, inpath = dir.pihmin, outpath = dir.pihmout)

cfg.para = readpara()
vns= c("eleysurf","eleyunsat","eleygw",
       "elevprcp","elevetp", 
       "elevinfil","elevrech",
       "elevetic", "elevettr", "elevetev",'elevetp', 
       "rivqdown","rivqsub", "rivqsurf","rivystage")

xl=BasicPlot(varname = vns, imap = T)

wb=wb.all(xl=xl, apply.weekly)
