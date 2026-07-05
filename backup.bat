@echo off
echo ============================
echo Make4Me Git Backup
echo ============================

git status

set /p msg="Zadej popis zmeny: "

git add .
git commit -m "%msg%"
git push

echo ============================
echo Hotovo - zaloha odeslana na GitHub
echo ============================

pause