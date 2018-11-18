import csv
import os
corpusdir = "../corpus/IEMOCAP_full_release/";
def toelan(infile, outfile):
	with open(infile) as input:
		with open(outfile,'wb') as output:
			reader = csv.reader(input, delimiter=' ')
			writer = csv.writer(output, delimiter=',')
			i = 0
			for row in reader:				
				if i != 1:
					writer.writerow(row[1:])
				i = i+1

def toelansession(dir):
	for subdir in os.listdir(dir):
		for infile in os.listdir(dir+"/"+subdir):
			if infile.endswith(".txt"):
				toelan(dir+"/"+subdir+"/"+infile,dir+"/"+subdir+"/"+infile.replace(".txt","_elan.csv"))

for session in os.listdir(corpusdir):
	if 	session.startswith("Session"):
		toelansession(corpusdir+session+"/sentences/MOCAP_head")