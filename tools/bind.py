#!/usr/bin/env python

from socket import *

HOST = ''
PORT = 8000
BUFSIZ = 1024
ADDR = (HOST, PORT)

sock = socket(AF_INET, SOCK_DGRAM)
sock.bind(ADDR)

while True:
    print 'waiting for message ...'
    data, addr = sock.recvfrom(BUFSIZ)
    print repr(data)
    data = data[:2] + '\x81\x80\x00\x01\x00\x01\x00\x00\x00\x00' + data[12:] \
            + '\xc0\x0c\x00\x01\x00\x01\x00\x00\x02\x58\x00\x04\x9b\x21\x11\x44'
    sock.sendto(data, addr)
    print repr(data)
    print '... received from and reply to:', addr

sock.close()
