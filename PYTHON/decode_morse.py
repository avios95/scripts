def decode_morse(morse_code):
    mtext = ''
    dtext = str('')
    morse_code = morse_code.replace('   ', '+')
    for letter in morse_code:
        if (letter != ' ' and letter != '+'):
            mtext += letter
        else:
            if len(mtext) == 0: continue
            dtext += MORSE_CODE.get(mtext)
            if letter == '+': dtext += '+'
            mtext = ''

    if len(mtext) != 0:  dtext += MORSE_CODE.get(mtext)
    dtext = dtext.replace('+', ' ')
    return dtext
