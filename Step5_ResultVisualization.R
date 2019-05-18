# Task:
# 1.
# 2.
# 3.
# 4.
# 5.
# 6.
# 7.
# 8.
PIHM(prjname = prjname, inpath = dir.pihmin, outpath = dir.pihmout)

cfg.para = readpara()
vns= c("eleysurf","eleyunsat","eleygw",
       "elevprcp","elevetp", 
       "elevinfil","elevrech",
       "elevet0", "elevet1", "elevet2", 
       "rivqdown","rivqsub", "rivqsurf","rivystage")

xl=BasicPlot(imap = T)

wb=wb.all(xl=xl, apply.weekly)
