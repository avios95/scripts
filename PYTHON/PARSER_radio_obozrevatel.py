#!/usr/bin/python3
# -*- coding: UTF-8 -*-

#
# Пример для запуска парсера:
#     /usr/bin/python3 Test.py -u http://radio.obozrevatel.com/ua/newplayer/rplaylists/1180 --dir /media/avios/420E496E79278527/test3/




import urllib.request
from bs4 import BeautifulSoup
import json
import sys
import os


def main(url,dir):
    r = urllib.request.urlopen(url)
    if os.path.exists(dir):   # существует
        print("Dir is OK!")
    else:  # не существует
        print("No directories found! Directory will be made!")
        os.makedirs(dir)

    return getlistsong(r.read().decode('utf-8'),dir)


def getlistsong(html,dir):
    soup = BeautifulSoup(html, 'lxml')
    filename = dir+'list.json'
    wfile = open(filename, mode='w', encoding='UTF-8')
    all_list = []
    for playlist in soup.find_all('ul', class_='play-lst'):
        for element in playlist.find_all('li', class_=''):
            all_atr = {}
            all_atr["Url"] = "http://radio.obozrevatel.com/files/audio/" + element['dir'] + "/" + element['code'] + ".mp3"

            for name in element.find_all('div', class_='name'):
                for singer in name.find('a'):
                    all_atr["Artist"] = singer

                for song_name in name.find('a', class_='song-name'):
                    all_atr["Song_name"] = song_name
                all_list.append(all_atr)

        json.dump(all_list, wfile, indent=4, ensure_ascii=False)
    wfile.close()


def downloader(dir):
    with open (dir + 'list.json') as f:
        data = json.load(f)
        for i in data:
            url = i['Url']
            filename = i['Artist'] + '-' + i['Song_name'] + '.mp3'

            if os.path.exists(dir + filename):# файл существует
                print("File was downloaded: " + filename)
            else: # файл не существует
                print("Download: " + filename)
                urllib.request.urlretrieve(url, dir + filename)


if __name__ == '__main__':
    url = ''
    out_dir = ''
    if len (sys.argv) == 1:
        print("""
        Please run parser from console(you can use --url and --dir  or  -u and -d):
        /usr/bin/python3 /path/to/PARSER_radio_obozrevatel_no_json.py -u http://radio.obozrevatel.com/ua/newplayer/rplaylists/1180 --dir /path/to/dir/for/download/
        """)
    else:
        if len (sys.argv) < 5:
            print ("Error: Too few parameters.")
            sys.exit (1)

        if len (sys.argv) > 5:
            print ("Error. Too many options.")
            sys.exit (1)

        param_name = sys.argv[1]
        param_value = sys.argv[2]
        param_name2 = sys.argv[3]
        param_value2 = sys.argv[4]
        if (param_name == "--url" or param_name == "-u"):
            print ("--url = " + param_value )
            url = param_value
        elif(param_name == "--dir" or param_name == "-d"):
            print("--dir = " + param_value)
            out_dir = param_value
        else:
            print ("Error. Unknow parrametr '{}'".format (param_name) )
            sys.exit (1)

        if (param_name2 == "--url" or param_name2 == "-u"):
            print("--url = " + param_value2)
            url = param_value2
        elif (param_name2 == "--dir" or param_name2 == "-d"):
            print("--dir = " + param_value2)
            out_dir = param_value2
        else:
            print("Error. Unknow parrametr '{}'".format(param_name2))
            sys.exit(1)

        main(url,out_dir)
        downloader(out_dir)






