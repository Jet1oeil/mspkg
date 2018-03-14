param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $pkginstallpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

$REMOTEDIR="https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1"
if($arch -eq "x86"){
	$FILENAME="PortableGit-2.16.2-32-bit.7z.exe"
}else{
	$FILENAME="PortableGit-2.16.2-64-bit.7z.exe"
}

$REMOTEURL="$REMOTEDIR/$FILENAME"

# Downloading the installer
Download-File $REMOTEURL "${pkginstallpath}\$FILENAME"

# Install the package
if(!(Test-Path -Path "${pkginstallpath}\PortableGit" )){
	pushd ${pkginstallpath}
	# cmd /c "$FILENAME /SP- /VERYSILENT /SUPPRESSMSGBOXES /dir ${DST_PATH}\bin"
	# cmd /c "$FILENAME /SP- /VERYSILENT /SUPPRESSMSGBOXES /DIR="".\bin"""
	cmd /c "$FILENAME -y"
	popd
}else{
	Write-Host "  -- Already installed"
}

";${pkginstallpath}\PortableGit\bin" >> "$pkginstallpath/path.env"
";${pkginstallpath}\PortableGit\usr\bin" >> "$pkginstallpath/path.env"