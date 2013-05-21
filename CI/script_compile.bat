@ECHO off&SETlocal enabledelayedexpansion 

REM Useage: script_compile.bat solution_file

SET sln_file=%1
SET cfg_build="Release|Win32"

devenv %sln_file% /build %cfg_build%

SET /A retval=%ERRORLEVEL%
EXIT /B %retval%
