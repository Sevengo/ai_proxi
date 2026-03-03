# ═══════════════════════════════════════════════════════════════════
# Claude CLI - Интерактивный режим через прокси
# ═══════════════════════════════════════════════════════════════════

param(
    [string]$Model = "gemini-2.0-flash-exp",
    [string]$Provider = "gemini",
    [switch]$AutoStart
)

# ═══════════════════════════════════════════════════════════════════
# Проверка и запуск прокси
# ═══════════════════════════════════════════════════════════════════

function Test-ProxyRunning {
    $process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    return $null -ne $process
}

if (-not (Test-ProxyRunning)) {
    Write-Host ""
    Write-Host "⚠️  Прокси сервер не запущен" -ForegroundColor Yellow
    
    if ($AutoStart) {
        Write-Host "   Запускаю прокси..." -ForegroundColor Yellow
        $exePath = "$env:USERPROFILE\bin\cliproxyapi-plus.exe"
        $configPath = "$env:USERPROFILE\.cli-proxy-api\config.yaml"
        Start-Process -FilePath $exePath -ArgumentList "--config", $configPath -WindowStyle Hidden
        Start-Sleep -Seconds 3
        
        if (Test-ProxyRunning) {
            Write-Host "   ✓ Прокси запущен" -ForegroundColor Green
        }
    } else {
        $scriptPath = $PSScriptRoot
        if (-not $scriptPath) {
            $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
        }
        Write-Host "   Запустите: $scriptPath\start-proxy-server.ps1" -ForegroundColor Cyan
        Write-Host "   Или добавьте флаг: -AutoStart" -ForegroundColor Gray
        Write-Host ""
        exit 1
    }
}

# ═══════════════════════════════════════════════════════════════════
# Настройка окружения
# ═══════════════════════════════════════════════════════════════════

$env:ANTHROPIC_API_URL = "http://localhost:8317/v1"
$env:ANTHROPIC_API_KEY = "sk-dummy"
$env:ANTHROPIC_MODEL = $Model

# ═══════════════════════════════════════════════════════════════════
# Проверка установки Claude
# ═══════════════════════════════════════════════════════════════════

try {
    claude --version 2>&1 | Out-Null
} catch {
    Write-Host ""
    Write-Host "✗ Claude CLI не установлен!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Установите:" -ForegroundColor Yellow
    Write-Host "  npm install -g @anthropic-ai/claude-cli" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# ═══════════════════════════════════════════════════════════════════
# Заголовок
# ═══════════════════════════════════════════════════════════════════

Clear-Host
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           Claude CLI - Интерактивный режим                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "✓ Прокси:     http://localhost:8317" -ForegroundColor Green
Write-Host "✓ Провайдер:  $Provider" -ForegroundColor Green
Write-Host "✓ Модель:     $Model" -ForegroundColor Green
Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Используйте Ctrl+C или Ctrl+D для выхода" -ForegroundColor Gray
Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

# ═══════════════════════════════════════════════════════════════════
# Запуск Claude CLI
# ═══════════════════════════════════════════════════════════════════

claude
