@echo off

del path.env

set ARCH=x64
set PLATFORM=msvc2017

Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 %*"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install 7zip -version "latest" -arch %ARCH% -platform %PLATFORM%"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install git -version "latest" -arch %ARCH% -platform %PLATFORM%"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install curl -version "git" -arch %ARCH% -platform %PLATFORM%"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install livemedia -version "latest" -arch %ARCH% -platform %PLATFORM%"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install ffmpeg -version "last" -arch %ARCH% -platform %PLATFORM%"
Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install qt4 -version "last" -arch %ARCH% -platform %PLATFORM%"
Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install qt5 -version "last" -arch %ARCH% -platform %PLATFORM%"