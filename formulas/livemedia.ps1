param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $installpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

$DST_PATH="$installpath\$version-$platform-$arch"
Create-Directory $DST_PATH

$FILENAME="live555-latest.tar.gz"
$REMOTEURL="http://www.live555.com/liveMedia/public/live555-latest.tar.gz"

# Downloading the sources
Download-File $REMOTEURL "$DST_PATH\$FILENAME"


pushd
cd $DST_PATH

# Extract archive

# Remove-Item "live" -recurse
# Remove-Item "release" -recurse

if(!(Test-Path -Path "live" )){
	cmd /c "7z x ""$DST_PATH\$FILENAME"" -so | 7z x -aoa -si -ttar -o""."""

	$VCINSTALLDIR="$env:VCINSTALLDIR"

	# Go in src dir

	# Patch the files
	Patch-Line "live/win32config" '(TOOLS32	=).*$' "TOOLS32	= ${VCINSTALLDIR}..\VC"
	Patch-Line "live/win32config" '(.*)msvcirt.lib$' '${1}msvcrt.lib'

	Add-Content "live/win32config" ""
	Add-Content "live/win32config" "PREFIX = $DST_PATH\release"
	Add-Content "live/win32config" 'LIBDIR = $(PREFIX)\lib'
}

# Build project
if(!(Test-Path -Path "release" )){
	cd live
	cmd /c "genWindowsMakefiles.cmd"
	cd liveMedia
	nmake /B -f liveMedia.mak install
	cd ..\groupsock
	nmake /B -f groupsock.mak install
	cd ..\UsageEnvironment
	nmake /B -f UsageEnvironment.mak install
	cd ..\BasicUsageEnvironment
	nmake /B -f BasicUsageEnvironment.mak install
	cd ..\testProgs
	nmake /B -f testProgs.mak install
	cd ..\mediaServer
	nmake /B -f mediaServer.mak install
}
popd