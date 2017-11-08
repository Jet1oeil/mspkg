param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $pkginstallpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

if($arch -eq "x86"){
	$VERSIONARCH = "win32"
}else{
	$VERSIONARCH = "win64"
}

$VERSION="ffmpeg-20170130-cba4f0e-$VERSIONARCH"

# Downloading the package dev
$FILENAME="$VERSION-dev.zip"
$REMOTEURL="https://ffmpeg.zeranoe.com/builds/$VERSIONARCH/dev/$FILENAME"
Download-File $REMOTEURL "${pkginstallpath}\$FILENAME"

# Downloading the package shared
$FILENAME="$VERSION-shared.zip"
$REMOTEURL="https://ffmpeg.zeranoe.com/builds/$VERSIONARCH/shared/$FILENAME"
Download-File $REMOTEURL "${pkginstallpath}\$FILENAME"

pushd ${pkginstallpath}

# Remove-Item "release" -recurse

if(!(Test-Path -Path "release" )){
	# Extract archive dev
	$FILENAME="$VERSION-dev.zip"
	cmd /c "7z x ""${pkginstallpath}\$FILENAME"" "
	Rename-Item "$VERSION-dev" "release"
	# Extract archive shared
	$FILENAME="$VERSION-shared.zip"
	cmd /c "7z x ""${pkginstallpath}\$FILENAME"" "
	Move-Item "$VERSION-shared\bin" "release" -force
	Move-Item "$VERSION-shared\presets" "release" -force
	Remove-Item "$VERSION-shared" -recurse
}
popd