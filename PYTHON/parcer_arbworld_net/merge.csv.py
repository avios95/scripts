import csv
import requests
import time


def sendtelegram(text):
    url = "https://api.telegram.org/bot712301941:AAG17pmlp4jSM5ERYLR9YJrY3cl6CSAAb1I/sendMessage"
    data = {'chat_id': "262937164",
            'text': text}
    requests.post(url, data=data)

with open('droppingodds.csv', "r") as file1:
    read1 = csv.reader(file1, delimiter=',')
    for row1 in read1:
        with open('arb_1x2.csv', "r") as file2:
            read2 = csv.reader(file2, delimiter=',')
            for row2 in read2:
                if row2[2].strip() in row1[2].strip() and row2[3].strip() in row1[9].strip():
                    text =  row2 + row1[6:9]
                    score='New_Score '+time.strftime( '%H:%M %d.%m.%Y', time.localtime())
                    if row2[2].strip() in "Home":
                        sendtelegram(score)
                        continue
                    a=''
                    for i in text:
                        a=a+i+" "

                    sendtelegram(a)



