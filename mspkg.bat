@echo off

del path.env
Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 %*"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install 7zip -arch x86 -platform msvc2010"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install git -arch x86 -platform msvc2010"
Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install curl -arch x86 -platform msvc2010"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install livemedia -arch x86 -platform msvc2010"