#########################################################################################################################
#
#		Script for : Move Exchange Default DB to another volume and enable 'CircularLoggingEnabled'
#
#		Script author : Alexis / Evangeliste
#		mail 	: alexi@inventiq.fr
#		Create 	: 19 Juin 2018
#		Version	: 1.0
#		UPDate 	:
#
#       Usage : Move-ExchangeDefaultDB.ps1 -DatabasePath "D:\Microsoft Exchange\"
#
#########################################################################################################################

#Function/Module
#########################################################################################################################

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