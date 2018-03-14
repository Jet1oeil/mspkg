# mspkg

Utility to build/install package on Windows

## Edit the configuration

### Set environment

Create/Edit a path.env file to contains extra path:

Example for mingw32

```
C:\Qt\Tools\mingw530_32\bin;C:\Qt\Tools\mingw530_32\i686-w64-mingw32\bin
```

### Define the target

Edit mspkg.bat to set the platform:

ARCH=[x86,x64]
PLATFORM=[msvc2010,msvc2017,mingw32gcc530]

### Set the build 

Edit mspkg.bat and comment what you don't want to install

## Build all deps

msbuild.bat