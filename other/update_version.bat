@echo off&setlocal enabledelayedexpansion

REM 功能: 自动更新软件版本文件version.h的编译时间
REM       Linux下的做法如下 update-version.sh
REM 	  sh -x -c "sed -i -e '/__SOFTWARE_AUTO_VERSION__/ {
REM	  	s/=.*$/= \"svn-r$(svnversion), build-$(date '+%Y-%m-%d %H:%M')\"\;/
REM 	  }' version.h"
REM 	  sh -x -c "sed -i -e '/__SOFTWARE_AUTO_DATE__/ {
REM  		s/=.*$/= \"$(date '+%Y')\"\;/
REM 	  }' version.h"
REM 参考: http://stackoverflow.com/a/20227248
REM 问题: 
REM       1. 结果文件中会删除!符号
REM       2. for loop 中的 findstr 命令执行影响性能
REM 历史:
REM       2014-06-09 Dennis Create

set yy=%date:~0,4%
set mm=%date:~5,2%
set dd=%date:~8,2%
set hh=%time:~0,2%
set mn=%time:~3,2%
set ss=%time:~6,2%
set date_time=%yy%/%mm%/%dd% %hh%:%mn%:%ss%

set file=version.h
REM rename %file% %file%.tmp
copy %file% %file%.tmp
REM echo "" > %file%.ttt
type nul > %file%.ttt
for /f "tokens=1,* delims=" %%a in ( '"findstr /n ^^ %file%.tmp"') do (
    set line=%%a
	for /f "delims=: tokens=1,*" %%A in ("!line!") do set "line=%%B"
	REM echo !line!
	if  "!line!" == "" (
		echo.>> %file%.ttt
	) else (
		REM SET modified=!line:%SEARCHTEXT%=%REPLACETEXT%!
		echo "!line!" | findstr /C:"define DATE_TIME" > nul
		if !errorlevel! == 1 (
			echo Found ***** !line!
			set flag=1
			echo #define DATE_TIME       %date_time%>> %file%.ttt
		) else (
			echo !line!>> %file%.ttt
		)
	)
) 
del %file%.tmp
exit /b 0
