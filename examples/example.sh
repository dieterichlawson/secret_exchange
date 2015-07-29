# generate a random plaintext
openssl rand -base64 256 > pt
# pack the plaintext
sh ../pack.sh keys/recipient_pub_key.pem keys/key.pem pt
# unpack the plaintext
sh ../unpack.sh keys/recipient_key.pem keys/recipient_pub_key.pem keys/pub_key.pem encrypted.tar
if diff pt plaintext >/dev/null ; then
    echo "Plaintext packed and unpacked successfully."
  else
    echo "Plaintext not recovered."
fi
