def to_jaden_case(string):
    word = ''
    endstring = ''
    for letter in string:
        if letter != ' ':
            word +=letter
        else:
            endstring += word.capitalize() + " "
            word =''
    if len(letter) != 0: endstring += word.capitalize()
    return endstring