param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $command,
      [Parameter(Mandatory = $true, Position = 1)]
      [string] $pkg,
      [string] $platform
)

function Create-Directory
{
	param( [string]$newpath)
	if(!(Test-Path -Path $newpath )){
		Write-Host "Creating directory $newpath"
		New-Item -path "$newpath" -type directory
	}
}

function Git-Update
{
	param( [string]$gitrepos, [string]$dstpath)
	Write-Host "++ Git update $gitrepos => $dstpath"
	if((Test-Path -Path $dstpath )){
		pushd
		cd $dstpath
		git pull
		popd
	}else{
		git clone $gitrepos $dstpath
	}
}

function Install-Package
{
	param([string]$pkg, [string]$platform, [string]$installpath)
	
	$PKG_VERSION="git"
	$DST_PATH="$installpath/$pkg/$PKG_VERSION-$platform"
	
	Write-Host "++ Updating $pkg sources"
	Git-Update git://github.com/bagder/curl.git $DST_PATH
	Write-Host "++ Building $pkg"
	pushd
	cd $DST_PATH
	cmd /c "buildconf.bat"
	cd winbuild
	nmake /f Makefile.vc mode=dll VC=10
	popd
	
}

Write-Host "Lanching command $command $pkg"

$ENV_PATH="./env"
$INSTALL_PATH="./install"

# Prepare environnement
Write-Host "++ Setting environnement for $platform"
switch ($platform)
{
	"msvc2010-x86" {Invoke-Expression "$ENV_PATH/$platform.ps1"}
}


if ($command -eq "install") {
	Create-Directory "$INSTALL_PATH"

	Install-Package "$pkg" "$platform" "$INSTALL_PATH"
}