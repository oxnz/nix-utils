#!/bin/bash

echo "Make Root Certs:"
openssl genrsa -des3 -out private/ca.key.pem 2048
openssl req -new -key private/ca.key.pem -out ca.req.pem
openssl x509 -req -days 1000 -sha1 -extensions v3_ca -signkey private/ca.key.pem -in ca.req.pem -out certs/ca.crt.pem
echo "Make Server Certs:"
openssl genrsa -des3 -out private/serverkey.pem 1024
openssl req -new -key private/serverkey.pem -out server.req.pem
openssl req -new -key private/client_wang.key.pem -out client_wang.req.pem -subj "/C=CN/ST=GD/L=ST/O=STDX/OU=GX203/CN=Wangyoubang/emailAddress=wangyou@gmail.com"
openssl x509 -req -days 100 -sha1 -extensions v3_req -CA certs/ca.crt.pem -CAkey private/ca.key.pem -CAserial ca.srl -CAcreateserial -in server.req.pem -out certs/server.crt.pem
openssl pkcs12 -export -clcerts -in certs/server.crt.pem -inkey private/serverkey.pem -out certs/server.p12
echo "Make User Certs:"
openssl genrsa -out private/clientkey.pem 1024
openssl req -new -key private/clientkey.pem -out clientkey.req.pem -subj "/C=CN/ST=GD/L=ST/O=STDX/OU=GX203/CN=YunXinyi/emailAddress=yunxinyi@gmail.com"
openssl x509 -req -days 100 -sha1 -extensions v3_req -CA certs/ca.crt.pem -CAkey private/ca.key.pem -CAserial ca.srl -CAcreateserial -in server.req.pem -out certs/client.crt.pem
openssl x509 -req -days 100 -sha1 -extensions v3_req -CA certs/ca.crt.pem -CAkey private/ca.key.pem -CAserial ca.srl -CAcreateserial -in client_wang.req.pem -out certs/client_wang.cer
