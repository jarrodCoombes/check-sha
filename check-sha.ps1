<#

Exit Codes:
  10: Invalid File/path or file does not exist
  20: No Checksum hash supplied
  30: Invalid or unsupported Hash specified, or cannot calculate the type
#>

param(
	[string]$filePath,[string]$checksum
     )

#-------------- Functions -----------------------------------------
function Get-ChecksumType 
  {
    param(
           [string] $Checksum
         )

    if ($Checksum -match '^[0-9a-f]{32}$') 
    {
        return 'MD5'
    } 
    elseif ($Checksum -match '^[0-9a-f]{40}$') 
    {
        return 'SHA1'
    } 
    elseif ($Checksum -match '^[0-9a-f]{64}$') 
    {
        return 'SHA256'
    } 
    elseif ($Checksum -match '^[0-9a-f]{96}$') 
    {
        return 'SHA384'
    } 
    elseif ($Checksum -match '^[0-9a-f]{128}$') 
    {
        return 'SHA512'
    } 
    else 
    {
        return 'Unknown'
    }
  }

function syntaxError-file
    {
     echo ""
     echo "File and path are invalid or the file does not exist."
     echo ""
     echo "Note: The file needs to be specified first."
     echo "      e.g. check-sha <file> <given checksum>"
     echo ""
     exit 10
    }

function syntaxError-Checksum
    {
     echo ""
     echo "No checksum hash given"
     echo ""
     echo "Note: The checksum needs to be specified last"
     echo "      e.g. check-sha <file> <checksum>"
     echo ""
     exit 20
    }

function syntaxError-algorithm
    {
     echo ""
     echo "Unable to determining the hashing algorithm used."
     echo ""
     exit 30
    }

#-------------- End Functions ----------------------------------


#-------------- Input Checks ----------------------------------
# Check 1 - Make sure a file has been specified, and that it exists
if ( !(Test-Path -Path $filePath) )
   {
    syntaxError-file
   }

# Check 2 - Make sure a hash has been supplied
if ( $checksum -eq "" )
   {
    syntaxError-Checksum
   }

# Check 3 - Make sure that the supplied hash is in a valid format.

$algorithm = Get-ChecksumType $checksum

switch ($algorithm)
{
    "SHA1" {}

    "SHA256" {}

    "SHA384" {}

    "SHA512" {}

    "MD5" {}

    default { syntaxError-algorithm }
}
#-------------- End Input Checks ----------------------------------

echo ""
echo "Calculating the Checksum"
$calculatedChecksum = (Get-FileHash -path $filePath -Algorithm $algorithm ).hash

echo ""
echo "File                : $filePath"
echo "Algorithm           : $algorithm"
echo "Supplied Checksum   : $checksum"
echo "Calculated Checksum : $calculatedChecksum"

if ($calculatedChecksum -eq $checksum)
   {
    Write-Host "Result              : Checksum Matches" -ForegroundColor Green
   } 
else 
   {
    Write-Host "Result              : Checksum does not Match" -ForegroundColor Red
   }

echo ""


