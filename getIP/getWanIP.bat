:: Function: 查询当前计算所属内外网IP
:: Author:   Dennis
:: Date:     2011-12-24
:: 说明: 使用ip138网站获取的IP可能不准,使用whereismyip的比较准.

@echo off
setlocal enabledelayedexpansion

set ipFile=whereismyip.html
set ipLine=ip.txt

:: 使用wget下载可以获取外网IP的网页页面
wget -qN http://whereismyip.com/ -O %ipFile%

::grep -w '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' whereismyip.txt > ip.txt
findstr "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" %ipFile% > %ipLine%

:: 样本
::	<b><font color="#000000" size="10" face="verdana">65.49.68.164</font></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
:: 使用<>符合划分字符串,IP地址在第四个字串中
set wanIP=
for /f "delims=<> tokens=4 " %%i in (%ipLine%) do (
	set wanIP=%%i
)

del /f /q %ipFile%
del /f /q %ipLine%

:: 保存IP信息到文件
set outputFile=wanip.log
echo wan   IP : !wanIP!  > !outputFile!
