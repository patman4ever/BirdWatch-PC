@echo off
title BirdWatch-PC
color 0B

echo.
echo  ==========================================
echo       ^>^>  BirdWatch-PC Launcher  ^<^<
echo  ==========================================
echo.
echo  Kies een optie:
echo.
echo  1. BirdWatch installeren
echo  2. BirdWatch starten
echo  3. BirdWatch stoppen
echo  4. BirdWatch updaten
echo  5. Logs bekijken
echo  6. Status tonen
echo  Q. Afsluiten
echo.
set /p keuze="Jouw keuze: "

if /i "%keuze%"=="1" goto installeer
if /i "%keuze%"=="2" goto start
if /i "%keuze%"=="3" goto stop
if /i "%keuze%"=="4" goto update
if /i "%keuze%"=="5" goto logs
if /i "%keuze%"=="6" goto status
if /i "%keuze%"=="Q" goto einde
goto einde

:installeer
powershell -ExecutionPolicy Bypass -File "%~dp0birdwatch.ps1" -Install
pause
goto menu_terug

:start
powershell -ExecutionPolicy Bypass -File "%~dp0birdwatch.ps1" -Start
echo.
echo  Dashboard beschikbaar op: http://localhost:7766
echo.
pause
goto menu_terug

:stop
powershell -ExecutionPolicy Bypass -File "%~dp0birdwatch.ps1" -Stop
pause
goto menu_terug

:update
powershell -ExecutionPolicy Bypass -File "%~dp0birdwatch.ps1" -Update
pause
goto menu_terug

:logs
powershell -ExecutionPolicy Bypass -File "%~dp0birdwatch.ps1" -Logs
pause
goto menu_terug

:status
powershell -ExecutionPolicy Bypass -File "%~dp0birdwatch.ps1" -Status
pause
goto menu_terug

:menu_terug
cls
goto :eof

:einde
exit
