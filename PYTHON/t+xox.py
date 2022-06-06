import time
import random

import telebot
from telebot.types import InlineKeyboardButton
from telebot.types import InlineKeyboardMarkup

win_combinations = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
start = ['Старт', 'Відміна']
xo = ['X', 'O']

current_player = 'O'
r = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]


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

def check_n(table):
    n_status = "False"
    count = 0


    for key in table:
        if key not in '123465789':
            count += 1
            if count == 9:
                n_status = "True"
                global rows, l
                l = get_text_row(table)
                rows = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    return n_status

def check_win(current_player, table):
    win_status = "False"

    for combination in win_combinations:
        count = 0
        for key in combination:
            if current_player in table[key - 1]: count += 1
            if count == 3:
                win_status = "True"
                global rows, l
                l = get_text_row(table)
                rows = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    return win_status


def make_table(r):
    keyboard = InlineKeyboardMarkup(row_width=3)
    buttons = []
    for i in r:
        if i in 'XO' or i == 'Старт' or i == 'Відміна':
            buttons.append(
                InlineKeyboardButton(text=str(i), callback_data=str(i)))
        else:
            buttons.append(
                InlineKeyboardButton(text=str('  '), callback_data=str(i)))

    return keyboard.add(*buttons)

def get_text_row(l):
    for i in l:
        if i in '123456789':
            l[int(i)-1] = "__"
    return f"{l[0]} | {l[1]} | {l[2]}\n{l[3]} | {l[4]} | {l[5]}\n{l[6]} | {l[7]} | {l[8]}"


while True:
    bot = telebot.TeleBot('15697uVO6I')
    users = {}
    rows = r


    @bot.message_handler(commands=['start'])
    def category(message):
        keyboard = InlineKeyboardMarkup()
        keyboard.add(InlineKeyboardButton('X', callback_data='X'), InlineKeyboardButton('O', callback_data='O'))
        bot.send_message(message.chat.id, "Виберіть гравця.", reply_markup=keyboard)


    @bot.callback_query_handler(func=lambda call: True)
    def callback_inline(call):
        if call.message:
            if 'X' not in rows and 'O' not in rows and call.data in 'XO':

                global current_player, bot_player
                current_player = call.data
                if current_player == 'X':
                    bot_player = 'O'
                else:
                    bot_player = 'X'

                bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id,
                                      text="Виберіть місце де хочете поставити символ.", reply_markup=make_table(rows))
            elif call.data == 'Старт':
                bot.send_message(chat_id=call.message.chat.id, text="Виберіть гравця.", reply_markup=make_table(xo))

            elif call.data == 'Відміна':
                bot.send_message(chat_id=call.message.chat.id, text="Гарного настрою)")

            elif call.data in '123456789':

                rows[int(call.data) - 1] = current_player

                if check_win(current_player, rows) != "False":
                    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id,
                                          text=f"Виграв {current_player}\n{l}", reply_markup=make_table(start))
                elif check_n(rows) != "False":
                    bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id,
                                          text=f"Гарна гра, нічия.\n{l}", reply_markup=make_table(start))
                else:
                    rows[bot_input_value(rows, bot_player) - 1] = bot_player

                    if check_win(bot_player, rows) != "False":
                        bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id,
                                              text=f"Виграв {bot_player}\n{l}", reply_markup=make_table(start))
                    elif check_n(rows) != "False":
                        bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id,
                                              text=f"Гарна гра, нічия.\n{l}", reply_markup=make_table(start))
                    else:
                        bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id,
                                          text=" Виберіть місце де хочете поставити символ.",
                                          reply_markup=make_table(rows))

            else:
                bot.edit_message_text(chat_id=call.message.chat.id, message_id=call.message.message_id,
                                      text="Щось пішло не так. Зробіть вибір знову", reply_markup=make_table(rows))
        else:
            pass

    bot.polling()
