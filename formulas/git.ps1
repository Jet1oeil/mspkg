param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $installpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

$DST_PATH="$installpath\$version-$platform-$arch"
Create-Directory $DST_PATH

$REMOTEDIR="https://github.com/git-for-windows/git/releases/download/v2.15.0.windows.1"
if($arch -eq "x86"){
	$FILENAME="PortableGit-2.15.0-32-bit.7z.exe"
}else{
	$FILENAME="PortableGit-2.15.0-64-bit.7z.exe"
}

$REMOTEURL="$REMOTEDIR\$FILENAME"

# Downloading the installer
Download-File $REMOTEURL "$DST_PATH\$FILENAME"

# Install the package
if(!(Test-Path -Path "${DST_PATH}\PortableGit" )){
	pushd
	cd $DST_PATH
	# cmd /c "$FILENAME /SP- /VERYSILENT /SUPPRESSMSGBOXES /dir ${DST_PATH}\bin"
	# cmd /c "$FILENAME /SP- /VERYSILENT /SUPPRESSMSGBOXES /DIR="".\bin"""
	cmd /c "$FILENAME -y"
	popd
}else{
	Write-Host "  -- Already installed"
}

"${DST_PATH}\PortableGit\bin;" >> "path.env"
"${DST_PATH}\PortableGit\usr\bin;" >> "path.env"