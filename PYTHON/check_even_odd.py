def evens_and_odds(n):
    if (n % 2) == 0: return bin(n).replace('0b','')
    else: return hex(n).replace('0x','')

def find_it(seq):
    for i in seq:
        if (seq.count(i) % 2) != 0: return i
