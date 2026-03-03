# Claude CLI integration with CLI Proxy API Plus
# This script configures Claude CLI to use the local proxy

$proxyUrl = "http://localhost:8317/v1"
$apiKey = "sk-dummy"

Write-Host "Configuring Claude CLI to use CLI Proxy API Plus..." -ForegroundColor Green
Write-Host "Proxy URL: $proxyUrl" -ForegroundColor Cyan
Write-Host "API Key: $apiKey" -ForegroundColor Cyan

# Set environment variables for Claude CLI
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_URL", $proxyUrl, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $apiKey, "User")

# For current session
$env:ANTHROPIC_API_URL = $proxyUrl
$env:ANTHROPIC_API_KEY = $apiKey

Write-Host "`nClaude CLI configured successfully!" -ForegroundColor Green
Write-Host "Environment variables set:" -ForegroundColor Yellow
Write-Host "  ANTHROPIC_API_URL = $proxyUrl"
Write-Host "  ANTHROPIC_API_KEY = $apiKey"
Write-Host "`nNote: Restart your terminal for changes to take effect globally." -ForegroundColor Yellow
Write-Host "For immediate use in this session, variables are already set." -ForegroundColor Green
