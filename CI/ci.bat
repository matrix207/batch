@echo off&setlocal enabledelayedexpansion

::set debug=1

set log_dir=log

:Main
mode con lines=56 
mode con cols=120
cls
:: ����
color 1f
title windows ��Ŀ�Զ�����
echo                                           �q�����������������r
echo       �q������������������������������������  ��Ŀ�Զ�����  �����������������������������������r
echo       ��                                  �t�����������������s                                ��
set empty="      ��                                                                                      ��"
set epthd="      ��           "
echo %empty:"=%

:: for show string
call :strlen !empty! len_ept_max
call :strlen !epthd! len_ept_hd
set /a len_remain=!len_ept_max!-!len_ept_hd!-1

set prj_name=
set prj_url=
set prj_ver=
set prj_sln=
set prj_script=

set cfg_path=config
set cfg_file=%cfg_path%\*.prj

set /a prj_index=1
for /f "tokens=* delims=" %%i in ('dir /s /b /a-d %cfg_file%') do (
	call :GET_PRJ_INFO %%i
	call :show_bt_str "!prj_index! !prj_name!"
	call :show_bt_str "  !prj_url!"
	echo %empty:"=%
	set /a prj_index=!prj_index!+1
)

echo       ��                                                                                      ��
echo       �t���������������������������������������������������������������������������������������s

echo.
echo.
set /a choice=0
set /p choice=   ��������Ҫ��������Ŀ��� [ֱ�ӻس���������]��

if !choice! GTR 0 (
	if !choice! LEQ !prj_index! goto :StartJob
)

if !choice! EQU 0 goto :Finish

if defined choice goto :Main

:StartJob
set /a prj_index=1
for /f "tokens=* delims=" %%i in ('dir /s /b /a-d %cfg_file%') do (
	call :GET_PRJ_INFO %%i
	set log_path=%log_dir%\!prj_name!
	if not exist !log_path! md !log_path!
	if !prj_index! EQU !choice! (
		set show_log=y
		set /p show_log=   �Ƿ���ʾ��������[y��ʾ,nд���ļ�,Ĭ��y]: 
		if /i "!show_log!"=="y" (
			if defined debug echo CALL sample.bat %%i
			CALL sample.bat %%i
		) else (
			if defined debug echo CALL sample.bat %%i !log_path!
			if /i "!show_log!"=="n" CALL sample.bat %%i !log_path!
		)
		PAUSE
	)
	set /a prj_index=!prj_index!+1
)

if defined choice goto :Main

:Finish
color 07
exit /b 0

:: Get info from *.prj file
:GET_PRJ_INFO
FOR /F "tokens=1,2* delims==" %%a in (%1) do (
	IF "%%a"=="name" set prj_name=%%b
	IF "%%a"=="url" set prj_url=%%b
	IF "%%a"=="rev" set prj_ver=%%b
)
GOTO :EOF

:LABLE_SVN_LAST_VER
SET svn_url=%1
for /f "skip=7 delims=: tokens=2" %%i in ('svn info %svn_url') do (
	SET /a svn_lastest_ver=%%i
	GOTO :SVN_LAST_VER_EXIT
)
:SVN_LAST_VER_EXIT
GOTO :EOF

:strlen <stringVarName> [retvar] 
:: ��Դ: http://www.bathome.net/viewthread.php?tid=11799&highlight=%D7%D6%B7%FB%B4%AE%B3%A4%B6%C8
:: ˼·�����ֻ������ϲ��
:: ˵���������ַ�����С��Χ 0K ~ 8K��
::    stringVarName ---- ����ַ����ı�����
::    retvar      ---- �����ַ����ȵı�����
setlocal enabledelayedexpansion
set "$=^!%1^!#"
::echo !$!
set N=&for %%a in (4096 2048 1024 512 256 128 64 32 16)do if !$:~%%a!. NEQ . set/aN+=%%a&set $=!$:~%%a!
set $=!$!fedcba9876543210&set/aN+=0x!$:~16,1!
endlocal&If %2. neq . (set/a%2=%N%-2)else echo %N%-2
goto :EOF

:show_bt_str <string> [retvar]
:: ˼·��������Ҫ��ĩβ����ո�,��󲹳���ʾ�ַ� 
:: ˵���������ַ���Ҫ����˫����
::    string ---- ����ַ����ı�����
::    retvar ---- �������ִ��ı�����
setlocal enabledelayedexpansion
set content=%1
call :strlen !content! len_ct
set /a len_app=%len_remain%-!len_ct!+2
for /L %%a in (1,1,!len_app!) do set ct_add=!ct_add!" "
set ct_show=%epthd:"=%!content:"=!!ct_add:"=!��
cecho #Wb%epthd:"=%#Rb!content:"=!#Wb!ct_add:"=!��
::endlocal&If %2. neq . (set %2=%ct_show%)else echo %ct_show%
endlocal&If %2. neq . (set %2=%ct_show%)
goto :EOF
