def get_middle(s):
    word = []
    for w in s:
        word += [w]

    n = len(word)
    if len(word) % 2 != 0:
        return word[int((n - 1) / 2)]
    else:
        return word[int((n / 2) - 1)] + word[int((n / 2))]


