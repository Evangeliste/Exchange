#########################################################################################################################
#
#		Script for : Move Exchange Transport Logs
#
#       Original script Authot
#		Script author : Alexis / Evangeliste
#		mail 	: alexis@inventiq.fr
#		Create 	: 10 Juin 2018
#		Version	: 1.0
#		UPDate 	:
#
#       Usage : .\Move-ExchangeLogs.ps1 -NewLogPath "YourNewPath"
#
#########################################################################################################################

[CmdletBinding(SupportsShouldProcess = $true)] 
param ( 
    [string]$NewLogPath
)

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

Restart-Service MSExchangeFrontEndTransport, MSExchangeImap4, MSExchangeTransport, MSExchangeTransportLogSearch, MSExchangePop3
