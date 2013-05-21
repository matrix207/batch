@echo off

cd /d %~dp0

set log=apprun.log

echo %date% %time% apprun start >> %log%

FOR /f "tokens=1* delims=" %%a IN (apprun.cfg) DO (
	echo start "" "%~dp0%%a" >> %log%
	start "" "%~dp0%%a"
)

exit /b 0
