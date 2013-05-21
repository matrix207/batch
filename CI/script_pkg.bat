@ECHO off&setlocal enabledelayedexpansion

REM Useage: script_pkg.bat iss_script_file output_directory output_file_name log_file

SET script_path="%1"
SET output_dir=%2
SET output_file=%3
SET log_file=%4

SET log_file_tmp=NUL
IF NOT "%log_file%"=="" SET log_file_tmp=%log_file%

iscc /O"%output_dir%" /F"%output_file%" %script_path%
SET /a retval=%ERRORLEVEL%

IF %retval% EQU 0 @ECHO execute script success
IF %retval% EQU 1 @ECHO invalid parameters or internal error occurred
IF %retval% EQU 2 @ECHO compile failed

EXIT /B %retval%
