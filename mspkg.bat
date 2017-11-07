@echo off

del path.env

set ARCH=x86
set PLATFORM=msvc2010

Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 %*"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install 7zip -arch %ARCH% -platform %PLATFORM%"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install git -arch %ARCH% -platform %PLATFORM%"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install curl -arch %ARCH% -platform %PLATFORM%"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install livemedia -arch %ARCH% -platform %PLATFORM%"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install ffmpeg -arch %ARCH% -platform %PLATFORM%"