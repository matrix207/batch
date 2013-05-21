:: download sunxin c++ video
:: Dennis
:: 2011-8-2

@echo off
setlocal ENABLEDELAYEDEXPANSION

set url_template=http://www.enet.com.cn//eschool//zhuanti//vc++//

::pause>nul
::exit

set url_begin=2
set url_step=1
set url_end=106
::set val_cur=0
set downloadfile=download.html
set tmpfile=tmp.html

for /L %%i in (4,1,106) do (
	set swffile=%%i.swf
	set val_cur=%%i
	set url_cur=%url_template%!val_cur!
	echo !url_cur!
	
	wget !url_cur! -O %downloadfile%

	:Wait_Download_Html
	ping -n 1 127.0.0.1>nul
	
	if NOT exist "%downloadfile%" (
		goto Wait_Download_Html
	)

	for /f "tokens=1,2* delims=h" %%i in ('findstr "href=.*swf" %downloadfile%') do echo %%k >%tmpfile%
	for /f "tokens=1,2* delims=f" %%i in (%tmpfile%) do (
		set swf_url=h%%if
		echo !swf_url!
	)
	
	wget !swf_url! -O !swffile!
	
	:Wait_Download_SWF
	ping -n 1 127.0.0.1>nul
	
	if NOT exist "%swffile%" (
		goto Wait_Download_SWF
	)
	
	echo "going to delete template file"
	
	del /f /q %downloadfile%
	del /f /q %tmpfile%
)

pause