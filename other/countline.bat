@echo off

REM From: http://www.computing.net/answers/programming/for-loop-to-read-blank-lines-from-file/20635.html #23
set file=v.h
for /f "delims=" %%a in ('type %file% ^| find /c /v ""') do (
	set NoLines=%%a 
	echo *** !NoLines!
	type %file%
)
echo No Lines=%NoLines%
