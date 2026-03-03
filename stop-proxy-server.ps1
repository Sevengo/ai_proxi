# Stop CLI Proxy API Plus server

$process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue

if ($process) {
    Write-Host "Stopping CLI Proxy API Plus (PID: $($process.Id))..." -ForegroundColor Yellow
    Stop-Process -Id $process.Id -Force
    Start-Sleep -Seconds 1
    
    $stillRunning = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    if (-not $stillRunning) {
        Write-Host "Server stopped successfully" -ForegroundColor Green
    } else {
        Write-Host "Failed to stop server" -ForegroundColor Red
    }
} else {
    Write-Host "CLI Proxy API Plus is not running" -ForegroundColor Yellow
}
