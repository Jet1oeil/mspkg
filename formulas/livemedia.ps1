param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $pkginstallpath,
	  [string] $version
)

$FILENAME="live555-latest.tar.gz"
$REMOTEURL="http://www.live555.com/liveMedia/public/$FILENAME"

# Downloading the sources
Download-File $REMOTEURL "${pkginstallpath}\$FILENAME"

pushd ${pkginstallpath}

# Remove-Item "live" -recurse
# Remove-Item "release" -recurse

# Extract archive
if(!(Test-Path -Path "live" )){
	# Extract the file
	cmd /c "7z x ""${pkginstallpath}\$FILENAME"" -so | 7z x -aoa -si -ttar -o""."""

	Add-Content "live/win32config" ""
	Add-Content "live/win32config" ""
	
    if("$env:MSPKG_VE_PLATFORM" -like "msvc*"){
		# Patch the file
		Patch-Line "live/win32config" '(TOOLS32	=).*$' "TOOLS32	= ${env:VCINSTALLDIR}..\VC"
		Patch-Line "live/win32config" '(.*)msvcirt.lib$' '${1}msvcrt.lib'
		Patch-Line "live/win32config" '!include    <ntwin32.mak>$' '#!include    <ntwin32.mak>'
		Patch-Line "live/win32config" 'C_COMPILER =		.*$' 'C_COMPILER =		"cl"'
		Patch-Line "live/win32config" 'LINK =			.*$' 'LINK =			link.exe -out:'
		Patch-Line "live/win32config" 'COMPILE_OPTS =		.*$' 'COMPILE_OPTS =		$(INCLUDES) $(cdebug) $(cflags) $(cvarsdll) /MDd -I. -I"$(TOOLS32)\include"'
		
	}else{
	    cd live
		Remove-Item win32config -Force
		Copy-Item config.mingw win32config
		cd ..
		
		Add-Content "live/win32config" "C_COMPILER = gcc.exe"
	}

	
	$pkginstallunixpath = ($pkginstallpath -replace "\\","/")
	Add-Content "live/win32config" "PREFIX = ${pkginstallunixpath}/release"
	Add-Content "live/win32config" 'LIBDIR = $(PREFIX)/lib'
}

# Build project
if(!(Test-Path -Path "release" )){
	cd live
    if("$env:MSPKG_VE_PLATFORM" -like "mingw32*"){
		cmd /c "genWindowsMakefiles.cmd"
		cd liveMedia
		mingw32-make -f liveMedia.mak install
		cd ..\groupsock
		mingw32-make -f groupsock.mak install
		cd ..\UsageEnvironment
		mingw32-make -f UsageEnvironment.mak install
		cd ..\BasicUsageEnvironment
		mingw32-make -f BasicUsageEnvironment.mak install
	}else{
		cmd /c "genWindowsMakefiles.cmd"
		cd liveMedia
		nmake /B -f liveMedia.mak install
		cd ..\groupsock
		nmake /B -f groupsock.mak install
		cd ..\UsageEnvironment
		nmake /B -f UsageEnvironment.mak install
		cd ..\BasicUsageEnvironment
		nmake /B -f BasicUsageEnvironment.mak install
		# cd ..\testProgs
		# nmake /B -f testProgs.mak install
		# cd ..\mediaServer
		# nmake /B -f mediaServer.mak install
	}
}

popd