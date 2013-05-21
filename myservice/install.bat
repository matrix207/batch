@ECHO off&setlocal enabledelayedexpansion 
:: Function: Install service
:: Author:   Dennis
:: Date:     2012-10-18

REM +++++++++++++++++++++++++++++++++
REM Get project name from config file
REM +++++++++++++++++++++++++++++++++
SET service_name=
SET service_app=

FOR /f "tokens=1* delims=:" %%a IN (service.cfg) DO (
	IF "%%a"=="service_name" SET service_name=%%b
	IF "%%a"=="service_app" SET service_app=%%b
)
IF "%service_name%"=="" (
	ECHO "Config service name first."
	GOTO Err_Conf
)

IF "%service_app%"=="" (
	ECHO "Config service application first."
	GOTO Err_Conf
)

REM +++++++++++++++++++++++++++++++++
REM Main process
REM +++++++++++++++++++++++++++++++++

REM install service

instsrv.exe %service_name% "%~dp0srvany.exe"

REM SET register
SET item_key="HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%service_name%\Parameters"
SET AppName="%service_app%"
SET AppDirectory="%~dp0"
REM SET Application=%AppDirectory%%AppName%
SET Application="%~dp0%service_app%"
SET AppParameters=""

reg add %item_key%
reg add %item_key% /v AppDirectory /t REG_SZ /d %AppDirectory% /f
reg add %item_key% /v Application /t REG_SZ /d %Application% /f
reg add %item_key% /v AppParameters /t REG_SZ /d %AppParameters% /f

REM start service
sc start %service_name%

REM +++++++++++++++++++++++++++++++++
REM Exit
REM +++++++++++++++++++++++++++++++++
:End
exit 0

REM +++++++++++++++++++++++++++++++++
REM Config Error handle
REM +++++++++++++++++++++++++++++++++
:Err_Conf
REM sleep 3 seconds
ping -n 3 127.0.0.1 > nul
GOTO End

