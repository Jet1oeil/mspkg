# mspkg

Utility to build/install package on Windows

## Supported compilation

```
ARCH=[x86,x64]
PLATFORM=[msvc2010,msvc2017,mingw32gcc530]
```

## Set environment

### Mingw32

Create/Edit a env/PLATFORM-ARCH.env file to contains extra path:

```
C:\Qt\Tools\mingw530_32\bin;C:\Qt\Tools\mingw530_32\i686-w64-mingw32\bin
```

### MSVC

Install Visual Studio for C++ development

## Build

Run following command to compile

```
msbuild.bat install curl -version "latest" -platform PLATFORM -arch ARCH
```