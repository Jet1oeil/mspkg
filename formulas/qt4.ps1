param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $pkginstallpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

# Downloading the package dev
$VERSION="qt-everywhere-opensource-src-4.8.7"
$FILENAME="$VERSION.zip"
$REMOTEURL="http://download.qt.io/official_releases/qt/4.8/4.8.7/$FILENAME"
Download-File $REMOTEURL "${pkginstallpath}\$FILENAME"

# Extract archive
if(!(Test-Path -Path "$VERSION" )){
	cmd /c "7z x ""${pkginstallpath}\$FILENAME"" "
}

# Build
if(!(Test-Path -Path "$VERSION-build" )){
	# Create-Directory "${pkginstallpath}\$VERSION-build"
	pushd "${pkginstallpath}\$VERSION-build"
	# cmd /c "..\$VERSION\configure.exe -platform win32-msvc2010 -opensource -debug-and-release -shared -no-qt3support -nomake demos -nomake examples -plugin-sql-sqlite"
	cmd /c "nmake"
	popd
}