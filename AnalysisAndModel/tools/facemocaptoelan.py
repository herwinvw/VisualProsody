import csv
import os
corpusdir = "../corpus/IEMOCAP_full_release/";
def toelan(infile, outfile):
	with open(infile) as input:
		with open(outfile,'wb') as output:
			reader = csv.reader(input, delimiter=' ')
			writer = csv.writer(output, delimiter=',')
			header = reader.next()
			head = [header[1]]
			for h in header[2:]:
				head = head + [h+"x", h+"y", h+"z"]
			writer.writerow(head)
			reader.next() #skip 2nd row
			for row in reader:				
				writer.writerow(row[1:])
			
def toelansession(dir):
	for subdir in os.listdir(dir):
		for infile in os.listdir(dir+"/"+subdir):
			if infile.endswith(".txt"):
				toelan(dir+"/"+subdir+"/"+infile,dir+"/"+subdir+"/"+infile.replace(".txt","_elan.csv"))
			
for session in os.listdir(corpusdir):
	if 	session.startswith("Session"):
		toelansession(corpusdir+session+"/sentences/MOCAP_rotated")