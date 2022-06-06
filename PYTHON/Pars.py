import requests                             #импортируем модуль
url = 'https://sdsfsd/accounts/login/'  #переменная для страницы логина
s = requests.Session()                      #переменная функции открытия сесии
r = s.get(url)                              #переменная фунции GET запроса
csrf_token = r.cookies['csrftoken']         #нужно для получения куков и построения сесии

data = {                                    #Создаем словарь для POST запроса(Чтоб потом залогинится с этими данными)
    'username':        'avios',
    'password':         'ewwefwe4552dg3gvf',
    'csrfmiddlewaretoken': csrf_token

}

d = s.post(url, data=data, headers=dict(Referer=url))   #Делаем сам запрос на аторизацию на сайте(можно без переменной)
dd = s.get('https://dfsfsd/9450/')     #"Стягиваем" нужную нам страницу
print(dd.text)                                          #Выводим страницу в консоль

# Для всех POST запросов использующих механизм сессии класс производит проверку наличия и правильности
# csrfmiddlewaretoken. Если такого поля у передаваемой формы нет, то пользователь получает ошибку 403
