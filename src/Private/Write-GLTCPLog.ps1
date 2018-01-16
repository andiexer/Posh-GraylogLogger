function Write-GLTCPLog {
    param(
        [hashtable]$LogProperties
    )  

    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect($global:GLServer, $global:GLPort)
        
        if(!$tcpClient.Connected) {
            throw "unable to connect to endpoint over tcp"
        }

        $stream = $tcpClient.GetStream()
        $byteArrayJsonContent = [System.Text.Encoding]::ASCII.GetBytes((ConvertTo-Json -InputObject $LogProperties  -Compress))
        $byteArrayJsonContent += [Byte]0x00        
        $stream.Write($byteArrayJsonContent, 0,$byteArrayJsonContent.Length)
    }
    catch {
        Microsoft.PowerShell.Utility\Write-Error $_
    }
    finally {
        if($tcpClient.Connected) {
            $tcpClient.Close()
        }
    }
}