:: Function: ��ѯ��ǰ��������������IP
:: Author:   Dennis
:: Date:     2011-12-24
:: ˵��: ʹ��ip138��վ��ȡ��IP���ܲ�׼,ʹ��whereismyip�ıȽ�׼.

@echo off
setlocal enabledelayedexpansion

set ipFile=whereismyip.html
set ipLine=ip.txt

:: ʹ��wget���ؿ��Ի�ȡ����IP����ҳҳ��
wget -qN http://whereismyip.com/ -O %ipFile%

::grep -w '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' whereismyip.txt > ip.txt
findstr "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" %ipFile% > %ipLine%

:: ����
::	<b><font color="#000000" size="10" face="verdana">65.49.68.164</font></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
:: ʹ��<>���ϻ����ַ���,IP��ַ�ڵ��ĸ��ִ���
set wanIP=
for /f "delims=<> tokens=4 " %%i in (%ipLine%) do (
	set wanIP=%%i
)

del /f /q %ipFile%
del /f /q %ipLine%

:: ����IP��Ϣ���ļ�
set outputFile=wanip.log
echo wan   IP : !wanIP!  > !outputFile!
