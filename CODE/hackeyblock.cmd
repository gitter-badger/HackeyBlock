@powershell -window hidden -command ""
@ECHO OFF
color F0
CD /D "%~dp0"
if not "%Adminrequested%"=="1" (
call "%~dp0HARR.cmd" "%~s0"
)

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
call "%~dp0loadset.cmd"
SET Connected=false
FOR /F "usebackq tokens=1" %%A IN (`PING google.com`) DO (
    IF /I "%%A"=="Reply" SET Connected=true
)
If "%connected%"=="false" (
call :waitforconnection
)
powershell -window minimized -command ""
ECHO This app was made by Marnix 0810
REM questions about this code?
REM mail to:
REM programmer.marxin0810@gmail.com or
REM marnix0810@vivaldi.net


REM Clean the mess up that was made previously
del /f /q "%tmp%\Hackeyredirectfromads.cmd"
del /f /q "%~dp0updatesystem.cmd"
del /f /q "%~dp0mdmhostlist.txt"
del /f /q "%~dp0extractHackeyforinstaller.bat"
taskkill /f /im powershell.exe
taskkill /f /im python.exe
echo copying the unblocked patrons...
copy C:\Windows\System32\drivers\etc\hosts_before-Hackey.bkup  C:\hosts.edit.tmp /y
cls



REM check 4 updates
if "%Hackey-update-day%"=="" call :select_update_DOW
if "%Hackey-last-update%"=="%date%" goto updateisdone
echo Checking for permission to check for update...
call :getdow
if "%Hackey-update-day%"=="%dayofweek%" goto autoupdate
if "%Hackey-update-day%"=="all" goto autoupdate
:updateisdone



REM Run-after-update scripts if neccessary.
cd /d "%~dp0"
if exist afterupdate.cmd.Hackeyscript.cmd (
ren afterupdate.cmd.Hackeyscript postupdate.cmd
)
call postupdate.cmd
if exist postupdate.cmd (
del postupdate.cmd
)
powershell -window hidden -command ""

:Extractassets
Set _os_bitness=64
IF %PROCESSOR_ARCHITECTURE% == x86 (
  IF NOT DEFINED PROCESSOR_ARCHITEW6432 Set _os_bitness=32
  )
if "%_os_bitness%"=="32" start "" "%~dp0assets-sfx.7z.exe" -o"%~dp0" -y -gm2 -bso0 -bsp0
if "%_os_bitness%"=="64" start "" "%~dp0assets64-sfx.7z.exe" -o"%~dp0" -y -gm2 -bso0 -bsp0



REM activate the ad-replace server.
del /f /q "%~dp0servstatus.log"
(
echo @echo off
echo echo server started. ^> "%~dp0servstatus.log"
echo :retry
echo cd /D "%~dp0"
echo python -m http.server 3803 --directory "%~dp0Hackeyredirectfromads"
echo goto retry
) > "%tmp%\Hackeyredirectfromads.cmd"
:startserv
copy "%~dp0icon.ico" "%~dp0Hackeyredirectfromads\favicon.ico"
start /min powershell -window hidden -command "cmd /c %tmp%\Hackeyredirectfromads.cmd"
:waitserv
cls
echo setting up catchpages . . .
echo wait a minute. if this takes too long, restart Hackey.
timeout /t 1 /nobreak >nul
if not exist "%~dp0servstatus.log" goto :waitserv




REM make sure ads are being catched.
if not exist C:\Windows\System32\drivers\etc\hosts_before-Hackey.bkup (
echo creating backups of the host file in C:\Windows\System32\drivers\etc\hosts_before-Hackey.bkup and C:\hosts_before-Hackey.bkup ...
type C:\Windows\System32\drivers\etc\hosts > C:\Windows\System32\drivers\etc\hosts_before-Hackey.bkup
type C:\Windows\System32\drivers\etc\hosts_before-Hackey.bkup > C:\hosts_before-Hackey.bkup
)


REM update redirections.
TYPE "C:\Windows\System32\drivers\etc\hosts" > "%temp%\hosts.edit.tmp"
set "blockedsitescounter="
if "%Hackey-adultblock-on-or-off%"=="on" call :Hackeyadultblock
if not "%Hackey-privacy-on-or-off%"=="off" call :Hackeyprivacy
if not "%HackeyBlocking-on-or-off%"=="off" call :Hackeyadblock
call :HackeyProtect
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.malwaredomainlist.com/hostslist/hosts.txt', 'mdmhostlist.txt') }"
type mdmhostlist.txt >> "%temp%\hosts.edit.tmp"
del /f /q "%~dp0mdmhostlist.txt"
CD /D "%userprofile%"
for /F "eol=; tokens=*" %%A in (personalHackeylist.txt) do (
ECHO # Hackey Personal Blocking Rule >> "%temp%\hosts.edit.tmp"
ECHO 127.0.0.1 %%A >> "%temp%\hosts.edit.tmp"
cls
echo added %%A to blocklist.
set /a blockedsitescounter+=1
)

