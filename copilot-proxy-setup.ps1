# GitHub Copilot CLI integration with CLI Proxy API Plus
# This script configures Copilot CLI to use the local proxy

$proxyUrl = "http://localhost:8317"
$apiKey = "sk-dummy"

Write-Host "Configuring GitHub Copilot CLI to use CLI Proxy API Plus..." -ForegroundColor Green
Write-Host "Proxy URL: $proxyUrl" -ForegroundColor Cyan

# Set environment variables for GitHub Copilot CLI
[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_API_BASE_URL", $proxyUrl, "User")
[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_TOKEN", $apiKey, "User")

# For current session
$env:GITHUB_COPILOT_API_BASE_URL = $proxyUrl
$env:GITHUB_COPILOT_TOKEN = $apiKey

Write-Host "`nGitHub Copilot CLI configured successfully!" -ForegroundColor Green
Write-Host "Environment variables set:" -ForegroundColor Yellow
Write-Host "  GITHUB_COPILOT_API_BASE_URL = $proxyUrl"
Write-Host "  GITHUB_COPILOT_TOKEN = $apiKey"
Write-Host "`nNote: Restart your terminal for changes to take effect globally." -ForegroundColor Yellow
Write-Host "For immediate use in this session, variables are already set." -ForegroundColor Green
