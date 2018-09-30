#########################################################################################################################
#
#		Script for : Move Exchange Default DB to another volume and enable 'CircularLoggingEnabled'
#
#		Script author : Alexis / Evangeliste
#		mail 	: alexi@inventiq.fr
#		Create 	: 19 Juin 2018
#		Version	: 1.1
#		UPDate 	: 1.1 : 30 Septembre 2018, prise en charge d'un mode debug par défaut, prise en charge du serveur d'execution
#
#       Usage : Move-ExchangeDefaultDB.ps1 -DatabasePath "D:\Microsoft Exchange\"
#
#########################################################################################################################

#Function/Module
#########################################################################################################################

[CmdletBinding(SupportsShouldProcess = $true)] 
param ( 
    [string]$DatabasePath,
    $DebugMode = $true
)

#Variables
#########################################################################################################################
$DataMove = Get-MailboxDatabase -Server $env:ComputerName
$DBToMove = $DataMove.Name
$DBFolder = ""+$DBToMove+"_DB"
$LGFolder = ""+$DBToMove+"_LOG"

#Module
#########################################################################################################################
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;

#Active Mode
#########################################################################################################################
IF ($DebugMode -eq $true)
    {
    Write-Host "#####################################################################################################################" -ForegroundColor Yellow
    Write-Host "#                                                                                                                   #" -ForegroundColor Yellow
    Write-Host "#                                       /!\ Running in Evaluate mode /!\                                            #" -ForegroundColor Yellow
    Write-Host "#                                                                                                                   #" -ForegroundColor Yellow
    Write-Host "#####################################################################################################################" -ForegroundColor Yellow
    $errorActionPreference = "Continue"
    }
ELSE 
    {
    Write-Host "#####################################################################################################################" -ForegroundColor Green
    Write-Host "#                                                                                                                   #" -ForegroundColor Green
    Write-Host "#                                       /!\ Running in Active mode /!\                                              #" -ForegroundColor Red
    Write-Host "#                                                                                                                   #" -ForegroundColor Green
    Write-Host "#####################################################################################################################" -ForegroundColor Green
    $errorActionPreference = "SilentlyContinue"
    }

IF ($DebugMode -eq $true)
    {
    Move-DatabasePath $DBToMove -EdbFilePath "$DatabasePath\$DBFolder\$DBToMove.edb" -LogFolderPath "$DatabasePath\$LGFolder\" -Confirm:$false -Force -whatif
    Set-MailboxDatabase $DataMove -CircularLoggingEnabled $true -whatif
    }
else
    {
    Move-DatabasePath $DBToMove -EdbFilePath "$DatabasePath\$DBFolder\$DBToMove.edb" -LogFolderPath "$DatabasePath\$LGFolder\" -Confirm:$false -Force
    Set-MailboxDatabase $DataMove -CircularLoggingEnabled $true

    Dismount-Database $DataMove -Confirm:$False
    Mount-Database $DataMove -Confirm:$False
    }