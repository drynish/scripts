#!/bin/sh

Maison=96.22.48.89

apt-get -y install transmission-daemon lftp
systemctl stop transmission-daemon

sed -i.bak "s/127.0.0.1/127.0.0.1,$Maison/" /etc/transmission-daemon/settings.json 
sed -i.bak "s/script-torrent-done-enabled\": false/script-torrent-done-enabled\": true/" /etc/transmission-daemon/settings.json 
sed -i.bak "s/done-filename\": \"\"/done-filename\": \"\/usr\/bin\/rsync_home\"/" /etc/transmission-daemon/settings.json 

echo "* - nofile 1536" >> /etc/security/limits.conf

echo '#!/bin/sh' > /usr/bin/rsync_home
echo "SRC_DIR=\"\${TR_TORRENT_DIR}/\${TR_TORRENT_NAME}\"" >> /usr/bin/rsync_home
echo "if [ -f \"\${SRC_DIR}\" ]; then" >> /usr/bin/rsync_home
echo "  lftp -e \"put /upload/\${SRC_DIR}; exit\" $Maison ">> /usr/bin/rsync_home
echo "  rm \${SRC_DIR} " >> /usr/bin/rsync_home
echo "else" >> /usr/bin/rsync_home
echo "  lftp -e \"mirror -R \${SRC_DIR} /upload/\${TR_TORRENT_NAME} \" $Maison " >> /usr/bin/rsync_home
echo "  rm -rf \${SRC_DIR}" >> /usr/bin/rsync_home
echo "fi" >> /usr/bin/rsync_home

chmod +x /usr/bin/rsync_home
systemctl start transmission-daemon
