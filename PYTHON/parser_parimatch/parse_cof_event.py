import get_content
import json
from bs4 import BeautifulSoup
import csv
from tqdm import tqdm

with open('group_events_list.json') as json_file:
    data = json.load(json_file)
    for group in tqdm(data,leave=False):
        for var in data[group]:
            referer = "https://www.parimatch.com" + var['href']
            url = "https://www.parimatch.com/sbet.content.html?hd=" + var['id']
            r = get_content.get_content(url,referer)
            soup = BeautifulSoup(r.text, 'lxml')
            table = soup.find('table', {'id': 'g' + var['id']})

            try:
                table_header_list = []
                for table_header in table.find('tr').find_all('th'):
                    table_header_list.append(table_header.get_text())
                #print(table_header_list)

                events_file = "temp/" + group + ":"+ var['name'] + ".csv"
                with open(events_file, 'w') as csvfile:
                    writercol = csv.DictWriter(csvfile, fieldnames=table_header_list)
                    writercol.writeheader()


                for cof_list in  table.find_all('tr', class_="bk"):
                    cof_list_list = []
                    for cof in cof_list.select("td"):
                        cof_list_list.append(cof.get_text(separator=' '))
                    #print(cof_list_list)

                    with open(events_file, 'a') as csvfile:
                        writerrow = csv.writer(csvfile)
                        writerrow.writerow(cof_list_list)
            except:
                pass
