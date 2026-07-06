@echo off
echo ============================
echo Make4Me Git Backup
echo ============================

git status

set /p msg="Zadej popis zmeny: "

git add .
if errorlevel 1 goto error

git commit -m "%msg%"
if errorlevel 1 goto error

git push
if errorlevel 1 goto pusherror

echo ============================
echo HOTOVO - zaloha uspesne odeslana na GitHub
echo ============================
pause
exit /b 0

:pusherror
echo ============================
echo CHYBA - git push se nepovedl
echo Zkus spustit:
echo git pull --rebase origin main
echo git push
echo ============================
pause
exit /b 1

:error
echo ============================
echo CHYBA - zaloha se nepovedla
echo ============================
pause
exit /b 1