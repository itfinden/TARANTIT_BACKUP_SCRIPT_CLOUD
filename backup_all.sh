#!/bin/bash
#Verificamos si el directorio Backup existe
csf -a 201.217.242.101

Host=`hostname`

if [ -d '/home/cloud_backup/' ]; then
        echo; echo; echo ""
else
        mkdir /home/cloud_backup
fi

sshfs -o password_stdin -p 7432 Vps79@cloud.itfinden.com:/home/Vps79/ /home/cloud_backup <<< "MICLAVESECRETA"

isMounted=`mount | grep Vps79@cloud.itfinden.com`

if [ -z "$isMounted" ] ; then
        echo "NO ESTA MONTADO";
        /bin/ls -ltr mount | grep Vps79@cloud.itfinden.com |mail -s "Particion Respaldo No Montada $Host" cmd@itfinden.com
        ##Matar proceso##
else
        echo ""

for a in /home* ; do
        cd $a
                for i in * ; do
                        echo "Backup to $i ";
                        /scripts/pkgacct $i /home/cloud_backup > /dev/null 2>&1
                done
done
#sleep 5
umount /home/cloud_backup

