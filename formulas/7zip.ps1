param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $pkginstallpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

$REMOTEDIR="http://www.7-zip.org/a/"
if($arch -eq "x86"){
	$FILENAME="7z1604.exe"
}else{
	$FILENAME="7z1604-x64.exe"
}

$REMOTEURL="$REMOTEDIR\$FILENAME"
$PKG_BIN_PATH="${pkginstallpath}\bin"

# Downloading the installer
Download-File $REMOTEURL "${pkginstallpath}\$FILENAME"

# Install the package
if(!(Test-Path -Path "${PKG_BIN_PATH}" )){
	pushd ${pkginstallpath}
	cmd /c "$FILENAME /S /D=${PKG_BIN_PATH}"
	popd
}else{
	Write-Host "  -- Already installed"
}

"${PKG_BIN_PATH};" >> "path.env"