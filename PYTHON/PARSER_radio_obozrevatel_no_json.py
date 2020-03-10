#!/usr/bin/python3
# -*- coding: UTF-8 -*-



# Пример для запуска парсера:
#     /usr/bin/python3 Test.py -u http://radio.obozrevatel.com/ua/newplayer/rplaylists/1180 --dir /media/avios/420E496E79278527/test3/


import urllib.request                                                   #импорт модуля POST GET запросов
from bs4 import BeautifulSoup                                           #импорт модуля для навигации по html и xml коду
import sys                                                              #импорт модуля для поддержки получения аргументов для парсера через командную строку
import os                                                               #Импорт модуля для работы с файловой системой


def main(url,dir):                                                      #Главная функция
    r = urllib.request.urlopen(url)                                     #Переменная открытия урла
    if os.path.exists(dir):                                             #Проверка существования заданой директории# существует
        print("Dir is OK!")
    else:                                                               #Не существует
        print("No directories found! Directory will be made!")
        os.makedirs(dir)                                                #Создание директории по заданом пути(с подкаталогами если потребуется)

    return getlistsong(r.read().decode('utf-8'),dir)                    #Возврат функции getlistsong html кода и заданой директории


def getlistsong(html,dir):                                              #Функция построения списка песен с исполнителем, названием песни и URL c плейлиста
    soup = BeautifulSoup(html, 'lxml')                                  #Парсер для синтаксического разбора файлов HTML   http://wiki.python.su/Документации/BeautifulSoup
    all_list = []                                                       #Создаем пустой список
    for playlist in soup.find_all('ul', class_='play-lst'):             #Ищем начало таблицы с класом play-lst
        for element in playlist.find_all('li', class_=''):              #Ищем елементы списка таблицы
            all_atr = {}                                                #обнуляем словарь
            all_atr["Url"] = "http://radio.obozrevatel.com/files/audio/" + element['dir'] + "/" + element['code'] + ".mp3" #Добавляем значение с ключем URL в словарь
            for name in element.find_all('div', class_='name'):         #Ищем тег div c класом name и получаем код страницы что внутри тега
                for singer in name.find('a'):                           #Ищем тег a и получаем <a>его содержимое<a/>
                    all_atr["Artist"] = singer                          #Добавляем значение с ключем Artist в словарь

                for song_name in name.find('a', class_='song-name'):    #Ищем тег a с класом song-name и получаем <a>его содержимое<a/>
                    all_atr["Song_name"] = song_name                    #Добавляем значение с ключем Song_name в словарь
                all_list.append(all_atr)                                #Добавляем собраный словарь в список
        return downloader(all_list, dir)                                #Возвращаем функции downloader переменные all_list  и дир

def downloader(all_list, dir):                                          #Функция скачивания файло по заранеее подготовленом списку
    for i in all_list:                                                  #Читаем чписок словарей
        url = i['Url']                                                  #получаем переменную url из ключа Url из словаря
        filename = i['Artist'] + '-' + i['Song_name'] + '.mp3'          #Формирование имени файла
        if os.path.exists(dir + filename):                              #Проверка существования файла #файл существует
            print("File was downloaded: " + filename)
        else:                                                           #файл не существует
            print("Download: " + filename)
            urllib.request.urlretrieve(url, dir + filename)             #Скачиваем файл и указываем куда сохранить и с каким именем


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




