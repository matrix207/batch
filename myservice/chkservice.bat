@echo off

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: run as a singleton
set "app_title=ChkService"
tasklist /v | find "%app_title%">nul && goto _SKIP
title %app_title%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Query service status
set service_name="dennisService"

:_CHK_SERVICE
echo sleep 3 secs
ping -n 3 127.1 > nul
for /f "skip=3 tokens=4" %%i in ('sc query %service_name%') do (
	goto _%%i
)
echo not found %service_name%
goto :_CHK_SERVICE

:_RUNNING
echo %service_name% is running
goto :_CHK_SERVICE

:_STOPPED
echo %service_name% is stopped
set "pro_title=dtest"
for /f "tokens=2,10" %%a in ('tasklist /v') do (
	if /i %%b. EQU %pro_title%. taskkill /pid %%a
)
goto :_CHK_SERVICE

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Exit
:_EXIT
pause
exit /b 0

:_SKIP
echo Batch file is already running!
goto _EXIT

