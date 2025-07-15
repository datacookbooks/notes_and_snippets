# Encrypting a Local Text File

### Use Case

We may have a local file that has sensitive information. We want to encrypt it.

### Using OpenSSL

Using the Terminal, we navigate to the folder where the file is stored (using the "cd" command).

Then, we use the following command. 

```
openssl enc -aes-256-cbc -pbkdf2 -salt -in YourFileNameHere.txt -out YourFileNameHere.txt.enc
```

This will prompt us for a password. Do not lose it (perhaps store a physical copy of it in a secure on-site location).

When we want to open the file, we again use the Terminal to navigate to the right folder. 

Then we use this command.

```
openssl enc -d -aes-256-cbc -pbkdf2 -in YourFileNameHere.txt.enc -out YourFileNameHere.txt
```

This will prompt you for the password. After entering it, the file will be decrypted and will be viewable. You can delete the .txt file when you are done with it. 
Make sure to keep the txt.enc file. This is what you will use to generate the .txt file (via decryption) when you want to view it. 
