from os import path, remove, getcwd
from urllib.request import urlretrieve
import time

dir = getcwd()
url = 'https://www.google.com/favicon.ico'
filename = url.split('/')[-1]
fullpath = path.join(dir, filename)
logfile = path.join(dir, 'download_save.log')

def wlog(text):
    try:
        file = open(logfile, 'a')
        file.write(time.asctime() + " - " + text + '\n')
        file.close()
    except OSError as err:
        print("OS error: {0}".format(err))

def download(u, full, f):
    try:
        if urlretrieve(u, full): wlog('File sucsesfuly downloaded: ' + f)
    except OSError as err:
        wlog('Failed download: ' + f + " OS error: {0}".format(err))

wlog('=====================================')
wlog('dir: ' + dir)
wlog('url: ' + url)
wlog('filename: ' + filename)
wlog('fullpath: ' + fullpath)
if path.exists(fullpath):
    wlog("File was downloaded. Remove file: " + filename)
    remove(fullpath)
    #download(url, fullpath, filename)
    pass
else:
    #download(url, fullpath, filename)
    pass
