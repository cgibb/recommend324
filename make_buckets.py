#!/usr/bin/python

with open("profile-playcounts", "r") as input:
	for i in range(1,11): # 10 buckets
		buckname = "lfm-" + str(i)
		with open(buckname, "w+") as bucket:
			for j in range(1,1000):
				bucket.write(input.readline())

