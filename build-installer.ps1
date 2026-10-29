param([string]$Version = '1.0.0')

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$distRoot = Join-Path $projectRoot 'dist'
$buildRoot = Join-Path $env:TEMP 'transparent-spice-build'
$payloadRoot = Join-Path $buildRoot 'payload'
$stagedOutput = Join-Path $buildRoot 'TransparentSPICE-Setup.exe'
$outputPath = Join-Path $distRoot '透明SPICE-Setup.exe'
$sedPath = Join-Path $buildRoot 'setup.sed'
$iexpress = Join-Path $env:WINDIR 'System32\iexpress.exe'
if (-not (Test-Path -LiteralPath $iexpress)) { throw '找不到 Windows IExpress。' }
if (Test-Path -LiteralPath $buildRoot) { Remove-Item -LiteralPath $buildRoot -Recurse -Force }
New-Item -ItemType Directory -Force -Path $payloadRoot, $distRoot | Out-Null
foreach ($file in @('index.html','app.js','favicon.svg')) {
  Copy-Item -LiteralPath (Join-Path $projectRoot $file) -Destination $payloadRoot -Force
}
foreach ($file in @('install.ps1','uninstall.ps1')) {
  Copy-Item -LiteralPath (Join-Path $PSScriptRoot $file) -Destination $payloadRoot -Force
}
$installScript = Join-Path $payloadRoot 'install.ps1'
$installContent = Get-Content -LiteralPath $installScript -Raw
$installContent = $installContent.Replace("DisplayVersion -Value '1.0.0'", "DisplayVersion -Value '$Version'")
Set-Content -LiteralPath $installScript -Value $installContent -Encoding UTF8
$sed = @"
[Version]
Class=IEXPRESS
SEDVersion=3
[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=0
HideExtractAnimation=1
UseLongFileName=1
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=
DisplayLicense=
FinishMessage=Installation complete. Start the app from the Start menu or desktop.
TargetName=$stagedOutput
FriendlyName=Transparent SPICE Setup
AppLaunched=powershell.exe -NoProfile -ExecutionPolicy Bypass -File install.ps1
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
SourceFiles=SourceFiles
[SourceFiles]
SourceFiles0=$payloadRoot
[SourceFiles0]
%FILE0%=
%FILE1%=
%FILE2%=
%FILE3%=
%FILE4%=
[Strings]
FILE0="index.html"
FILE1="app.js"
FILE2="install.ps1"
FILE3="uninstall.ps1"
FILE4="favicon.svg"
"@
Set-Content -LiteralPath $sedPath -Value $sed -Encoding Default
$build = Start-Process -FilePath $iexpress -ArgumentList @('/N','/Q','/M',$sedPath) -Wait -PassThru -WindowStyle Hidden
if ($build.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $stagedOutput)) {
  throw "IExpress 构建失败，退出码 $($build.ExitCode)"
}
Copy-Item -LiteralPath $stagedOutput -Destination $outputPath -Force
Write-Output "安装包已生成：$outputPath"
