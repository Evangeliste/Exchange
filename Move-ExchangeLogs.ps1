# ------------------------ 
# MoveEX2013logs.ps1 
# ------------------------ 
# 
# Version 1.0 by KSB 
# 
# This script will move all of the configurable logs for Exchange 2013 from the C: drive 
# to the L: drive.  The folder subtree and paths on L: will stay the same as they were on C: 
# 
# Get the name of the local computer and set it to a variable for use later on.

[CmdletBinding(SupportsShouldProcess = $true)] 
param ( 
    [string]$NewLogPath
)

# Create folders tree
mkdir "$NewLogPath\TransportRoles\Logs\Hub\Connectivity"
mkdir "$NewLogPath\TransportRoles\Logs\MessageTracking" 
mkdir "$NewLogPath\Logging\IRMLogs" 
mkdir "$NewLogPath\TransportRoles\Logs\Hub\ActiveUsersStats" 
mkdir "$NewLogPath\TransportRoles\Logs\Hub\ServerStats" 
mkdir "$NewLogPath\TransportRoles\Logs\Hub\ProtocolLog\SmtpReceive" 
mkdir "$NewLogPath\TransportRoles\Logs\Hub\Routing" 
mkdir "$NewLogPath\TransportRoles\Logs\Hub\ProtocolLog\SmtpSend" 
mkdir "$NewLogPath\TransportRoles\Logs\Hub\QueueViewer" 
mkdir "$NewLogPath\TransportRoles\Logs\Hub\WLM" 
mkdir "$NewLogPath\TransportRoles\Logs\Hub\PipelineTracing" 
mkdir "$NewLogPath\TransportRoles\Logs\Hub\AgentLog"
mkdir "$NewLogPath\TransportRoles\Logs\FrontEnd\AgentLog" 
mkdir "$NewLogPath\TransportRoles\Logs\FrontEnd\Connectivity"
mkdir "$NewLogPath\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpReceive" 
mkdir "$NewLogPath\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpSend"
mkdir "$NewLogPath\Logging\Calendar Repair Assistant" 
mkdir "$NewLogPath\Logging\Managed Folder Assistant"
mkdir "$NewLogPath\TransportRoles\Logs\Mailbox\Connectivity" 
mkdir "$NewLogPath\TransportRoles\Logs\Mailbox\AgentLog\Delivery" 
mkdir "$NewLogPath\TransportRoles\Logs\Mailbox\AgentLog\Submission" 
mkdir "$NewLogPath\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpReceive" 
mkdir "$NewLogPath\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpSend" 
mkdir "$NewLogPath\TransportRoles\Logs\Mailbox\PipelineTracing"



$exchangeservername = $env:computername 
# Move the standard log files for the TransportService to the same path on the L: drive that they were on C: 
Set-TransportService -Identity $exchangeservername `
    -ConnectivityLogPath            "$NewLogPath\TransportRoles\Logs\Hub\Connectivity" `
    -MessageTrackingLogPath         "$NewLogPath\TransportRoles\Logs\MessageTracking" `
    -IrmLogPath                     "$NewLogPath\Logging\IRMLogs" `
    -ActiveUserStatisticsLogPath    "$NewLogPath\TransportRoles\Logs\Hub\ActiveUsersStats" `
    -ServerStatisticsLogPath        "$NewLogPath\TransportRoles\Logs\Hub\ServerStats" `
    -ReceiveProtocolLogPath         "$NewLogPath\TransportRoles\Logs\Hub\ProtocolLog\SmtpReceive" `
    -RoutingTableLogPath            "$NewLogPath\TransportRoles\Logs\Hub\Routing" `
    -SendProtocolLogPath            "$NewLogPath\TransportRoles\Logs\Hub\ProtocolLog\SmtpSend" `
    -QueueLogPath                   "$NewLogPath\TransportRoles\Logs\Hub\QueueViewer" `
    -WlmLogPath                     "$NewLogPath\TransportRoles\Logs\Hub\WLM" `
    -PipelineTracingPath            "$NewLogPath\TransportRoles\Logs\Hub\PipelineTracing" `
    -AgentLogPath                   "$NewLogPath\TransportRoles\Logs\Hub\AgentLog"
    

