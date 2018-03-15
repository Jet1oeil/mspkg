param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $pkginstallpath,
	  [string] $version
)

# Downloading the package dev
$FILENAME="qt-everywhere-opensource-src-5.9.2.zip"
$REMOTEURL="http://download.qt.io/official_releases/qt/5.9/5.9.2/single/$FILENAME"
Download-File $REMOTEURL "${pkginstallpath}\$FILENAME"


cmd /c "7z x ""${pkginstallpath}\$FILENAME"" "