# =========================================
# windows_security_check.ps1
# =========================================

$LogFile = "windows_security.csv"

function Write-Log {
    param ($Message)
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$time $Message" | Out-File -Append -FilePath $LogFile
}

Write-Log "Windows security check started"

try {
    # Failed login attempts (Event ID 4625 = failed logon)
    $FailedLogons = Get-WinEvent -FilterHashtable @{
        LogName = 'Security'
        Id = 4625
    } | Measure-Object | Select-Object -ExpandProperty Count

    Write-Log "Failed login attempts: $FailedLogons"
}
catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    exit 1
}

Write-Log "Windows security check completed successfully"
exit 0


