@ECHO OFF
color F0
type nul> starthackeythenleave.cmd
del /f /q starthackeythenleave.cmd
call powershell -window maximize -command ""
:: BatchGotAdmin
:-------------------------------------
REM Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
ECHO This app was made by marnix0810
if not exist "%appdata%\Microsoft\Windows\Start Menu\Programs\Marnix 0810\Hackey-Adblock\Hackey AdBlock Menu.lnk" call :shortcuts
if not exist "%appdata%\Microsoft\Windows\Start Menu\Programs\Marnix 0810\Hackey-Adblock\Uninstall Hackey AdBlock.lnk" call :shortcuts
:startoptional
REM Run-after-update scripts if neccessary.
cd /d "%~dp0"
if exist afterupdate.cmd.hackeyscript (
ren afterupdate.cmd.hackeyscript postupdate.cmd
)
call postupdate.cmd
if exist postupdate.cmd (
del postupdate.cmd
)
if not exist "%userprofile%\personalhackeylist.txt" (
type NUL > "%userprofile%\personalhackeylist.txt"
)
cd /d "%~dp0"
:settings.home
powershell -window hidden -command ""
set "HTAreply="
for /F "delims=" %%a in ('mshta.exe "%~dp0files\HTAfiles\MENU-HOME.HTA"') do set "HTAreply=%%a"
powershell -window minimized -command ""
if "%HTAreply%"=="1" call :set_update_freq
if "%HTAreply%"=="2" call :set_startup_timeout
if "%HTAreply%"=="3" call :force_NOW_update
if "%HTAreply%"=="4" start cmd /c "%~dp0hackeyblock.cmd"
if "%HTAreply%"=="5" (
start cmd /c "%~dp0stop-hackey.cmd"
exit
)
if "%HTAreply%"=="6" start "" "http://hackeytester-if-this-doesnt-load-hackeys-not-active.hello:3803/AutoTest"
if "%HTAreply%"=="9" call :adddomaintopersonallist
if "%HTAreply%"=="7" call :uninstall
if "%HTAreply%"=="8" exit
if "%HTAreply%"=="change.log" (
type Change.log> changelog.txt
start mshta "%~dp0change.hta"
)
if "%HTAreply%"=="Privacy" goto turn-privacy-on-or-off
goto settings.home
:set_update_freq
setx hackey-update-day ""
set "hackey-update-day="
powershell -window hidden -command ""
for /F "delims=" %%a in ('mshta.exe "%~dp0files\HTAfiles\SET-UPDATE-DAY.HTA"') do set "hackey-update-day=%%a"
setx hackey-update-day %hackey-update-day%
exit /b

:set_startup_timeout
setx Hackeyonstartup-timeout ""
set "Hackeyonstartup-timeout="
powershell -window hidden -command ""
for /F "delims=" %%a in ('mshta.exe "%~dp0files\HTAfiles\setstartuptimeout.HTA"') do set "Hackeyonstartup-timeout=%%a"
setx Hackeyonstartup-timeout %Hackeyonstartup-timeout%
exit /b
:force_NOW_update
TYPE "%~dp0updatesystem.cmd.hackeyscript" >  "%~dp0updatesystem.cmd"
CALL updatesystem.cmd
exit /b
:adddomaintopersonallist
start wordpad "%~dp0files\HELPFILES\How does the Personal Blocking list work.rtf"
start /wait notepad "%userprofile%\personalhackeylist.txt"
timeout /t 2 /nobreak > NUL
start cmd /c "%~dp0hackeyblock.cmd"
exit /b
:turn-privacy-on-or-off
setx hackey-privacy-on-or-off ""
set "hackey-privacy-on-or-off="
powershell -window hidden -command ""
for /F "delims=" %%a in ('mshta.exe "%~dp0files\HTAfiles\hackey-privacy-on-or-off.HTA"') do set "hackey-privacy-on-or-off=%%a"
setx hackey-privacy-on-or-off %hackey-privacy-on-or-off%
exit /b
:uninstall
md "%tmp%\hackey"
xcopy uninstall.bat "%tmp%\hackey\" /y
call "%tmp%\hackey\uninstall.bat" "%~dp0"
exit /b
:shortcuts
if not exist mkdir "%appdata%\Microsoft\Windows\Start Menu\Programs\Marnix 0810\Hackey-Adblock" (
mkdir "%appdata%\Microsoft\Windows\Start Menu\Programs\Marnix 0810\Hackey-Adblock"
)
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\Marnix 0810\Hackey-AdBlock\Hackey AdBlock Menu.lnk');$s.TargetPath='%~dp0Hackey-AdBlock_menu.exe';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\Marnix 0810\Hackey-AdBlock\Uninstall Hackey AdBlock.lnk');$s.TargetPath='%~dp0uninstall.bat';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\Hackey-AdBlock@startup.lnk');$s.TargetPath='%~dp0hackeyrunner-startup.exe';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%HOMEDRIVE%\Users\Public\Desktop\Hackey-AdBlock.lnk');$s.TargetPath='%~dp0Hackey-AdBlock_menu.exe';$s.Save()"
