#!/usr/bin/env bash

RECIPIENT_PUBLIC_KEY=$1
SENDER_PRIVATE_KEY=$2
PLAINTEXT=$3
# add secret and their public key to tar file
cp $PLAINTEXT plaintext
cp $RECIPIENT_PUBLIC_KEY to.pem
tar -c plaintext to.pem > addressed_plaintext.tar
rm to.pem plaintext
# sign digest of tar
openssl dgst -sha256 -sign $SENDER_PRIVATE_KEY -out signature addressed_plaintext.tar
# add plaintext and signature to new tar file
tar -c addressed_plaintext.tar signature > signed_plaintext.tar
# create random password for aes key
openssl rand -base64 32 > aes_pwd
# encrypt tarfile with aes using aes_pwd
cat aes_pwd | openssl aes-256-cbc -a -base64 -salt -in signed_plaintext.tar -pass stdin -out signed_plaintext.enc
# encrypt aes password using recipient public key
openssl rsautl -encrypt -inkey $1 -pubin -in aes_pwd -out aes_pwd.enc
# add encrypted aes password and encrypted tar file to a new tarfile
tar -c signed_plaintext.enc aes_pwd.enc > encrypted.tar
rm addressed_plaintext.tar signature signed_plaintext.tar signed_plaintext.enc \
  aes_pwd aes_pwd.enc
