from urllib.request import urlopen
import time

i = ''

def connected():
    try:
        urlopen('http://google.com')
        return True
    except:
        return False

while i != 'connected':
    if connected():
        i = 'connected'
        print(i)
    else:
        i = 'no_internet'
        print(i)
        time.sleep(2)

