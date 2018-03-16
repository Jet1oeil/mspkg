param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $command,
      [Parameter(Mandatory = $true, Position = 1)]
      [string] $pkg,
	  [string] $version
)

$VE_ROOTPATH = pwd

$VE_ENV_FILE="$VE_ROOTPATH\mspkg.env"
if(!(Test-Path -Path "$VE_ENV_FILE" )){
	Write-Host "++ Current directory doesn't seem to be a virtual environment"
	exit
}
$lines = cat "$VE_ENV_FILE"
foreach ($line in $lines) {
    $tokens = $line.Split("=");
    $varname = $tokens[0];
    $varvalue = $tokens[1];
	[System.Environment]::SetEnvironmentVariable("$varname", "$varvalue")
}

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
	param([string]$pkg, [string]$version, [string]$vepath)
	
	Write-Host "++ Installing $pkg for $env:MSPKG_VE_PLATFORM $env:MSPKG_VE_ARCH"
	
	#$FORMULA_FILE="$FORMULAS_PATH/$pkg.json"
	
	# Write-Host "++ Installing $pkg (from $FORMULA_FILE) $platform"
	# Get version to install
	# $json = Get-Content $FORMULA_FILE | ConvertFrom-Json
	# Write-Host $json.name
	
	#if($version -eq ""){
	#	$version="default"
	#}
	
	$PKG_INSTALL_PATH="$vepath\$pkg"
	Create-Directory "$PKG_INSTALL_PATH"
	
	$INSTALL_SCRIPT="$env:MSPKG_FORMULAS_PATH\$pkg.ps1"
	Write-Host "  -- Launching $INSTALL_SCRIPT"
	
	Write-Host "++ Building $pkg (version=$version, platform=$env:MSPKG_VE_PLATFORM, arch=$env:MSPKG_VE_ARCH)"
	Invoke-Expression -Command "$INSTALL_SCRIPT -version $version $PKG_INSTALL_PATH"
	
}

Write-Host "Launching command $command $pkg"

# Prepare environnement
Write-Host "++ Setting environment for $platform"
$PLATEFORM_ARCH="$env:MSPKG_VE_PLATFORM-$env:MSPKG_VE_ARCH"
if (Test-Path "$env:MSPKG_ENV_PATH\$PLATEFORM_ARCH.ps1")
{
  Invoke-Expression "$env:MSPKG_ENV_PATH\$PLATEFORM_ARCH.ps1"
}
Write-Host "++ $env:MSPKG_ENV_PATH\$PLATEFORM_ARCH.env"
if((Test-Path -Path "$env:MSPKG_ENV_PATH\$PLATEFORM_ARCH.env" )){
    # File must be prepended by a ;
	$pathenv = (Get-Content "$env:MSPKG_ENV_PATH\$PLATEFORM_ARCH.env") -join ""
	$env:Path+= "$pathenv"
}
# Add all bin path of each modules
foreach($moduledir in get-childitem) {
    if ($moduledir.Attributes -eq "Directory") {
		if((Test-Path -Path "$VE_ROOTPATH\$moduledir\path.env" )){
			# File must be prepended by a ;
			$pathenv = (Get-Content "$VE_ROOTPATH\$moduledir\path.env") -join ""
			$env:Path+= "$pathenv"
		}
    }
}

Write-Host "++ PATH is $env:Path"
# ls Env:

# Execute "install" command
if ($command -eq "install") {
	Create-Directory "$VE_ROOTPATH"

	Install-Package "$pkg" -version "$version" "$VE_ROOTPATH"
}