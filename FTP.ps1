#Begin FTP Section
#download winSCPnet.dll first
#Now let upload this to the FTP
try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"

    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Ftp
    HostName = "server"
    PortNumber = 21
    UserName = "username"
    Password = 'password'
    FtpSecure = [WinSCP.FtpSecure]::Explicit
    
    }

    $session = New-Object WinSCP.Session
    
    try
    {
        # Connect
        $session.Open($sessionOptions)
 
        # Upload files
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
 
        $transferResult =
        #copy and past below if you wan to upload more files. First path is your files you want to upload. Second is the ftp locaiton. 
            $session.PutFiles("C:\Users\alex\Documents\Powershell\FTP\Configs.zip", "/alex/", $False, $transferOptions)
        # Throw on any error
        $transferResult.Check()  

        foreach ($transfer in $transferResult.Transfers)
        {
            Write-Host "Upload of $($transfer.FileName) succeeded"
        }      

    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
 
    #exit 0
}
catch
{
    $errorText = "Error: $($_.Exception.Message)"
    #$errorText | Add-Content 'C:\Users\alex\Documents\Powershell\FTP Files\FTP Log\FTP Log.txt'
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}
