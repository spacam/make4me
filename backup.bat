@echo off
chcp 65001 >nul
setlocal

echo ============================
echo Make4Me Backup v2.0
echo ============================

cd /d "%~dp0"

echo.
echo Kontrola Gitu...
git status

echo.
set /p msg="Zadej popis zmeny: "

if "%msg%"=="" (
  echo CHYBA: Musis zadat popis zmeny.
  pause
  exit /b 1
)

echo.
echo Pridavam zmeny...
git add .
if errorlevel 1 goto error

echo.
echo Vytvarim commit...
git commit -m "%msg%"
if errorlevel 1 goto commiterror

echo.
echo Odesilam na GitHub...
git push
if errorlevel 1 goto pusherror

echo.
echo Vytvarim ZIP zalohu...

set BACKUP_DIR=G:\Můj disk\Make4Me\Backups
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

for /f "tokens=1-4 delims=. " %%a in ("%date%") do (
  set DD=%%a
  set MM=%%b
  set YYYY=%%c
)

set HH=%time:~0,2%
set MIN=%time:~3,2%
set HH=%HH: =0%

set ZIP_NAME=Make4Me_%YYYY%-%MM%-%DD%_%HH%-%MIN%.zip

powershell -NoProfile -Command "Compress-Archive -Path '%~dp0*' -DestinationPath '%BACKUP_DIR%\%ZIP_NAME%' -Force"

if errorlevel 1 goto ziperror

echo.
echo ============================
echo HOTOVO
echo GitHub: ulozeno
echo ZIP: %BACKUP_DIR%\%ZIP_NAME%
echo ============================
pause
exit /b 0

:commiterror
echo.
echo Commit nebyl vytvoren. Mozna nejsou zadne nove zmeny.
echo Zkusim alespon git push...
git push
if errorlevel 1 goto pusherror
pause
exit /b 0

:pusherror
echo.
echo CHYBA: git push se nepovedl.
echo Zkus:
echo git pull --rebase origin main
echo git push
pause
exit /b 1

:ziperror
echo.
echo CHYBA: ZIP zaloha se nepovedla.
pause
exit /b 1

:error
echo.
echo CHYBA: zaloha se nepovedla.
pause
exit /b 1