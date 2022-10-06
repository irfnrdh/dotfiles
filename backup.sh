#!/bin/sh


backupPaths="./backup.conf"
homeDirectory=~
sameLine="\e[1A\e[K"

echo "🛑 Membersihkan konfigurasi yang ada sebelumnya..."
rm -rf konfigurasi
mkdir konfigurasi
sleep 1
echo -e "$sameLine✅ Konfigurasi sudah bersih, broh!"
sleep 1

echo -e "$sameLine🏁 Kita mulai backup dulu ya..."
sleep 1

sed '/^[ \t]*$/d' $backupPaths | while read filePath; do
  echo -e "$sameLine⏳ Copying: $filePath"

  findThis="~/"
  replaceWith="$homeDirectory/"
  originalFile="${filePath//${findThis}/${replaceWith}}"

  cp --parents --recursive $originalFile ./konfigurasi
  sleep 0.05
done

git add .

echo -e "$sameLine🎉 Backup telah selesai! kamu dapat mereview dan lanjut commit perubahan sebelum di simpan."

# Caranya : 
# chmod +x ./backup.sh
# git add .
# git commit -m "Backup"
# ./backup.sh 
