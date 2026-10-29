$appRoot = Join-Path $env:LOCALAPPDATA 'Programs\TransparentSPICE'
$menuRoot = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\透明 SPICE'
$desktopShortcut = Join-Path ([Environment]::GetFolderPath('Desktop')) '透明 SPICE.lnk'
Remove-Item -LiteralPath $menuRoot -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $desktopShortcut -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TransparentSPICE' -Recurse -Force -ErrorAction SilentlyContinue
$cleanup = "Start-Sleep -Seconds 1; Remove-Item -LiteralPath '$appRoot' -Recurse -Force -ErrorAction SilentlyContinue"
Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-Command',$cleanup) -WindowStyle Hidden
