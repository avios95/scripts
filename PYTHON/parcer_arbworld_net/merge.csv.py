import csv

FileOne = open('droppingodds.csv', "r")
FileOneReader = csv.reader(FileOne)
FileTwo = open('arb_1x2.csv', "r")
FileTwoReader = csv.reader(FileTwo)
fileout = open("merge_table.html", "w")

for row2 in FileTwoReader:
    print(row2[2] ,"-----" , row2[3])
    print("===================")
    for row1 in FileOneReader:
        print(row1[2],"-----", row1[9])
