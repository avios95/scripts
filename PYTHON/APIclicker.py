#API для сайта https://www.clck.ru/

import urllib.request                                                           #Импорт модуля urllib.request (для python2 urllib2)
url = 'https://php-academy.kiev.ua/blog/using-the-requests-module-in-python'    #Урл который нужно скоротить
link = urllib.request.urlopen('https://clck.ru/--?url='+url)                    #Открытия сформированого урла
print(link.read().decode('utf-8'))                                              #Вывод текста на странице в UTF8 формате

#API для сайта https://www.clck.ru/

import requests                                                                 #Импортируем модуль requests
url = 'https://php-academy.kiev.ua/blog/using-the-requests-module-in-python'    #Урл который нужно скоротить
link = requests.get('https://clck.ru/--?url='+url)                              #Открытия сформированого урла
print(link.text)                                                                #Выводим страницу в консоль

#API для сайта https://www.clck.ru/
