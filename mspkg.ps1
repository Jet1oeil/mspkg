param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $command,
      [Parameter(Mandatory = $true, Position = 1)]
      [string] $pkg,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

$ENV_PATH="./env"
$INSTALL_PATH="./install"
$FORMULAS_PATH="./formulas"

function Create-Directory
{
	param( [string]$newpath)
	if(!(Test-Path -Path $newpath )){
		Write-Host "  -- Creating directory $newpath"
		New-Item -path "$newpath" -type directory
	}
}

function Download-File
{
	param( [string]$url, [string]$dstpath)
	Write-Host "  -- Downloading $url => $dstpath"
	$client = new-object System.Net.WebClient
	$client.DownloadFile("$url","$dstpath")
}

function Git-Update
{
	param( [string]$gitrepos, [string]$dstpath)
	Write-Host "  -- Git update $gitrepos => $dstpath"
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
	param([string]$pkg, [string]$version, [string]$platform, [string]$arch, [string]$installpath)
	
	$FORMULA_FILE="$FORMULAS_PATH/$pkg.json"
	
	Write-Host "++ Installing $pkg (from $FORMULA_FILE) $platform"
	# Get version to install
	# $json = Get-Content $FORMULA_FILE | ConvertFrom-Json
	# Write-Host $json.name
	
	#if($version -eq ""){
	#	$version="default"
	#}
	
	$DST_PATH="$installpath/$pkg"
	
	$INSTALL_SCRIPT="$FORMULAS_PATH/$pkg.ps1"
	Write-Host "  -- Launching $INSTALL_SCRIPT"
	
	Invoke-Expression -Command "$INSTALL_SCRIPT -version git -platform $platform -arch $arch $DST_PATH"
	
}

Write-Host "Lanching command $command $pkg"

# Prepare environnement
Write-Host "++ Setting environnement for $platform"
$PLATEFORM_ARCH="$platform-$arch"

switch ($PLATEFORM_ARCH)
{
	"msvc2010-x86" {Invoke-Expression "$ENV_PATH/$PLATEFORM_ARCH.ps1"}
}


if ($command -eq "install") {
	Create-Directory "$INSTALL_PATH"

	Install-Package "$pkg" -version "$version" -platform "$platform" -arch "$arch" "$INSTALL_PATH"
}