# move the path for the PERFMON logs from the C: drive to the L: drive 
logman -stop ExchangeDiagnosticsDailyPerformanceLog 
logman -update ExchangeDiagnosticsDailyPerformanceLog -o    "$NewLogPath\Logging\Diagnostics\DailyPerformanceLogs\ExchangeDiagnosticsDailyPerformanceLog"
logman -start ExchangeDiagnosticsDailyPerformanceLog 
logman -stop ExchangeDiagnosticsPerformanceLog 
logman -update ExchangeDiagnosticsPerformanceLog -o         "$NewLogPath\Logging\Diagnostics\PerformanceLogsToBeProcessed\ExchangeDiagnosticsPerformanceLog"
logman -start ExchangeDiagnosticsPerformanceLog 

# Get the details on the EdgeSyncServiceConfig and store them in a variable for use in setting the path 
$EdgeSyncServiceConfigVAR=Get-EdgeSyncServiceConfig 

# Move the Log Path using the variable we got 
Set-EdgeSyncServiceConfig -Identity $EdgeSyncServiceConfigVAR.Identity -LogPath "$NewLogPath\TransportRoles\Logs\EdgeSync"

# Move the standard log files for the FrontEndTransportService to the same path on the L: drive that they were on C: 
Set-FrontendTransportService  -Identity $exchangeservername `
    -AgentLogPath           "$NewLogPath\TransportRoles\Logs\FrontEnd\AgentLog" `
    -ConnectivityLogPath    "$NewLogPath\TransportRoles\Logs\FrontEnd\Connectivity" `
    -ReceiveProtocolLogPath "$NewLogPath\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpReceive" `
    -SendProtocolLogPath    "$NewLogPath\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpSend"

# Move the log path for the IMAP server 
Set-ImapSettings -LogFileLocation "$NewLogPath\Logging\Imap4"

# Move the logs for the MailBoxServer 
Set-MailboxServer -Identity $exchangeservername `
    -CalendarRepairLogPath "$NewLogPath\Logging\Calendar Repair Assistant" `
    -MigrationLogFilePath  "$NewLogPath\Logging\Managed Folder Assistant"

# Move the standard log files for the MailboxTransportService to the same path on the L: drive that they were on C: 
Set-MailboxTransportService -Identity $exchangeservername `
    -ConnectivityLogPath            "$NewLogPath\TransportRoles\Logs\Mailbox\Connectivity" `
    -MailboxDeliveryAgentLogPath    "$NewLogPath\TransportRoles\Logs\Mailbox\AgentLog\Delivery" `
    -MailboxSubmissionAgentLogPath  "$NewLogPath\TransportRoles\Logs\Mailbox\AgentLog\Submission" `
    -ReceiveProtocolLogPath         "$NewLogPath\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpReceive" `
    -SendProtocolLogPath            "$NewLogPath\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpSend" `
    -PipelineTracingPath            "$NewLogPath\TransportRoles\Logs\Mailbox\PipelineTracing"

# Move the log path for the POP3 server 
Set-PopSettings -LogFileLocation "$NewLogPath\Logging\Pop3"

Restart-Service MSExchangeFrontEndTransport, MSExchangeImap4, MSExchangeTransport, MSExchangeTransportLogSearch, MSExchangePop3, MSExchangePOP3BE

Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\Connectivity" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\MessageTracking" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\IRMLogs" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\ActiveUsersStats" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\ServerStats" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\ProtocolLog\SmtpReceive" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\Routing" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\ProtocolLog\SmtpSend" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\QueueViewer" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\WLM" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\PipelineTracing" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\AgentLog" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\EdgeSync" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\AgentLog" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\Connectivity" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpReceive" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpSend" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Imap4" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Calendar Repair Assistant" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Managed Folder Assistant" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\Connectivity" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\AgentLog\Delivery" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\AgentLog\Submission" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpReceive" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpSend" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\PipelineTracing" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Pop3" -force -
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Diagnostics\DailyPerformanceLogs\" -force -rec 
Remove-Item -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Diagnostics\PerformanceLogsToBeProcessed\" -force -rec 