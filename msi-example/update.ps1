<#
    This is an update script from a real-world package to use an example
    
    The important pieces of information to capture are:

    - Software Version: This is available via the github releases api in this example, 
      but may need queried from the installer properties if downloading from elsewhere
    - Download Url: Again, this is available via github releases, but you may need a
      different method of determining
    - Checksum: AU automatically downloads and checksums the installer for us and adds
      it to the $Latest variable

      For more information check out this blog post: https://blog.chocolatey.org/2024/07/automating-chocolatey-package-updates/
#>
Import-Module Chocolatey-AU

function global:au_GetLatest {

    # Grab the latest release information from the Github Releases API
    $LatestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/inedo/pgutil/releases/latest"

    @{
        URL   = ($LatestRelease.assets | Where-Object { $_.name -eq 'pgutil-win-x64.zip' }).browser_download_url
        Version = $LatestRelease.tag_name.TrimStart('v')
    }
}
 
function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*(\$)url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
        }

    }
}

update -ChecksumFor 32 -NoCheckChocoVersion