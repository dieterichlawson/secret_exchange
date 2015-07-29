# generate a private key with 8192 bits (some consider this overkill)
# keep this SECRET and DO NOT share with anyone
openssl genrsa -out key.pem 8192
# generate a public key from your private key
# this is ok to share with people
openssl rsa -in key.pem -pubout -out pub_key.pem
