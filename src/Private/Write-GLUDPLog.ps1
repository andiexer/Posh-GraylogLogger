function Write-GLUDPLog {
    param(
        [hashtable]$LogProperties
    )   

    $magicBytes = @([byte]0x1e,[byte]0x0f)
    $udpClient = New-Object System.Net.Sockets.UdpClient

    $byteArrayJsonContent = [System.Text.Encoding]::ASCII.GetBytes((ConvertTo-Json -InputObject $LogProperties  -Compress))
    try {
        $udpClient.Connect($global:GLServer, $global:GLPort)

        if($byteArrayJsonContent.Length -gt 8192)
        {
            Write-Debug "message to big for one packet. chunking"
            $chunkSize = 8000
            $numberOfChunks = [math]::Ceiling($byteArrayJsonContent.Length / $chunkSize)
            Write-Debug "amount of chunks to send: $numberOfChunks"

            $messageId = New-Object Byte[] 8
            (New-Object Random).NextBytes($messageId)

            for($i = 0; $i -lt $numberOfChunks;$i++) {
                $sequenceNumber = [byte]$i
                $startIndex = $i * $chunkSize
                $endIndex = $startIndex + $chunkSize -1
                if($endIndex -gt $byteArrayJsonContent.Length) { $endIndex = $byteArrayJsonContent.Length -1}
                Write-Debug "startindex: $startIndex endIndex: $endIndex"
                $chunkData = $byteArrayJsonContent[$startIndex .. $endIndex]
                $chunkPacket = $magicBytes + $messageId + $sequenceNumber + $numberOfChunks + $chunkData
                Write-Debug "sending chunk $($i + 1) from $($numberOfChunks)"
                $udpClient.Send($chunkPacket, $chunkPacket.Length) | out-null
            }
        }
        else 
        {
            Write-Debug "log message smaller than 8192 bytes. sending one request without chunks and sequencenumber"
            $udpClient.Send($byteArrayJsonContent, $byteArrayJsonContent.Length) | out-null
        }
    }
    catch {
       Write-Error $_
    } finally {
        $udpClient.Close();
    }
}