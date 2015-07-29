#!/usr/bin/env bash
RECIPIENT_PRIVATE_KEY=$1
RECIPIENT_PUBLIC_KEY=$2
SENDER_PUBLIC_KEY=$3
ENCRYPTED_FILE=$4
tar xf $ENCRYPTED_FILE
openssl rsautl -decrypt -inkey $RECIPIENT_PRIVATE_KEY -in aes_pwd.enc -out aes_pwd
cat aes_pwd | openssl aes-256-cbc -d -base64 -pass stdin -in signed_plaintext.enc -out signed_plaintext.tar
tar xf signed_plaintext.tar
openssl dgst -sha256 -verify $SENDER_PUBLIC_KEY -signature signature addressed_plaintext.tar
tar xf addressed_plaintext.tar
if diff to.pem $RECIPIENT_PUBLIC_KEY >/dev/null ; then
    echo "Adress verified"
  else
    echo "Adress verification failed"
fi
cat plaintext
rm aes_pwd.enc aes_pwd signed_plaintext.enc signed_plaintext.tar \
  signature addressed_plaintext.tar to.pem
