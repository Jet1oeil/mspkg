param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $pkginstallpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

# Update the sources from git
$SRC_PATH="${pkginstallpath}\src"
$RELEASE_PATH="${pkginstallpath}\release"
Git-Update git://github.com/bagder/curl.git ${SRC_PATH}

# Build libcurl
pushd ${SRC_PATH}
if(!(Test-Path -Path "builds" )){
    if("$platform" -like "mingw32*"){
		if(!(Test-Path -Path "Makefile" )){
			buildconf.bat
		}
		mingw32-make mingw32
		
		Delete-Directory $RELEASE_PATH
		Create-Directory $RELEASE_PATH
		Create-Directory $RELEASE_PATH\bin
		Create-Directory $RELEASE_PATH\lib
		Copy-Item -Path $SRC_PATH\include -Recurse -Destination $RELEASE_PATH -Container
		Copy-Item -Path $SRC_PATH\lib\* -Include "*.a" -Destination $RELEASE_PATH\lib
		Copy-Item -Path $SRC_PATH\lib\* -Include "*.dll" -Destination $RELEASE_PATH\bin
		Copy-Item -Path $SRC_PATH\src\* -Include "*.exe" -Destination $RELEASE_PATH\bin
		
	}else{
		cmd /c "buildconf.bat"
		cd winbuild
		switch($platform)
		{
			"msvc2010" {$VCVER="10"}
			"msvc2017" {$VCVER="16"}
		}
		nmake /f Makefile.vc mode=dll VC=$VCVER
	}
}
popd