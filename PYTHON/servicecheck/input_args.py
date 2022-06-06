#!/usr/bin/python
# -*- coding: UTF-8 -*-

import sys
import argparse


def nginx():
    print("nginx")


def atop():
    print("atop")


def log():
    print("log")


def httpd():
    print("httpd")


def mysql():
    print("mysql")



def createParser():
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--nginx', action='store_true', default=False, help = 'Start monitoring nginx')
    parser.add_argument('-a', '--atop', action='store_true', default=False)
    parser.add_argument('-ht', '--httpd', action='store_true', default=False, help = 'Start monitoring httpd')
    parser.add_argument('-m', '--mysql', action='store_true', default=False, help = 'Start monitoring mysql')
    parser.add_argument('-l', '--log', action='store_true', default=False)
    return parser


if __name__ == '__main__':
    parser = createParser()
    namespace = parser.parse_args()

    print(namespace)
    if namespace.nginx:
        nginx()
    if namespace.atop:
        atop()
    if namespace.httpd:
        httpd()
    if  namespace.mysql:
        mysql()
    if namespace.log:
        log()

#python input_args.py nginx httpd mysql log atop
