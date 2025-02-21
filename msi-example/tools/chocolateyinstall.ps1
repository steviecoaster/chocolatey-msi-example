<#
  This is a minimal chocolateyInstall.ps1 script to download an msi installer from a web resource, and invoke it.
  You can perform any PowerShell necessary to completely install, and configure the software being installed by the package.
  You may also wish to use Package Hooks. See https://docs.chocolatey.org/en-us/features/hook/
#>

$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = '' # download url of the installer, HTTPS preferred

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  softwareName  = 'msi-example*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  checksum      = ''
  checksumType  = 'sha256' # Can also be md5, sha1, or sha512
  # MSI standard silent installation arguments, with added VERY verbose logging
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" 
  validExitCodes= @(0, 3010, 1641) # 3010 and 1641 set reboot flags, and are safe as exit codes. Some installers use alternate exit codes. Test this!
}

<# Put any code that should be run BEFORE executing the installer here #>

# This helper function downloads and runs an installer. See https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage/
Install-ChocolateyPackage @packageArgs 

<# Put any code that should be run AFTER executing the installer here #>