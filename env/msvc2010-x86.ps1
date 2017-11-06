# Set environment variables for Visual Studio Command Prompt
pushd 'C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\'
cmd /c "vcvars32.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd
write-host "`nVisual Studio 2010 Command Prompt variables set." -ForegroundColor Yellow