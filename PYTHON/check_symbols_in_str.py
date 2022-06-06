def is_isogram(string):
    for l in string.lower():
        if string.lower().count(l) > 1: return False

    return True

