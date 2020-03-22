import get_content
from bs4 import BeautifulSoup
import csv

vol=10000
percent=70
cof_cof=1.5

referer = "https://www.google.com"
url = "https://www.arbworld.net/en/moneyway/mw-1-x-2"
r = get_content.get_content(url,referer)
soup = BeautifulSoup(r.text, 'lxml')

events_file = "arb_1x2" + ".csv"


table1 = soup.find("table", {'class': 'grid'})
for cof_list1 in table1.select("tr", {'class': 'heading'}):
    header_cof = []
    for cof1 in cof_list1.select("td"):
        header_cof.append(cof1.get_text(separator=' '))


with open(events_file, 'w') as csvfile:
    writercol = csv.DictWriter(csvfile, fieldnames=header_cof[3:14])
    writercol.writeheader()

table = soup.find('table', {'id': 'matches' })

for cof_list in table.select("tr", {'class': 'belowHeader'}):
    cof_list_list = []
    for cof in cof_list.select("td"):
        cof_list_list.append(cof.get_text(separator=' '))

    if len(cof_list_list[2:13]) == 0: continue
    if int(cof_list_list[12].replace('€', '').replace(' ', '')) > vol:
        if float(cof_list_list[9].replace('€', '').replace('%', '').split()[0]) > percent:
            if float(cof_list_list[6]) > cof_cof:
                with open(events_file, 'a') as csvfile:
                    writerrow = csv.writer(csvfile)
                    writerrow.writerow(cof_list_list[2:13])
        if float(cof_list_list[10].replace('€', '').replace('%', '').split()[0]) > percent:
            if float(cof_list_list[7]) > cof_cof:
                with open(events_file, 'a') as csvfile:
                    writerrow = csv.writer(csvfile)
                    writerrow.writerow(cof_list_list[2:13])
        if float(cof_list_list[11].replace('€', '').replace('%', '').split()[0]) > percent:
            if float(cof_list_list[8]) > cof_cof:
                with open(events_file, 'a') as csvfile:
                    writerrow = csv.writer(csvfile)
                    writerrow.writerow(cof_list_list[2:13])

