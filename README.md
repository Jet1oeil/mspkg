# mspkg

Utility to build/install package on Windows

## Supported compilation

```
ARCH=[x86,x64]
PLATFORM=[msvc2010,msvc2017,mingw32gcc530]
```

## Set environment

Create an empty directory

```
cd [VIRTUAL_ENV_PATH]
[MSPKG_INSTALL_PATH]\mspkg.bat createenv PLATFORM ARCH
```

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
cd [VIRTUAL_ENV_PATH]
[MSPKG_INSTALL_PATH]\mspkg.bat install curl
[MSPKG_INSTALL_PATH]\mspkg.bat install livemedia -version "latest"
```