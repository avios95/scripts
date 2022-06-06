import random

rows = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
win_combinations = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
count_steps = 0


def print_table(line):
    print(
        f"\t ----------- \n"
        f"\t| {line[0]} | {line[1]} | {line[2]} | \n"
        f"\t|-----------| \n"
        f"\t| {line[3]} | {line[4]} | {line[5]} | \n"
        f"\t|-----------| \n"
        f"\t| {line[6]} | {line[7]} | {line[8]} | \n"
        f"\t -----------  \n")


def bot_input_value(row, cplayer):
    win_combination = []
    for combination in win_combinations:
        count = 0
        for key in combination:
            if str(key) in row[key - 1] or cplayer in row[key - 1]: count += 1
            if count == 3: win_combination = combination

    if len(win_combination) == 3:
        for number in win_combination:
            if str(number) in row[number - 1]:
                break
            else:
                continue
    else:
        number = random.randrange(1, 9)
        if str(number) in row[int(number) - 1]:
            pass
        else:
            number = bot_input_value(row, cplayer)

    return number


def input_value(row):
    print_table(row)
    number = input("Choose number place: ")
    if number.isnumeric() and 1 <= int(number) <= 9:
        if number in row[int(number) - 1]:
            pass
        else:
            print(f"Choose free number")
            number = input_value(row)
    else:
        print(f"Wrong input, input correct number")
        number = input_value(row)

    return int(number)


def check_win(current_player, table):
    win_status = "False"

    for combination in win_combinations:
        count = 0
        for key in combination:
            if current_player in table[key - 1]: count += 1
            if count == 3:
                win_status = "True"

    if win_status == "True":
        print_table(table)
        print(f"Winner player {current_player}. Congratulations!!!")

    return win_status


def set_player():
    symbol = input("Write X or O for choose player: ")
    if not symbol.isnumeric():
        if symbol == "X" or symbol == "x":
            symbol = "X"
        elif symbol == "O" or symbol == "o":
            symbol = "O"
        else:
            print(f"Wrong input, input X or O")
            symbol = set_player()
    else:
        print(f"Wrong input, input X or O")
        symbol = set_player()

    return str(symbol)


##########################################################################################################################
while True:
    count_steps += 1
    if count_steps == 1:
        current_player = set_player()
        human = current_player
    else:
        if current_player == 'X':
            current_player = 'O'
        else:
            current_player = 'X'

    if current_player != human:
        print(f"\n\ncurrent_player: {current_player}")
        rows[bot_input_value(rows, current_player) - 1] = current_player
        print(f"bot made step")
    else:
        print(f"\n\ncurrent_player: {current_player}")
        rows[input_value(rows) - 1] = current_player

    if check_win(current_player, rows) != "False": break

    if count_steps == 9:
        print_table(rows)
        print(f"Winner player X and O. Try again.")
        break
