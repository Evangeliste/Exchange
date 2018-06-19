[CmdletBinding(SupportsShouldProcess = $true)] 
param ( 
    [string]$DatabasePath
)

$DataMove = Get-MailboxDatabase
$DBFolder = ""+$DataMove+"_DB"
$LGFolder = ""+$DataMove+"_LOG"

Move-DatabasePath $DataMove -EdbFilePath "$DatabasePath\$DBFolder\$DataMove.edb" -LogFolderPath "$DatabasePath\$LGFolder\" -Confirm:$false -Force

Set-MailboxDatabase $DataMove -CircularLoggingEnabled $true

Dismount-Database $DataMove -Confirm:$False
Mount-Database $DataMove -Confirm:$False