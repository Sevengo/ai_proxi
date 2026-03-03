# ═══════════════════════════════════════════════════════════════════
# Обновление ярлыков - Интерактивные режимы
# ═══════════════════════════════════════════════════════════════════

$desktopPath = [Environment]::GetFolderPath("Desktop")
$aiFolder = Join-Path $desktopPath "AI"
$aiCliFolder = Join-Path $aiFolder "CLI"
# Определяем путь к скриптам автоматически из текущей директории
$toolsPath = $PSScriptRoot
if (-not $toolsPath) {
    $toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Path
}

# Detect PowerShell
$pwshPath = Get-Command pwsh.exe -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
if (-not $pwshPath) {
    $pwshPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Обновление ярлыков с интерактивными режимами" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Удалить старые ярлыки
if (Test-Path $aiCliFolder) {
    Remove-Item "$aiCliFolder\*.lnk" -Force
    Write-Host "✓ Старые ярлыки удалены" -ForegroundColor Yellow
}

New-Item -Path $aiCliFolder -ItemType Directory -Force | Out-Null

function New-AIShortcut {
    param(
        [string]$Name,
        [string]$Script,
        [string]$Arguments = "",
        [string]$Description
    )
    
    # Проверяем существование скрипта
    $scriptPath = Join-Path $toolsPath $Script
    if (-not (Test-Path $scriptPath)) {
        Write-Host "⚠️  Пропуск '$Name' - файл не найден: $scriptPath" -ForegroundColor Yellow
        return
    }
    
    $shortcutPath = Join-Path $aiCliFolder "$Name.lnk"
    $fullArgs = "-NoExit -File `"$scriptPath`" $Arguments"
    
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $pwshPath
    $shortcut.Arguments = $fullArgs
    $shortcut.Description = $Description
    $shortcut.WorkingDirectory = $env:USERPROFILE
    $shortcut.Save()
    
    # Set as admin
    $bytes = [System.IO.File]::ReadAllBytes($shortcutPath)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($shortcutPath, $bytes)
    
    Write-Host "✓ $Name" -ForegroundColor Green
}

Write-Host ""
Write-Host "Создание ярлыков Claude CLI:" -ForegroundColor Yellow

# Claude с разными моделями (интерактивный режим)
New-AIShortcut `
    -Name "[1] Claude - Gemini Flash" `
    -Script "claude-interactive.ps1" `
    -Arguments "-Model gemini-2.0-flash-exp -Provider gemini -AutoStart" `
    -Description "Claude CLI с Gemini Flash (быстрая и бесплатная)"

New-AIShortcut `
    -Name "[2] Claude - Gemini Pro" `
    -Script "claude-interactive.ps1" `
    -Arguments "-Model gemini-1.5-pro -Provider gemini -AutoStart" `
    -Description "Claude CLI с Gemini Pro (умная, большой контекст)"

New-AIShortcut `
    -Name "[3] Claude - GPT-5" `
    -Script "claude-interactive.ps1" `
    -Arguments "-Model gpt-5.2 -Provider copilot -AutoStart" `
    -Description "Claude CLI с GPT-5.2 (новейшая модель)"

New-AIShortcut `
    -Name "[4] Claude - Claude Sonnet" `
    -Script "claude-interactive.ps1" `
    -Arguments "-Model claude-sonnet-4.5 -Provider copilot -AutoStart" `
    -Description "Claude CLI с Claude Sonnet 4.5 (отлично для кода)"

New-AIShortcut `
    -Name "[5] Claude - GPT-5 Codex" `
    -Script "claude-interactive.ps1" `
    -Arguments "-Model gpt-5.2-codex -Provider copilot -AutoStart" `
    -Description "Claude CLI с GPT-5.2 Codex (специализация на коде)"

Write-Host ""
Write-Host "Создание ярлыков Copilot CLI:" -ForegroundColor Yellow

# Copilot интерактивный режим
New-AIShortcut `
    -Name "[6] Copilot - Interactive" `
    -Script "copilot-interactive.ps1" `
    -Arguments "-AutoStart" `
    -Description "GitHub Copilot CLI интерактивный режим"

Write-Host ""
Write-Host "Создание универсального лаунчера:" -ForegroundColor Yellow

# Универсальный лаунчер с меню
New-AIShortcut `
    -Name "[0] AI Launcher Menu" `
    -Script "launch-ai.ps1" `
    -Arguments "" `
    -Description "Универсальный лаунчер с выбором CLI, провайдера и модели"

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ Ярлыки обновлены!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Расположение: $aiCliFolder" -ForegroundColor Cyan
Write-Host "📂 Путь скриптов: $toolsPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Рекомендация для начала:" -ForegroundColor Yellow
Write-Host "   Запустите: [1] Claude - Gemini Flash" -ForegroundColor Cyan
Write-Host "   Или:       [6] Copilot - Interactive" -ForegroundColor Cyan
Write-Host ""
