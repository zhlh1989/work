Get-WmiObject -Class Win32_NetworkAdapterConfiguration |?{$_.IpEnabled -eq 'True'} | ? {$_.DefaultIPGateway -ne $null } | ?{$_.DHCPEnabled -eq 'True'} | ForEach-Object {
    $adp = $_
    # $index = $adp.Index
    $IPAddress = $adp.IPAddress
    $DNSServerSearchOrder = $adp.DNSServerSearchOrder
    $DefaultIPGateway = $adp.DefaultIPGateway
    $IPSubnet = $adp.IPSubnet
    
    # $_.DHCPEnabled = $false
    # set static ip
    for($i=0; $i -lt $IPAddress.Count; $i++){
        $ip = $IPAddress[$i]
        $netmask = $IPSubnet[$i]
        Write-Host $ip, $netmask
        if ($ip.Contains('::')){
            Write-Host "${ip} is a ipv6 address, do not set to static."
        }else{
           $ret = $_.EnableStatic($ip, $netmask)
           #$ret 
           if ($ret.ReturnValue -eq 0){
                Write-Host "Set ip ${ip} with netmask ${netmask} to static successfully."
           }else{
                Write-Host "Set ip ${ip} with netmask ${netmask} to static failed."
           }
       }
    }
    
   Start-Sleep -Seconds 2
    # set gateway
    $ret = $_.SetGateways($DefaultIPGateway,1)
    #$ret
    if ($ret.ReturnValue -eq 0){
        Write-Host "Set gateway to ${gateway} successfully."
    }else {
        Write-Host "Set gateway to ${gateway} failed."
    }
    
    # set DNSServer
    Write-Host "DNSServerSearchOrder->", $DNSServerSearchOrder

    $dnsservers = [System.Collections.ArrayList]@()
    if ($DNSServerSearchOrder.Count -gt 2){
        Write-Host "More than two dns server set."
        foreach ($e in  $DNSServerSearchOrder){
            if ($e -ne '127.0.0.1'){
                $dnsservers.Add($e)
            }
        }
        $dnsservers = $dnsservers[0..1]
    }else{
        $dnsservers = $DNSServerSearchOrder
    }
    Write-Host $dnsservers

    if (($DNSServerSearchOrder -contains '127.0.0.1') -or ($DNSServerSearchOrder.Count -gt 2)){
        $ret = $_.SetDNSServerSearchOrder($dnsservers)
    }else{
        $ret = $_.SetDNSServerSearchOrder($DNSServerSearchOrder)
    }

    # $ret 
    if ($ret.ReturnValue -eq 0){
        Write-Host "Set DNS Server successfully."
    }else {
        Write-Host "Set DNS Server failed."
    }
}