# Batch login script for CLI Proxy API Plus
# Authorizes multiple providers in sequence

$configPath = "C:\Users\s.semihod\.cli-proxy-api\config.yaml"
$exePath = "C:\Users\s.semihod\bin\cliproxyapi-plus.exe"

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  CLI Proxy API Plus - Batch OAuth Login" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Function to run login command
function Invoke-OAuthLogin {
    param(
        [string]$Provider,
        [string]$Flag
    )
    
    Write-Host "[$Provider] Starting authentication..." -ForegroundColor Yellow
    
    & $exePath --config $configPath $Flag
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[$Provider] ✓ Authentication successful!" -ForegroundColor Green
    } else {
        Write-Host "[$Provider] ✗ Authentication failed or skipped" -ForegroundColor Red
    }
    Write-Host ""
}

# Menu
Write-Host "Select providers to authenticate:" -ForegroundColor Cyan
Write-Host "[1] Google Gemini" -ForegroundColor White
Write-Host "[2] Claude (Anthropic)" -ForegroundColor White
Write-Host "[3] Codex (OpenAI)" -ForegroundColor White
Write-Host "[4] Qwen (Alibaba)" -ForegroundColor White
Write-Host "[5] Kiro (Google OAuth)" -ForegroundColor White
Write-Host "[6] Antigravity" -ForegroundColor White
Write-Host "[7] iFlow (OAuth)" -ForegroundColor White
Write-Host "[A] ALL providers" -ForegroundColor Green
Write-Host "[Q] Quit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Enter your choice"

switch ($choice.ToUpper()) {
    "1" { Invoke-OAuthLogin "Google Gemini" "--login" }
    "2" { Invoke-OAuthLogin "Claude" "--claude-login" }
    "3" { Invoke-OAuthLogin "Codex" "--codex-login" }
    "4" { Invoke-OAuthLogin "Qwen" "--qwen-login" }
    "5" { Invoke-OAuthLogin "Kiro" "--kiro-google-login" }
    "6" { Invoke-OAuthLogin "Antigravity" "--antigravity-login" }
    "7" { Invoke-OAuthLogin "iFlow" "--iflow-login" }
    "A" {
        Write-Host "Authenticating all providers..." -ForegroundColor Green
        Write-Host ""
        Invoke-OAuthLogin "Google Gemini" "--login"
        Invoke-OAuthLogin "Claude" "--claude-login"
        Invoke-OAuthLogin "Codex" "--codex-login"
        Invoke-OAuthLogin "Qwen" "--qwen-login"
        Invoke-OAuthLogin "Kiro" "--kiro-google-login"
        Invoke-OAuthLogin "Antigravity" "--antigravity-login"
        Invoke-OAuthLogin "iFlow" "--iflow-login"
    }
    "Q" {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit 0
    }
    default {
        Write-Host "Invalid choice!" -ForegroundColor Red
    }
}

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "Authenticated providers:" -ForegroundColor Cyan
Write-Host ""
Get-ChildItem "C:\Users\s.semihod\.cli-proxy-api" -Filter "*.json" | 
    Select-Object Name, @{Name="Size";Expression={"{0:N2} KB" -f ($_.Length/1KB)}}, LastWriteTime | 
    Format-Table -AutoSize
Write-Host "===============================================" -ForegroundColor Cyan
