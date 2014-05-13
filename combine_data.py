#!/usr/bin/python

months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
with open("usersha1-artmbid-artname-plays.tsv", "r") as playcounts:
	pcline = playcounts.readline().split() # buffer
	with open("usersha1-profile.tsv", "r") as userinfo:
		with open("profile-playcounts", "w+") as output:
			for line in userinfo:
				line = line.split()
				cache = [];
				if line[1] not in ['m', 'f']:
					line.insert(1, 'x')
				cache.append(line[1]) # gender
				if not line[2].isdigit():
					line.insert(2, '21') # Roll with a default
				cache.append(line[2]) # age
				country = '"'+line[3];
				i = 4
				while (i < len(line) and line[i] not in months):
					country += " " + line[i];
					i += 1
				cache.append(country + '"')
				cache.append('"' + "".join(line[i:]) + '"') # Date
				cache = " ".join(cache) + " "
				print line
				print pcline
				while (pcline[0] == line[0]): # uid matches
					print pcline
					meshed = []
					for thing in pcline[1:]:
						meshed.append(thing)
					output.write(cache +  " ".join(meshed) + '\n')

					pcline = playcounts.readline().split()


