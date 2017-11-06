@echo off
Rem powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 %*"
powershell -ExecutionPolicy Unrestricted -Command ".\mspkg.ps1 install curl -platform msvc2010-x86"