cd /d "%~dp0"
TYPE "%temp%\hosts.edit.tmp" > "C:\Windows\System32\drivers\etc\hosts"


REM indicate the tasks are done.
powershell -window hidden -command ""
notifu /t info /p "HackeyBlock" /m "Hackey Background Service Is Activated.\n\nClick here to run an AutoTest to see if it works" /i "%~dp0icon.ico"
if "%errorlevel%"=="3" start "" "http://localhost:3803/AutoTest/#if-this-doesn't-load-Hackey-is-not-working"
EXIT


EXIT
EXIT
EXIT
:autoupdate
md "%tmp%\Hackey"
TYPE "%~dp0updatesystem.cmd.Hackeyscript.cmd" >  "%tmp%\Hackey\updatesystem.cmd"
CALL "%tmp%\Hackey\updatesystem.cmd"
exit

:select_update_DOW
:set_update_freq
call "%~dp0saveset.cmd" Hackey-update-day ""
set "Hackey-update-day="
powershell -window hidden -command ""
for /F "delims=" %%a in ('mshta.exe "%~dp0HTA\SET-UPDATE-DAY.HTA"') do set "Hackey-update-day=%%a"
call "%~dp0saveset.cmd" Hackey-update-day %Hackey-update-day%
exit /b

:getdow
@echo off
setlocal
for /f "delims=" %%a in ('wmic path win32_localtime get dayofweek /format:list ') do for /f "delims=" %%d in ("%%a") do set %%d
echo day of the week: %dayofweek%
endlocal
exit /b

:Hackeyadblock
del /f /q Hackey-adlist.txt
powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Marnix0810/HackeyBlock-Blocking-lists/master/hackey-adlist.txt', 'Hackey-adlist.txt') }"
for /F "eol=; tokens=*" %%A in (Hackey-adlist.txt) do (
ECHO # HackeyBlock Rule >> "%temp%\hosts.edit.tmp"
ECHO 127.0.0.1 %%A >> "%temp%\hosts.edit.tmp"
cls
echo added %%A to blocklist.
set /a blockedsitescounter+=1
)
exit /b

:Hackeyadultblock
del /f /q Hackey-adultlist.txt
powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Marnix0810/HackeyBlock-Blocking-lists/master/Adult-content-host-list.txt', 'Hackey-adultlist.txt') }"
for /F "eol=; tokens=*" %%A in (Hackey-adultlist.txt) do (
ECHO # Hackey adultblock rule >> "%temp%\hosts.edit.tmp"
ECHO 127.0.0.1 %%A >> "%temp%\hosts.edit.tmp"
cls
echo added %%A to blocklist.
set /a blockedsitescounter+=1
)
exit /b

:HackeyProtect
del /f /q Hackey-protection.txt
powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Marnix0810/HackeyBlock-Blocking-lists/master/hackeys_own_malware-protection.txt', 'Hackey-protection.txt') }"
for /F "eol=; tokens=*" %%A in (Hackey-protection.txt) do (
ECHO # HackeyProtect Blocking Rule >> "%temp%\hosts.edit.tmp"
ECHO 127.0.0.1 %%A >> "%temp%\hosts.edit.tmp"
cls
echo added %%A to blocklist.
set /a blockedsitescounter+=1
)
exit /b

:Hackeyprivacy
del /f /q Hackey-privacy.txt
powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Marnix0810/HackeyBlock-Blocking-lists/master/hackey-privacy.txt', 'Hackey-privacy.txt') }"
for /F "eol=; tokens=*" %%A in (Hackey-privacy.txt) do (
ECHO # HackeyPrivacy Blocking Rule >> "%temp%\hosts.edit.tmp"
ECHO 127.0.0.1 %%A >> "%temp%\hosts.edit.tmp"
cls
echo added %%A to blocklist.
set /a blockedsitescounter+=1
)
exit /b
:waitforconnection
powershell -window hidden -command ""
notifu /t info /p "HackeyBlock" /m "Hackey Background Service Is Not Activated.\n\nYou do not have an internet connection, Hackey will be started automatically when it is restored." /i "%~dp0icon.ico"
FOR /F "usebackq tokens=1" %%A IN (`PING google.com`) DO (
    REM Check the current line for the indication of a successful connection.
    IF /I "%%A"=="Reply" SET Connected=true
)
If "%connected%"=="true" exit /b
timeout /t 30 /nobreak
goto waitforconnection
