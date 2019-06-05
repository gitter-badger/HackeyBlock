@echo off

REM Get version number
set /p "numb2="<"%~dp0numb2.txt"
set /a numb2+=1
echo:%numb2%>"%~dp0numb2.txt"
set /p "numb1="<"%~dp0numb1.txt"
set /a vernumb=%numb1%.%numb2%
set newver=%vernumb%
echo:%vernumb%>"%~dp0..\latest-release.txt"

REM Organize Ad-list
type "%userprofile%\Github\Hackey-AdBlock\hackey-adlist.txt">"%~dp0addomainlist.txt"
type addomainlist.txt | findstr /v # | findstr /v \/ | findstr /v = > addomainlist.txt.new
move /y addomainlist.txt.new addomainlist.txt >nul
xcopy "%~dp0\Assets\jsort.bat" "%~dp0"
call jsort.bat addomainlist.txt /u >addomainlist.txt.new
del /f /q "%~dp0jsort.bat"
move /y addomainlist.txt.new hackey-adlist.txt >nul
move hackey-adlist.txt "%userprofile%\Github\Hackey-AdBlock\" >nul
del /f /q "%~dp0addomainlist.txt"

REM Organize Privacy-list
type "%userprofile%\Github\Hackey-AdBlock\hackey-privacy.txt">"%~dp0trackerlist.txt"
type trackerlist.txt | findstr /v # | findstr /v \/ | findstr /v = > trackerlist.txt.new
move /y trackerlist.txt.new trackerlist.txt >nul
xcopy "%~dp0\Assets\jsort.bat" "%~dp0"
call jsort.bat trackerlist.txt /u >trackerlist.txt.new
del /f /q "%~dp0jsort.bat"
move /y trackerlist.txt.new hackey-privacy.txt >nul
move hackey-privacy.txt "%userprofile%\Github\Hackey-AdBlock\" >nul
del /f /q "%~dp0trackerlist.txt"

REM Display the lists
cls
echo Ads:
echo:
type "%userprofile%\Github\Hackey-AdBlock\hackey-adlist.txt"
echo:
echo Trackers:
echo:
type "%userprofile%\Github\Hackey-AdBlock\hackey-privacy.txt"
echo everything okay?
pause

REM Display the changelog
type "%~dp0..\CHANGELOG.MD" > "%userprofile%\Github\Hackey-AdBlock\CODE\change.log"
type "%userprofile%\Github\Hackey-AdBlock\CODE\change.log"
echo everything okay?
pause


REM Start file editings.
call "%~dp0Assets\7-Zip\7z.exe" a -r -sfx7z.sfx -mx1 "%~dp0SETUP\hackeyfilesextractor.exe" *
"%~dp0bin\Bat_To_Exe_Converter\Bat_To_Exe_Converter_(x64).exe" /bat "%~dp0\SETUP\installationextraction.cmd" /exe "%~dp0..\Setups\Hackeyblocksetup-%vernumb%.exe" /icon "%~dp0logos\hackeylogo.ico" /overwrite /include "%~dp0SETUP\hackeyfilesextractor.exe" /workdir 1 /extractdir 1 /uac-admin /company "marnix0810.wordpress.com" /trademarks "By Marnix 0810" /copyright "By Marnix 0810" /productname "Hackey-AdBlock" /productversion "%verd%" /display /description "Hackey AdBlock's installer by Marnix 0810" /comments "Official Hackey AdBlock installer by Marnix0810" /privatebuild "%newver%" /specialbuild "%newver%" 
ren "%~dp0SETUP\hackeyfilesextractor.exe" updatesfx.exe
move /y "%~dp0SETUP\updatesfx.exe" "%userprofile%\GitHub\Hackey-AdBlock\"
