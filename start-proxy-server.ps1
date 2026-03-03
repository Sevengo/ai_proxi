# Start CLI Proxy API Plus server
# This script starts the proxy server in the background

$exePath = "C:\Users\s.semihod\bin\cliproxyapi-plus.exe"
$configPath = "C:\Users\s.semihod\.cli-proxy-api\config.yaml"

# Check if already running
$running = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue

if ($running) {
    Write-Host "CLI Proxy API Plus is already running (PID: $($running.Id))" -ForegroundColor Yellow
    Write-Host "Server is listening on http://localhost:8317" -ForegroundColor Cyan
} else {
    Write-Host "Starting CLI Proxy API Plus server..." -ForegroundColor Green
    
    Start-Process -FilePath $exePath -ArgumentList "--config", $configPath -WindowStyle Hidden
    Start-Sleep -Seconds 2
    
    $process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "Server started successfully (PID: $($process.Id))" -ForegroundColor Green
        Write-Host "Server is listening on http://localhost:8317" -ForegroundColor Cyan
    } else {
        Write-Host "Failed to start server" -ForegroundColor Red
        exit 1
    }
}

# Test connection
Write-Host "`nTesting connection..." -ForegroundColor Yellow
$testResult = Test-NetConnection -ComputerName localhost -Port 8317 -InformationLevel Quiet
if ($testResult) {
    Write-Host "✓ Server is responding on port 8317" -ForegroundColor Green
} else {
    Write-Host "✗ Server is not responding" -ForegroundColor Red
}
