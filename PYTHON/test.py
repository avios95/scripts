from faker import Factory
from mysql.connector import MySQLConnection, Error
import mysql.connector, re


fake = Factory.create()
address = fake.address()
address = re.sub('\n.*','' , address)
print(address)