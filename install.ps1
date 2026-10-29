$ErrorActionPreference = 'Stop'
$appName = '透明 SPICE'
$installRoot = Join-Path $env:LOCALAPPDATA 'Programs\TransparentSPICE'
$sourceRoot = $PSScriptRoot
$menuRoot = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\透明 SPICE'
$desktop = [Environment]::GetFolderPath('Desktop')
New-Item -ItemType Directory -Force -Path $installRoot, $menuRoot | Out-Null
Copy-Item -LiteralPath (Join-Path $sourceRoot 'index.html') -Destination $installRoot -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot 'app.js') -Destination $installRoot -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot 'favicon.svg') -Destination $installRoot -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot 'uninstall.ps1') -Destination $installRoot -Force
$edgeCandidates = @(
  (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'),
  (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe')
)
$edge = $edgeCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
$entry = Join-Path $installRoot 'index.html'
$entryUri = ([System.Uri]$entry).AbsoluteUri
$shell = New-Object -ComObject WScript.Shell
function New-AppShortcut($path, $target, $arguments, $workingDirectory) {
  $shortcut = $shell.CreateShortcut($path)
  $shortcut.TargetPath = $target
  $shortcut.Arguments = $arguments
  $shortcut.WorkingDirectory = $workingDirectory
  $shortcut.Description = '透明 SPICE 电路分析教学软件'
  $shortcut.Save()
}
if ($edge) {
  $launchTarget = $edge
  $launchArguments = "--app=`"$entryUri`" --no-first-run"
} else {
  $launchTarget = $entry
  $launchArguments = ''
}
New-AppShortcut (Join-Path $menuRoot '透明 SPICE.lnk') $launchTarget $launchArguments $installRoot
New-AppShortcut (Join-Path $desktop '透明 SPICE.lnk') $launchTarget $launchArguments $installRoot
$uninstallScript = Join-Path $installRoot 'uninstall.ps1'
New-AppShortcut (Join-Path $menuRoot '卸载 透明 SPICE.lnk') 'powershell.exe' "-NoProfile -ExecutionPolicy Bypass -File `"$uninstallScript`"" $installRoot
$uninstallKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TransparentSPICE'
New-Item -Path $uninstallKey -Force | Out-Null
New-ItemProperty -Path $uninstallKey -Name DisplayName -Value $appName -PropertyType String -Force | Out-Null
New-ItemProperty -Path $uninstallKey -Name DisplayVersion -Value '1.0.0' -PropertyType String -Force | Out-Null
New-ItemProperty -Path $uninstallKey -Name InstallLocation -Value $installRoot -PropertyType String -Force | Out-Null
New-ItemProperty -Path $uninstallKey -Name UninstallString -Value "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$uninstallScript`"" -PropertyType String -Force | Out-Null
Start-Process -FilePath $launchTarget -ArgumentList $launchArguments
