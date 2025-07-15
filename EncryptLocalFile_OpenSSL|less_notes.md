# Encrypting & Securely Viewing a Local Text File

### Use Case

We may have a local file that has sensitive information. We want to encrypt it and be able to view it securely.

### Encrypting Using OpenSSL

First, we need to make sure that we save this text file with Unicode UTF-8 encoding. This ensures that the original formatting is preserved when we try to view it securely using "less".

Using the Terminal, we navigate to the folder where the file is stored (using the "cd" command).

Then, we use the following command. 

```
openssl enc -aes-256-cbc -pbkdf2 -salt -in YourFileNameHere.txt -out YourFileNameHere.txt.enc
```

This will prompt us for a password. Do not lose it. Consider storing a physical copy of it in a secure on-site location.

### View The File Securely (Without Writing it to Disk)

When we want to open the file securely, we can use "less". Less is a command-line utility that lets us view the contents of text files.

First, we again use the Terminal to navigate to the right folder. 

Then we use this command.

```
LESSSECURE=1 openssl enc -d -aes-256-cbc -pbkdf2 -in YourFileNameHere.txt.enc | less
```

This will prompt you for the password. After entering it, the decrypted file will be viewable. 
To exit, type "q", and you will be returned back to the Terminal. 
