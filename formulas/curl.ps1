param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $installpath,
	  [string] $version,
      [string] $platform,
	  [string] $arch
)

$DST_PATH="$installpath/$version-$platform-$arch"

Write-Host "++ Building curl (version=$version, platform=$platform, arch=$arch"
Git-Update git://github.com/bagder/curl.git $DST_PATH
pushd
cd $DST_PATH
cmd /c "buildconf.bat"
cd winbuild
switch($platform)
{
	"msvc2010" {$VCVER="10"}
	"msvc2017" {$VCVER="16"}
}
nmake /f Makefile.vc mode=dll VC=$VCVER
popd