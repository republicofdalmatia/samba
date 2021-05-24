# Quick reference
* Read more about Samba at: https://www.samba.org/

# What is Samba?
Samba provides secure, stable and fast file and print service sharing for all clients using SMB/CIFS protocol, such as all versions of DOS and Windows, OS/2, Linux and many others.

# How to use this image?
## Start Samba instance
Start Samba server with default settings:

    $ docker run -d --name my-samba republicofdalmatia/samba:latest

...where `my-samba` is the name of a container. Your Samba server will be available on your container IP address and ports 139 and 445.
* **Port 139**: Original port for SMB running on top of NetBIOS, an older transport layer that allows Windows computers to talk to each other on the same network.
* **Port 445**: Newer version of SMB (post Windows 2000) running on top of TCP, which allows SMB to work over the Internet.

To expose these ports to your local network publish the two ports:

    $ docker run -d --name my-samba -p 139:139 -p 445:445 republicofdalmatia/samba:latest

...and you can access your Samba shares by typing `smb://<your_ip_address>/` into file browser.

## Persistent storage
In order to persist shared directories mount `/home` and/or `/sambashare` directories when starting the container:

    $ docker run -d --name my-samba -v /host/dir/users/:/home -v /host/dir/shares/:/sambashare republicofdalmatia/samba:latest

...where `/host/dir/users/` and `/host/dir/shares/` are directories on your host machine where you want to keep persistant storage. Samba has several directories/files you could/should persist:
* `/home`: this is a directory where separate user home directories are created, which are automatically exposed as Samba shared directories. By default, user `samba` will be created with `/home/samba` as its home directory available as Samba share at `smb://<samba_ip_address>/samba` accessible with username `samba` and password `samba`.
* `/sambashare`: this is a directory where you can create other Samba shares for collaborative work. By deafult, `public` share is created at `/sambashare/public` available without authentication.
* `/etc/samba/smb.conf`: this is the main configuration file.

## Environment variables
By default the image creates default `samba` user with `samba` password. Use env variables to change that:

    $ docker run -d --name my-samba -e USERNAME=myusername -e PASSWORD=mypassword republicofdalmatia/samba:latest

...where `myusername` is your username and `mypassword` is your password.

To change other default settings check out available evn variables:

#### `USERNAME`
This variable is *optional*. It defines username for a single user created when starting the container. Default value is `samba`.

#### `PASSWORD`
This variable is *optional*. It defines password for a single user created when starting the container. Default value is `samba`.

#### `WORKGROUP`
This variable is *optional*. It defines workgroup for directory sharing. Defautl value is `WORKGROUP`.

#### `PUBLIC`
This variable is *optional*. It defines if a public shared directory without authetication should be made available or not. Default values is `no`. Available options: `yes`/`no`.

## Adding users and shares
In order to add new users and shares you have to `exec` into the container and create users manually:

    $ docker exec -it my-samba /bin/bash
    $$$ useradd -m -s /usr/sbin/nologin -G sambashare newuser
    $$$ printf "newpassword\nnewpassword" | smbpasswd -sa newuser && smbpasswd -e newuser

...where `newuser` is your new username and `newpassword` is a password for the new user. The commands will automatically create a home directory `/home/newuser` that will be available as Samba share at `smb://<samba_ip_address>/newuser` with the defined credentials.

To add custom Samba shares you have to manually change the configuration file located inside the container at `/etc/samba/smb.conf`. Check the official documentation: https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html

## Debugging
To debug the containter start it with bash:

    $ docker run -it --name my-samba republicofdalmatia/samba:latest /bin/bash

To manually start samba server run the following command:
    
    $ /usr/sbin/smbd -FS
