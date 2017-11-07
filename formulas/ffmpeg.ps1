param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $installpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

$DST_PATH="$installpath\$version-$platform-$arch"
Create-Directory $DST_PATH

$VERSION="ffmpeg-20170130-cba4f0e-win32"

# Downloading the package dev
$FILENAME="$VERSION-dev.zip"
$REMOTEURL="https://ffmpeg.zeranoe.com/builds/win32/dev/$FILENAME"
Download-File $REMOTEURL "$DST_PATH\$FILENAME"

# Downloading the package shared
$FILENAME="$VERSION-shared.zip"
$REMOTEURL="https://ffmpeg.zeranoe.com/builds/win32/shared/$FILENAME"
Download-File $REMOTEURL "$DST_PATH\$FILENAME"

pushd
cd $DST_PATH


# Remove-Item "release" -recurse

if(!(Test-Path -Path "release" )){
	# Extract archive dev
	$FILENAME="$VERSION-dev.zip"
	cmd /c "7z x ""$DST_PATH\$FILENAME"" "
	Rename-Item "$VERSION-dev" "release"
	# Extract archive shared
	$FILENAME="$VERSION-shared.zip"
	cmd /c "7z x ""$DST_PATH\$FILENAME"" "
	Move-Item "$VERSION-shared\bin" "release" -force
	Move-Item "$VERSION-shared\presets" "release" -force
	Remove-Item "$VERSION-shared" -recurse
}
popd