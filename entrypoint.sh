#!/bin/bash

echo "Creating Linux user $USERNAME"
useradd -m -s /usr/sbin/nologin -G sambashare $USERNAME

echo "Creating Samba user $USERNAME and setting password $PASSWORD"
printf "$PASSWORD\n$PASSWORD" | smbpasswd -sa $USERNAME && smbpasswd -e $USERNAME

echo "Setting workgrou to $WORKGROUP"
sed -i "s|@@@WORKGROUP@@@|$WORKGROUP|g" /etc/samba/smb.conf

echo "Setting public share to $PUBLIC"
sed -i "s|@@@PUBLIC@@@|$PUBLIC|g" /etc/samba/smb.conf

echo "Setting printers to $PRINTERS"
sed -i "s|@@@PRINTERS@@@|$PRINTERS|g" /etc/samba/smb.conf

echo "Setting print drivers to $PRINT"
sed -i "s|@@@PRINT@@@|$PRINT|g" /etc/samba/smb.conf

echo "Running command: $@"
exec "$@"
