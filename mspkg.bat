@echo off

set ARG_COMMAND=%1
set ARG_PACKAGE=%2
set ARG_VERSION=latest
set ARG_PLATFORM=mingw32gcc530
set ARG_ARCH=x86

Rem Check the command
if not "%ARG_COMMAND%" == "install" (
	echo Usage:
	echo       %0 install package [-version VERSION -arch ARCH -platform PLATFORM]
	exit
)

shift

Rem Check command install
if "%ARG_COMMAND%" == "install" (
	set ARG_PACKAGE=%1
	shift

	:loop
		if "-version" == "%1" (
			shift
			set ARG_VERSION=%1
		)
		if "-platform" == "%1" (
			shift
			set ARG_PLATFORM=%1
		)
		if "-arch" == "%1" (
			shift
			set ARG_ARCH=%1
		)
		shift
		if not "%~1"=="" goto loop

	powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install %ARG_PACKAGE% -version %ARG_VERSION% -platform %ARG_PLATFORM%  -arch %ARG_ARCH%"
)
