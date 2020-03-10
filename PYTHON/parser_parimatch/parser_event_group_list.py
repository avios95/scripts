import get_content
from bs4 import BeautifulSoup
import json

url = "https://www.parimatch.com"
r = get_content.get_content(url,url).content
data = {}
soup = BeautifulSoup(r, 'lxml')
menu = soup.find('div', {'id': 'lobbyLeftHolder'})
list_group_of_sports = menu.find('div', {'id': 'lobbySportsHolder'})

for list_group in list_group_of_sports.find_all('ul', {'class': 'groups'}):
    group_name = list_group.findPrevious('a').get_text()
    data[group_name] = []
    for list_group_events in list_group.find_all('li'):
        for item in list_group_events.select("a"):
            name_group_events = item.get_text()
            id_group_events = item['hd']
            href_group_events = item['href']
            data[group_name].append({'name': name_group_events, 'id': id_group_events, 'href': href_group_events})

wfile = open('group_events_list.json', mode='w', encoding='UTF-8')
json.dump(data, wfile, indent=4, ensure_ascii=False)
wfile.close()