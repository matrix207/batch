@ECHO off&setlocal enabledelayedexpansion 
:: Function: Uninstall service
:: Author:   Dennis
:: Date:     2012-10-18

REM +++++++++++++++++++++++++++++++++
REM Get project name from config file
REM +++++++++++++++++++++++++++++++++
SET service_name=

FOR /f "tokens=1* delims=:" %%a IN (service.cfg) DO (
	IF "%%a"=="service_name" SET service_name=%%b
)

IF "%service_name%"=="" (
	ECHO "Config service name first."
	GOTO End
)

sc stop %service_name%
instsrv.exe %service_name% remove

:End
EXIT 0
