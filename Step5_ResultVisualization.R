# Task:
# 1. Configure the Model input/output path and project names.
# 2. The values of your interest.
# 3. Load the time-series (TS) data 
# 4. Do the TS-plot
# 5. 2D spatial plot.
# 6. Water balance calculation.
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
