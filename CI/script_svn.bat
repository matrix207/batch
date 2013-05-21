@ECHO off&SETlocal enabledelayedexpansion 

REM Useage: script_svn.bat svn_src_url out_path revision log_file

SET func="check out project"

SET src_url=%1
SET out_path=%2
SET src_rev=%3
SET log_file=%4
SET parameters=%src_url%

IF NOT "%out_path%"=="" SET parameters=!parameters! %out_path%

IF NOT "%src_rev%"=="" SET parameters=!parameters! -r %src_rev%

SET log_file_tmp=NUL
IF NOT "%log_file%"=="" SET log_file_tmp=%log_file%

svn co !parameters!

SET /a ret_code=%ERRORLEVEL%
IF %ret_code% EQU 0 (
	@ECHO svn checkout success
) ELSE (
	@ECHO svn checkout fail
)

EXIT /B %ret_code%
