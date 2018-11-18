import os
corpusdir = "../../corpus/IEMOCAP_full_release/";
def processSessionSeg(dir):
	for f in os.listdir(dir):
		if f.endswith("wav"):
			fn = dir+"/"+f
			os.system("SMILExtract_Release.exe -C prosodyAcfLe2012Reproduction.conf -I "+fn+" -O "+fn+"Le2012ReproductionAcf.csv")
			os.system("SMILExtract_Release.exe -C prosodyShsLe2012Reproduction.conf -I "+fn+" -O "+fn+"Le2012ReproductionShs.csv")
			os.system("SMILExtract_Release.exe -C prosodyAcf.conf -I "+fn+" -O "+fn+"Acf.csv")
			os.system("SMILExtract_Release.exe -C prosodyShs.conf -I "+fn+" -O "+fn+"Shs.csv")

def processSession(dir):
	for f in os.listdir(dir):
		processSessionSeg(dir+"/"+f)

for f in os.listdir(corpusdir):
	if f.startswith("Session"):
		processSession(corpusdir+f+"/sentences/wav/")