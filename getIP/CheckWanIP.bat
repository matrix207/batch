@echo off
setlocal enabledelayedexpansion

:Again

wget -N http://www.ip138.com/ip2city.asp

set ip1=180.109.150.82
set ip2=180.109.150.82

for /f "delims=[] tokens=1,2,3* " %%i in (ip2city.asp) do (
	set ip2=%%j
	if not '!ip2!'=='' set ip2=%%j
)

del /f /q ip2city.asp

if '!ip2!'=='!ip1!' (
	echo %ip1% Not Change, wait 100 seconds and check again
	ping -n 100 127.1 >nul 2>nul
	goto Again
) 

echo %date% %time%
echo O(°…_°…)OHa~ °Ô°Ô°Ô°Ô°Ô°Ô°Ô°ÔIP Change°Ô°Ô°Ô°Ô°Ô°Ô°Ô°Ô 
echo IP1: '!ip1!'
echo IP2: '!ip2!'

:Exit
pause
