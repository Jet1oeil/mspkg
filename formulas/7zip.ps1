param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $installpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

$DST_PATH="$installpath\$version-$platform-$arch"
Create-Directory $DST_PATH

$REMOTEDIR="http://www.7-zip.org/a/"
if($arch -eq "x86"){
	$FILENAME="7z1604.exe"
}else{
	$FILENAME="7z1604-x64.exe"
}

$REMOTEURL="$REMOTEDIR\$FILENAME"
$INSTALL_PATH="${DST_PATH}\bin"

# Downloading the installer
Download-File $REMOTEURL "$DST_PATH\$FILENAME"

# Install the package
if(!(Test-Path -Path "${INSTALL_PATH}" )){
	pushd
	cd $DST_PATH
	cmd /c "$FILENAME /S /D=${INSTALL_PATH}"
	popd
}else{
	Write-Host "  -- Already installed"
}

"${INSTALL_PATH};" >> "path.env"