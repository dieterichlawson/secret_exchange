# Secure secret exchange

This repo implements a secure exchange of a plaintext.

For the sender it requires:

* Your private and public key
* The public key of your recipient

For the recipient it requires:

* Your private and public key
* The public key of the sender

For examples of generating keypairs, see examples/key_gen_example.sh

## Basic Usage

#### Encrypting
```
# generate a random plaintext
openssl rand -base64 256 > pt
# pack the plaintext, creates encrypted.tar
sh pack.sh recipient_pub_key.pem sender_key.pem pt
```
#### Decrypting

```
# unpack and verify the plaintext contained in encrypted.tar
sh unpack.sh recipient_key.pem recipient_pub_key.pem sender_pub_key.pem encrypted.tar
```

### NOTE

You should only trust the output of these scripts if the two verification checks pass. This is what a successful run looks like:

```
dlaw > examples $ sh unpack.sh recipient_key.pem recipient_pub_key.pem sender_pub_key.pem encrypted.tar
Verified OK
Adress verified
< plaintext >
```

Unless you see both a `Verified OK` and an `Address verified` then the archive has been tampered or corrupted in some away.

## Method

The packing script performs the following steps:

* adds the plaintext and the public key of the recipient to a tarfile.
* signs a digest of the "addressed" tarfile
* combines the signature and adressed tarfile into a new tarfile
* generates a random AES key
* encryptes the signed tar file with AES-256
* encrypts the AES key with the recipient's public key
* combines the encrypted AES key and encrypted signed tarfile into a new tar file


The unpacking script performs the following steps:

* unpacks the tarfile into the encrypted AES key and the encrypted signed tarfile
* uses the recipient's private key to decrypt the AES key
* uses the AES key to decrypt the encrypted signed tarfile
* unpacks the signed tarfile and verifies the signature
* unpacks the adressed tarfile (which was in the signed tarfile) and verifies the adress
* `cat`s the plaintext
