vid = avisource("garage_hannah_nomovement_cropped.avi")
bl = blankclip(vid, length=1)
return bl + vid