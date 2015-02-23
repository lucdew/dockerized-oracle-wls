
#------------------------
# Functions
#------------------------

Function Download-File($url,$out) {

   Write-Host "Downloading $url to $out"""
   $wc = new-object system.net.WebClient

   $proxy = [System.Net.WebRequest]::GetSystemWebProxy()
   if ($proxy)
   {
       $proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
       $wc.proxy = $proxy
   }

   $wc.DownloadFile($url, $out)

}
#------------------------
# Main below
#------------------------

# boot2docker dir creation
$destPath = $env:userprofile + "\.boot2docker" 
if (-not (test-path $destPath) ) {
    New-Item -Path $destPath -ItemType "directory"
} 

# boot2docker iso download
$source = "https://github.com/boot2docker/boot2docker/releases/download/v1.5.0/boot2docker.iso"
$destination = $destPath + "\boot2docker.iso"

Download-File $source $destination


# Copy profile file
Copy-Item -Path boot2docker.cfg -Destination $destPath\profile

