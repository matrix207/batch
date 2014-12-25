###basic
* pause
* run more than one command on a line, using `&` symbol; e.g: `echo 1234 & echo abc`

###for

###how to debug
* echo
* pause

###print PID of the current batch file
From: <https://social.msdn.microsoft.com/Forums/vstudio/en-US/270f0842-963d-4ed9-b27d-27957628004c/what-is-the-pid-of-the-current-cmdexe>

	@echo off

	setlocal

	rem Instance Set
	set instance=%DATE% %TIME% %RANDOM%
	echo Instance: "%instance%"
	title %instance%

	rem PID Find
	for /f "usebackq tokens=2" %%a in (`tasklist /FO list /FI "WINDOWTITLE eq %instance%" ^| find /i "PID:"`) do set PID=%%a
	if not defined PID (
		echo !Error: Could not determine the Process ID of the current script.  Exiting.& exit /b 1
	) else (
		rem Current Task Show
		echo PID: "%PID%"
		tasklist /v /FO list /FI "PID eq %PID%"
	)
