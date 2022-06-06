import requests
token= '551JXSTtayj2Q'
url = f"https://api.telegram.org/bot{token}/sendMessage"
chat_id='-1043'

text = 'Бажаєте пограти в хрестики-нолики? Переходьте до боту: @sendpassbot та тисніть Старт'
requests.post(url, data={'chat_id': chat_id, 'text': text})

