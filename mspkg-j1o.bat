@echo off

del path.env

set ARCH=x86
set PLATFORM=mingw32gcc530

Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 %*"
mspkg.bat install 7zip latest -version "latest" -platform %PLATFORM% -arch %ARCH%
mspkg.bat install git latest -version "latest" -platform %PLATFORM% -arch %ARCH%
mspkg.bat install curl latest -version "latest" -platform %PLATFORM% -arch %ARCH%
Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install livemedia -version "latest" -arch %ARCH% -platform %PLATFORM%"
Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install ffmpeg -version "last" -arch %ARCH% -platform %PLATFORM%"
Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install qt4 -version "last" -arch %ARCH% -platform %PLATFORM%"
Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install qt5 -version "last" -arch %ARCH% -platform %PLATFORM%"