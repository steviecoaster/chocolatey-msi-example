<#
  Uninstalling a piece of software requires:
  - Knowing the Product GUID of the software
  - Passing appropriate silent arguments to msiexec
#>

$ErrorActionPreference = 'Stop' # stop on all errors

# First we'll define a hashtable of MOST of the information we will need
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'msi-example*'  #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  fileType       = 'MSI'
  silentArgs     = "" # We'll leave this empty here, and add them later, once we know the Prodcut GUID
  validExitCodes = @(0, 3010, 1605, 1614, 1641) # https://msdn.microsoft.com/en-us/library/aa376931(v=vs.85).aspx
}

# Get the uninstall registry hive for the software
$keys = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName'] # See https://docs.chocolatey.org/en-us/create/functions/get-uninstallregistrykey/

# Save GUID to a variable
$ProductGUID = $keys.PSChildName

# Add silent args. /X is handled for us automatically, so don't include it
$packageArgs['silentArgs'] = "$ProductGUID /qn /norestart"

#Uninstall the software
Uninstall-ChocolateyPackage @packageArgs # See https://docs.chocolatey.org/en-us/create/functions/uninstall-chocolateypackage/
