cd /d "%~dp0"
mkdir "%appdata%\Microsoft\Windows\Start Menu\Programs\The Marnix 0810 Site\"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\The Marnix 0810 Site\Mail Marnix 0810.url');$s.TargetPath='mailto:programmer.marxin0810@gmail.com';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\The Marnix 0810 Site\The Marnix 0810 Site.url');$s.TargetPath='https://marnix0810.wordpress.com/';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\HackeyBlock by Marnix 0810 - Go to HackeyBlock contact form.url');$s.TargetPath='https://marnix0810.wordpress.com/downloads/hackey/Hackeyblock-contact-form/';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\HackeyBlock by Marnix 0810 - Request changes in HackeyBlock-lists.url');$s.TargetPath='https://marnix0810.wordpress.com/downloads/hackey/Hackeyblock-contact-form/report-domain/';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\HackeyBlock service starter.lnk');$s.TargetPath='%~dp0Hackeyrunner-startup.cmd';$s.Save()"
powershell -window maximized -command ""
