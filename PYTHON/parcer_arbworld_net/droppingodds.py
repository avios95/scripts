import get_content
from bs4 import BeautifulSoup
import csv

drop=0.5

referer = "https://www.google.com"
url = "https://www.arbworld.net/en/droppingodds"
r = get_content.get_content(url,referer)
soup = BeautifulSoup(r.text, 'lxml')

events_file = "droppingodds" + ".csv"


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
    if float(cof_list_list[6].split()[1])-float(cof_list_list[6].split()[0]) >= drop :
        with open(events_file, 'a') as csvfile:
            writerrow = csv.writer(csvfile)
            row=cof_list_list[2],cof_list_list[3],cof_list_list[4],cof_list_list[5],cof_list_list[6],"","","","",cof_list_list[11],cof_list_list[12]
            writerrow.writerow(row)

    if float(cof_list_list[8].split()[1])-float(cof_list_list[8].split()[0]) >= drop :
        with open(events_file, 'a') as csvfile:
            writerrow = csv.writer(csvfile)
            row=cof_list_list[2],cof_list_list[3],cof_list_list[4],cof_list_list[5],"","",cof_list_list[8],"","",cof_list_list[11],cof_list_list[12]
            writerrow.writerow(row)

    if float(cof_list_list[10].split()[1])-float(cof_list_list[10].split()[0]) >= drop:
        with open(events_file, 'a') as csvfile:
            writerrow = csv.writer(csvfile)
            row=cof_list_list[2],cof_list_list[3],cof_list_list[4],cof_list_list[5],"","","","",cof_list_list[10],cof_list_list[11],cof_list_list[12]
            writerrow.writerow(row)
