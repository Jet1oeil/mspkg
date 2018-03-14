param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $command,
      [Parameter(Mandatory = $true, Position = 1)]
      [string] $pkg,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

$ENV_PATH = Join-Path(pwd) '\env'
$VE_ROOTPATH =  Join-Path(pwd) '\ve'
$FORMULAS_PATH =  Join-Path(pwd) '\formulas'


if((Test-Path -Path "path.env" )){
	$pathenv = (Get-Content "path.env") -join ""
	$env:Path+= ";$pathenv"
}

function Create-Directory
{
	param( [string]$newpath)
	if(!(Test-Path -Path $newpath )){
		Write-Host "  -- Creating directory $newpath"
		New-Item -path "$newpath" -type directory
	}
}

function Delete-Directory
{
	param( [string]$dirpath)
	if((Test-Path -Path $dirpath )){
		Write-Host "  -- Deleting directory $dirpath"
		Remove-Item $dirpath -Force -Recurse
	}
}

function Download-File
{
	param( [string]$url, [string]$dstpath)
	if(!(Test-Path -Path $dstpath )){
		Write-Host "  -- Downloading $url => $dstpath"
		$client = new-object System.Net.WebClient
		$client.DownloadFile("$url","$dstpath")
	}
}

function Git-Update
{
	param( [string]$gitrepos, [string]$dstpath)
	if((Test-Path -Path $dstpath )){
		Write-Host "  -- Git update $gitrepos => $dstpath"
		pushd
		cd $dstpath
		git pull
		popd
	}else{
		Write-Host "  -- Git clone $gitrepos => $dstpath"
		git clone $gitrepos $dstpath
	}
}

function Patch-Line
{
	param([string]$filepath, [string]$regexA, [string]$replacementA)
	
	# Patch the files
	Get-ChildItem  "$filepath" | % {
	$c = (Get-Content $_.FullName) -replace $regexA,$replacementA -join "`r`n"
	  [IO.File]::WriteAllText($_.FullName, $c)
	}
	
}

function Install-Package
{
	param([string]$pkg, [string]$version, [string]$platform, [string]$arch, [string]$vepath)
	
	Write-Host "++ Installing $pkg $platform"
	
	#$FORMULA_FILE="$FORMULAS_PATH/$pkg.json"
	
	# Write-Host "++ Installing $pkg (from $FORMULA_FILE) $platform"
	# Get version to install
	# $json = Get-Content $FORMULA_FILE | ConvertFrom-Json
	# Write-Host $json.name
	
	#if($version -eq ""){
	#	$version="default"
	#}
	
	$PKG_INSTALL_PATH="$vepath\$pkg\$version"
	Create-Directory "$PKG_INSTALL_PATH"
	
	$INSTALL_SCRIPT="$FORMULAS_PATH\$pkg.ps1"
	Write-Host "  -- Launching $INSTALL_SCRIPT"
	
	Write-Host "++ Building $pkg (version=$version, platform=$platform, arch=$arch)"
	Invoke-Expression -Command "$INSTALL_SCRIPT -version $version -platform $platform -arch $arch $PKG_INSTALL_PATH"
	
}

Write-Host "Launching command $command $pkg"

# Prepare environnement
Write-Host "++ Setting environment for $platform"
$PLATEFORM_ARCH="$platform-$arch"
if (Test-Path "$ENV_PATH\$PLATEFORM_ARCH.ps1")
{
  Invoke-Expression "$ENV_PATH\$PLATEFORM_ARCH.ps1"
}
if((Test-Path -Path "$ENV_PATH\$PLATEFORM_ARCH.env" )){
    # File must be prepended by a ;
	$pathenv = (Get-Content "$ENV_PATH\$PLATEFORM_ARCH.env") -join ""
	$env:Path+= "$pathenv"
}
Write-Host "++ PATH is $env:Path"

# Execute "install" command
if ($command -eq "install") {
	$VE_PATH="$VE_ROOTPATH\$platform-$arch"
	Create-Directory "$VE_PATH"

	Install-Package "$pkg" -version "$version" -platform "$platform" -arch "$arch" "$VE_PATH"
}