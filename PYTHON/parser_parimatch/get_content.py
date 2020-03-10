from user_agent import generate_user_agent
import requests

def get_content(url,ref):
    try:
        headers={'User-Agent': generate_user_agent(), 'referer': ref}
        r = requests.get(url, headers=headers)
        return r
    except:
        return 0
