param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $pkginstallpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

# Update the sources from git
$SRC_PATH="${pkginstallpath}\src"
Git-Update git://github.com/bagder/curl.git ${SRC_PATH}

# Build libcurl
pushd ${SRC_PATH}
if(!(Test-Path -Path "builds" )){
	cmd /c "buildconf.bat"
	cd winbuild
	switch($platform)
	{
		"msvc2010" {$VCVER="10"}
		"msvc2017" {$VCVER="16"}
	}
	nmake /f Makefile.vc mode=dll VC=$VCVER
}
popd