#!/bin/usr/python
filename = "../tmp/code.html"
madeFile = open(filename, 'r')
lines=madeFile.readlines()
line=lines[1];
editedLine=line[0:97]+"!--"+line[97:172]+"--"+line[172:249]+"!--"+line[249:330]+"--"+line[330:440]+"!-- "+line[440:864]+"--"+line[864:]
madeFile.close()
madeFile = open(filename, 'w')
madeFile.write(lines[0])
madeFile.write(editedLine)
madeFile.close()
