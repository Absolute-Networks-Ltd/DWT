$AOVPNName = "DeviceTunnel"
$ConnectionAttempts = 45

$Tries = 0
$OnDomain = $false

# -- Determine if we are domain authenticated or not --     
$result = Get-NetConnectionProfile
foreach ($res in $result) {
    if ($res.NetworkCategory -eq 'DomainAuthenticated') {
        $OnDomain = $true
        break
    } else {
        $OnDomain = $false
    }
}     
    
if (!($OnDomain)) {
    while ((Get-VpnConnection -AllUserConnection $AOVPNName).ConnectionStatus -ne 'Connected') {             
        # -- Attempt to reconnect --
        start-process -FilePath $env:windir\system32\rasdial.exe -ArgumentList $AOVPNName -NoNewWindow -Wait
                               
        start-sleep -Seconds 2

        if ($ConnectionAttempts -gt 0) {
            $tries++
            # -- Attempted to reconnect xx times but failed - give up --
            if ($tries -eq $ConnectionAttempts) {exit}
        }
    }
}