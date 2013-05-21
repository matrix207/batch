@ECHO off&setlocal enabledelayedexpansion 
REM ++++++++++++++++++++++++++++++++++++++++++++
REM This is sample batch script for Auto Package
REM Dennis
REM 2012-11-27
REM ++++++++++++++++++++++++++++++++++++++++++++

REM Useage
REM		sample.bat sample.prj log_path

set log_file=NUL

IF "%1"=="" (
	@ECHO Useage
	@ECHO 		sample.bat sample.prj [log_path]
	GOTO :Exit
)

REM set prj_file=%CD%\%1
set prj_file=%1

set date_time=%date:~,10%_%time:~,2%_%time:~3,2%_%time:~6,2%

set log_path=NUL
IF NOT "%2"=="" (
	set log_path=%2
	set log_file=!log_path!\%date_time%.log
)

CALL :TIME_START

REM =================================================================
REM Step 1
set prj_name=
set prj_url=
set prj_ver=
set prj_sln=
set prj_script=

REM Search *.prj file
REM for /r %%i in (*.prj) do (
REM	CALL :GET_PRJ_INFO %%i
REM )

CALL :GET_PRJ_INFO %prj_file%

SET /a check_ok=1
CALL :CHECK_PRJ_INFO
IF !check_ok! EQU 0 GOTO :Exit

REM SVN Check out project
CALL :LABLE_SVN_LAST_REV !prj_url!
SET /a rev_input=!svn_last_rev!
SET /p rev_input=   请输入需要构建的SVN源码版本(默认使用最新版本!svn_last_rev!):
IF !rev_input! GTR !svn_last_rev! (
	echo Revision !rev_input! is not exist!
	CALL :LABLE_Sleep
	GOTO :Exit
)
if defined debug echo script_svn.bat !prj_url! !prj_name! !rev_input! !log_file!
CALL :DoCMD "CALL script_svn.bat !prj_url! !prj_name! !rev_input!" !log_file!
set /a retval=%ERRORLEVEL%
IF NOT %retval% EQU 0 GOTO :Exit

ECHO.
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO.

REM =================================================================
REM Step 2
REM format path
set prj_sln="%CD%\!prj_name!\!prj_sln!"

IF NOT Exist %prj_sln% (
	@ECHO Not found %prj_sln%
	GOTO :Exit
)

REM Compile
if defined debug echo script_compile.bat !prj_sln! !log_file!
CALL :DoCMD "CALL script_compile.bat !prj_sln!" !log_file!
set /a retval=%ERRORLEVEL%
IF NOT %retval% EQU 0 GOTO :Exit

ECHO.
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO.

REM =================================================================
REM Step 3
IF "!prj_script!"=="" goto :Exit
set prj_script="%CD%\!prj_name!\!prj_script!"
IF NOT Exist %prj_script% (
	@ECHO Not found %prj_script%
	GOTO :Exit
)

REM Package
if defined debug echo script_pkg.bat !prj_script! %output_dir% %output_name% !log_file!
SET output_dir=release
SET build_date=%date:~,4%%date:~5,2%%date:~8,2%
SET sw_ver=1.0
SET /p sw_ver=   请输入软件版本号(默认版本号1.0):
SET output_name=!prj_name!_%sw_ver%_!rev_input!_%build_date%
CALL :DoCMD "CALL script_pkg.bat !prj_script! %output_dir% %output_name%" !log_file!
set /a retval=%ERRORLEVEL%
IF NOT %retval% EQU 0 GOTO :Exit

ECHO.
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO.

REM =================================================================
REM Step 4
REM md5
if defined debug echo md5sums -u %output_dir%/%output_name%.exe
CALL :DoCMD "md5sums -u %output_dir%/%output_name%.exe" !log_file!
set /a retval=%ERRORLEVEL%
IF NOT %retval% EQU 0 GOTO :Exit

ECHO.
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO.

REM =================================================================
REM Exit
:Exit
CALL :TIME_END
@ECHO Finish
EXIT /B %retval%

REM =================================================================
REM Read file function

REM Get info from *.prj file
:GET_PRJ_INFO
FOR /F "tokens=1,2* delims==" %%a in (%1) do (
	IF "%%a"=="name" set prj_name=%%b
	IF "%%a"=="url" set prj_url=%%b
	IF "%%a"=="rev" set prj_ver=%%b
	if "%%a"=="solution" set prj_sln=%%b
	if "%%a"=="script" set prj_script=%%b
)
GOTO :EOF

:CHECK_PRJ_INFO
IF "!prj_name!"=="" (
	@ECHO project name if null
	SET /a check_ok=0
)
IF "!prj_url!"=="" (
	@ECHO project url if null
	SET /a check_ok=0
)
IF "!prj_ver!"=="" (
	@ECHO project rev if null
	SET /a check_ok=0
)
GOTO :EOF

:TIME_START
SET /a time_s=1%time:~6,2%-100
SET /a time_m=1%time:~3,2%-100
SET /a time_h=1%time:~0,2%-100
CALL :DoCMD "@ECHO Start   time: %time:~,11%" !log_file!
GOTO :EOF

:TIME_END
CALL :DoCMD "@ECHO End     time: %time:~,11%" !log_file!
SET /a diff_h=1%time:~0,2%-100-%time_h%
SET /a diff_m=1%time:~3,2%-100-%time_m%
SET /a diff_s=1%time:~6,2%-100-%time_s%
SET /a total="%diff_h%"*3600+"%diff_m%"*60+"%diff_s%"
CALL :DoCMD "@ECHO Elapsed time: %total% sec" !log_file!
GOTO :EOF

:LABLE_SVN_LAST_REV
SET svn_url=%1
for /f "skip=7 delims=: tokens=2" %%i in ('svn info %svn_url%') do (
	SET /a svn_last_rev=%%i
	GOTO :SVN_LAST_REV_EXIT
)
:SVN_LAST_REV_EXIT
GOTO :EOF

:LABLE_Sleep
ping -n 3 127.1 > nul
GOTO :EOF

REM call :DoCMD "command" NUL
REM call :DoCMD "command" logfile
:DoCMD
IF "%2"=="NUL" %~1
IF NOT "%2"=="NUL" %~1 >> %2
GOTO :EOF

