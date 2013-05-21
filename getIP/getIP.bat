:: Function: ��ѯ��ǰ��������������IP
:: Author:   Dennis
:: Date:     2011-12-20

@echo off
setlocal enabledelayedexpansion

set localIPFile=localIP.txt
:: ִ��ipconfig����, ���ѳ���IP Address�ַ�������д���ļ�
ipconfig | findstr /C:"IP Address" > %localIPFile%

:: ʹ��for����ѯlocalIP
set localIP=
for /f "delims=: tokens=1,* " %%i in (%localIPFile%) do (
	set localIP=%%j
	if not '!localIP!' == '' goto GetLocalIP
)

:GetLocalIP
::echo local IP : !localIP!
del /f /q %localIPFile%


:: ʹ��wget���ؿ��Ի�ȡ����IP����ҳҳ��
set wanIPFile=wanIP.html
wget -qN http://www.ip138.com/ip2city.asp -O %wanIPFile%

:: ʹ��for����ѯwanIP
set wanIP=
for /f "delims=[] tokens=1,2,3* " %%i in (%wanIPFile%) do (
	set wanIP=%%j
)

::echo wan IP : !wanIP!
del /f /q %wanIPFile%

:: ����IP��Ϣ���ļ�
set outputFile=ip.log
echo local IP : !localIP! > !outputFile!
echo wan   IP : !wanIP!  >> !outputFile!

REM :Exit
REM pause
