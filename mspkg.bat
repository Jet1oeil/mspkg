@echo off


Rem Count arguments number
set PROGRAM=%0
set ARGC=0
for %%x in (%*) do Set /A ARGC+=1
if %ARGC% LSS 1 (
    goto printUsage
)

SET MSPKG_ROOT_PATH=%~dp0
SET MSPKG_ENV_PATH=%MSPKG_ROOT_PATH%env
SET MSPKG_FORMULAS_PATH=%MSPKG_ROOT_PATH%formulas

set ARG_COMMAND=%1
shift


Rem Handle createenv command
if "%ARG_COMMAND%" == "createenv" (
	if %ARGC% LSS 3 (
		goto printUsage
	)

	set ARG_PLATFORM=%1
	set ARG_ARCH=%2

	if exist "mspkg.env" (
		echo %PROGRAM%: Environement have beean already set for this directory
		goto exit
	)
	
	echo MSPKG_VE_PLATFORM=%ARG_PLATFORM%>> mspkg.env
	echo MSPKG_VE_ARCH=%ARG_ARCH%>> mspkg.env
	
	goto exit
)

Rem Handle install command
if "%ARG_COMMAND%" == "install" (
	set ARG_PACKAGE=%1
	shift

	:loop
		set ARG_VERSION=latest
		if "-version" == "%1" (
			shift
			set ARG_VERSION=%1
		)
		shift
		if not "%~1"=="" goto loop

	powershell -ExecutionPolicy Unrestricted -Command "%MSPKG_ROOT_PATH%mspkg.ps1 install %ARG_PACKAGE% -version %ARG_VERSION%"
	goto exit
)

:printUsage
	echo Usage:
	echo       %PROGRAM% createenv PLATFORM ARCH
	echo       %PROGRAM% install package [-version VERSION]

:exit
	