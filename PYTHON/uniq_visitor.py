import csv
import pandas as pd


log = '/home/avios/sever.ml.log'
csv_columns = ['Date', 'IP', 'Count']
csv_file = "uniq_visitor.csv"
date = ''
ips = []

f = open(log, 'r')
for i in f:
    date = i.replace('[', ' ').split()[3].replace(':', ' ').split()[0].replace('/', '-')
    ip = i.split()[0]
    ips.append(date + "," + ip)
f.close()
result = {i: ips.count(i) for i in ips}

try:
    with open(csv_file, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=csv_columns)
        writer.writeheader()
        for key in result.keys():
            csvfile.write("%s,%s\n" % (key, result[key]))

    df = pd.read_csv(csv_file, delimiter=',')
    df = df.sort_values(['Date', 'IP'])
    df.to_csv('sorted.csv')

except IOError:
    print("I/O error")
