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
#       Usage : Set-ExchangeVirtualDirectories.ps1 -ExchServer EXCHANGESERVER -URLInternal INTERNAL-FQDN -URLExternal EXTERNAL-FQDN
#
#########################################################################################################################

#Function/Module
#########################################################################################################################

[CmdletBinding(SupportsShouldProcess = $true)] 
param ( 
    [string]$ExchServer,
    [string]$URLInternal,
    [string]$URLExternal
)

Set-EcpVirtualDirectory -Identity "$ExchServer\ecp (Default Web site)" -InternalUrl "https://$URLInternal/ecp" -ExternalURL "https://$URLExternal/ecp" -Confirm:$False
Set-WebServicesVirtualDirectory -Identity "$ExchServer\EWS (Default Web Site)" -InternalUrl "https://$URLInternal/EWS/Exchange.asmx" -ExternalURL "https://$URLExternal/EWS/Exchange.asmx" -Confirm:$False
Set-MapiVirtualDirectory -Identity "$ExchServer\mapi (Default Web Site)" -InternalUrl "https://$URLInternal/mapi" -ExternalURL "https://$URLExternal/mapi" -Confirm:$False
Set-ActiveSyncVirtualDirectory -Identity "$ExchServer\Microsoft-Server-ActiveSync (Default Web Site)" -InternalUrl "https://$URLInternal/Microsoft-Server-ActiveSync" -ExternalURL "https://$URLExternal/Microsoft-Server-ActiveSync" -Confirm:$False
Set-OabVirtualDirectory -Identity "$ExchServer\OAB (default Web site)" -InternalUrl "https://$URLInternal/OAB" -ExternalURL "https://$URLExternal/OAB" -Confirm:$False
Set-OwaVirtualDirectory -Identity "$ExchServer\owa (default Web site)" -InternalUrl "https://$URLInternal/owa" -ExternalURL "https://$URLExternal/owa" -Confirm:$False
Set-PowerShellVirtualDirectory -Identity "$ExchServer\PowerShell (Default Web Site)" -InternalUrl "https://$URLInternal/powershell" -ExternalURL "https://$URLExternal/powershell" -Confirm:$False