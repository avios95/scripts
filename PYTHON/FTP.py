import ftplib                                               #Импорт модуля ftplib
import os
import time

start_time = time.time()

HOST = 'ftp.server.net'
PORT = 21
FTP_USER = 'safasf'
FTP_PASS = 'saffas'
source_dir = '/home/avios/test'
ftp_dir = '/test1'


def send_dir(dir):

    for file in os.listdir(dir):
        path = os.path.join(dir, file)
        if not os.path.isdir(path):
            sendfile = open(path, 'rb')
            ftp.storbinary('STOR ' + file, sendfile)
            sendfile.close()
            # time.sleep(0.01)
            print("Uploaded file: " + file)
        else:
            print ("Directory finded: " + path)
            ftp.mkd(file)
            ftp.cwd(file)
            send_dir(path)


with ftplib.FTP(host=HOST) as ftp:                          #Передача конструктору имя хоста(может быть указан IP)
    try:
        print (ftp.getwelcome())                            #Вывод кода состояния подлючения к серверу FTP
        ftp.connect(port=PORT)                              #Открытие соединения по указаном порту(если используется нестандартный)
        ftp.login(user=FTP_USER, passwd=FTP_PASS)           # Указание аутентификационных данных и аутентификация
        # ftp.set_pasv(True)                                #Включает пасивный режим
        ftp.mkd(ftp_dir)
        ftp.cwd(ftp_dir)
        print("PWD: " + ftp.pwd())                          # Получения значения текущей директории
        send_dir(source_dir)
        print("PWD: " + ftp.pwd())
        ftp.quit()                                          # Закрытие соединения с FTP сервером

    except ftplib.all_errors as e:
        print('FTP error:', e)                              #Вывод ошибки подключения


print("--- %s seconds ---" % (time.time() - start_time))
