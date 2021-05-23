FROM ubuntu:18.04

RUN apt-get update && apt-get install -y samba
RUN mkdir /sambashare && chgrp sambashare /sambashare && mkdir /sambashare/public && chgrp sambashare /sambashare/public && chmod 2777 /sambashare/public

WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

COPY conf/smb.conf /etc/samba/smb.conf

ENV USERNAME=samba PASSWORD=samba WORKGROUP=WORKGROUP PUBLIC=no PRINTERS=no PRINT=no

EXPOSE 137 138 139 445

ENTRYPOINT ["./entrypoint.sh"]
CMD ["/usr/sbin/smbd", "-FS"]
