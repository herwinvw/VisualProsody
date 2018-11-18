import csv
import os
import glob
corpusdir = "../corpus/IEMOCAP_full_release/";
def getTrim(session_nr,interaction,gender,id):
	session_id="Ses0"+str(session_nr)
	with open(corpusdir+"Session"+str(session_nr)+"/sentences/ForcedAlignment/"+session_id+gender+"_"+interaction+"/"+id+".syseg") as seg:
		f = csv.reader(seg,delimiter=' ',skipinitialspace=True)
		start = 0
		end = 0
		try:
			f.next()
			row = f.next()
			start = float(row[0])
			end = float(row[1])
			for row in f:
				end = float(row[1])
			start=(start+2)/100
			end = (end+2)/100
		except StopIteration:
			pass
		return [start,end]

def overlap(session_nr,interaction,gender):
	session_id="Ses0"+str(session_nr)
	with open(corpusdir+"Session"+str(session_nr)+"/dialog/lab/"+session_id+"_"+gender+"/"+session_id+gender+"_"+interaction+".lab") as recorded:
		if gender=="F":
			partner_gender="M"
		else:
			partner_gender="F"
		
		total_duration = 0
		overlap_duration = 0
		with open(corpusdir+"Session"+str(session_nr)+"/dialog/lab/"+session_id+"_"+partner_gender+"/"+session_id+gender+"_"+interaction+".lab") as partner:
			fpart = csv.reader(partner, delimiter=' ')
			fpart_rows = []
			for row_partner in fpart:
				if row_partner[2]!="d":
					fpart_rows.append(row_partner)
			frec = csv.reader(recorded, delimiter=' ')
			for row_rec in frec:
				sr = float(row_rec[0])
				er = float(row_rec[1])
				id = row_rec[2]
				if id=="d":
					continue
				trim = getTrim(session_nr,interaction,gender,id)
				er = sr+trim[1]
				sr = sr+trim[0]
				total_duration+=er-sr
				fpart = csv.reader(partner, delimiter=' ')
				for row_partner in fpart_rows:
					sp = float(row_partner[0])
					ep = float(row_partner[1])
					id_partner = row_partner[2]
					trim = getTrim(session_nr,interaction,gender,id_partner)
					ep = sp+trim[1]
					sp = sp+trim[0]
					
					if not(ep<sr or sp>er):
						print("Overlap in: "+id+" with "+id_partner+" sr:"+str(sr)+" er:"+str(er)+" sp: "+str(sp)+" ep: "+str(ep))
						overlapstart = 0
						if sp>sr:
							overlapstart = sp-sr
						overlapend = er-sr
						if ep<er:
							overlapend = ep-sr
						print("start: "+str(overlapstart)+" end :"+str(overlapend)+" duration: "+str(overlapend-overlapstart)+"s "+str((overlapend-overlapstart)/(er-sr)*100)+"%")
						overlap_duration+=overlapend-overlapstart
	print("Overlap: "+str(overlap_duration)+"s/"+str(total_duration)+" = "+str(overlap_duration/total_duration*100)+"%")					

overlap(4,"script01_1","F")