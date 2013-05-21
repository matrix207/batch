:: Function: 查询当前计算所属内外网IP
:: Author:   Dennis
:: Date:     2011-12-20

@echo off
setlocal enabledelayedexpansion

set localIPFile=localIP.txt
:: 执行ipconfig命令, 并把出现IP Address字符串的行写到文件
ipconfig | findstr /C:"IP Address" > %localIPFile%

:: 使用for语句查询localIP
set localIP=
for /f "delims=: tokens=1,* " %%i in (%localIPFile%) do (
	set localIP=%%j
	if not '!localIP!' == '' goto GetLocalIP
)

:GetLocalIP
::echo local IP : !localIP!
del /f /q %localIPFile%


:: 使用wget下载可以获取外网IP的网页页面
set wanIPFile=wanIP.html
wget -qN http://www.ip138.com/ip2city.asp -O %wanIPFile%

:: 使用for语句查询wanIP
set wanIP=
for /f "delims=[] tokens=1,2,3* " %%i in (%wanIPFile%) do (
	set wanIP=%%j
)

::echo wan IP : !wanIP!
del /f /q %wanIPFile%

:: 保存IP信息到文件
set outputFile=ip.log
echo local IP : !localIP! > !outputFile!
echo wan   IP : !wanIP!  >> !outputFile!

REM :Exit
REM pause
