
import requests
city_id = 698462
appid = "5a6c0f6285c82a82a5adcf1895791d5c"



res = requests.get("http://api.openweathermap.org/data/2.5/weather",
             params={'id': city_id, 'units': 'metric', 'lang': 'ru', 'APPID': appid})
data = res.json()
print("conditions:", data['weather'][0]['description'])
print("temp:", data['main']['temp'])
print("temp_min:", data['main']['temp_min'])
print("temp_max:", data['main']['temp_max'])




res = requests.get("http://api.openweathermap.org/data/2.5/forecast",
                   params={'id': city_id, 'units': 'metric', 'lang': 'ru', 'APPID': appid})
data = res.json()
for i in data['list']:
    print( i['dt_txt'], '{0:+3.0f}'.format(i['main']['temp']), i['weather'][0]['description'] )
