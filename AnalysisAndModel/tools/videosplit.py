import csv
import os
import glob
corpusdir = "../corpus/IEMOCAP_full_release/";
def splitvideo(dir, name, session_id):
	videofile = dir+"/dialog/avi/DivX/"+name+".avi"
	with open(dir+"/dialog/lab/"+session_id+"/"+name+".lab") as csvfile:
		if not os.path.exists(dir+"/sentences/avi/"):
			os.makedirs(dir+"/sentences/avi/")
		f = csv.reader(csvfile, delimiter=' ')
		for row in f:
			start = row[0]
			end = row[1]
			id = row[2]		
			duration = float(end)-float(start)
			if id.startswith(name):
				os.system("ffmpeg -n -i "+videofile+" -ss "+start+" -t "+str(duration)+" -q:a 1 -q:v 1 "+dir+"/sentences/avi/"+id+".mpg")

def splitvideos(dir, session_id, mocap_id):
	labfiles = os.listdir(dir+"/dialog/lab/"+session_id+"_"+mocap_id)
	names = map(lambda x: x.replace(".lab",""), labfiles)
	names = filter(lambda x:x.startswith(session_id+mocap_id),names) #only interested in videos of mocapped actors
	for name in names:
		splitvideo(dir, name,session_id+"_"+mocap_id)

for session in os.listdir(corpusdir):
	if 	session.startswith("Session"):
		splitvideos(corpusdir+session,"Ses0"+session[-1],"F")
		splitvideos(corpusdir+session,"Ses0"+session[-1],"M")