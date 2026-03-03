# ═══════════════════════════════════════════════════════════════════
# Создание ярлыков для быстрого запуска AI CLI с разными моделями
# ═══════════════════════════════════════════════════════════════════

$desktopPath = [Environment]::GetFolderPath("Desktop")
$aiFolder = Join-Path $desktopPath "AI"
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
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Создание ярлыков для AI CLI" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Создать папку AI CLI
$aiCliFolder = Join-Path $aiFolder "CLI"
New-Item -Path $aiCliFolder -ItemType Directory -Force | Out-Null

function New-AIShortcut {
    param(
        [string]$Name,
        [string]$Tool,
        [string]$Provider,
        [string]$Model,
        [string]$Description
    )
    
    # Проверяем существование скрипта launch-ai.ps1
    $launchScript = Join-Path $toolsPath "launch-ai.ps1"
    if (-not (Test-Path $launchScript)) {
        Write-Host "⚠️  Файл не найден: $launchScript" -ForegroundColor Red
        return
    }
    
    $shortcutPath = Join-Path $aiCliFolder "$Name.lnk"
    $arguments = "-NoExit -File `"$launchScript`" -Tool $Tool -Provider $Provider -Model $Model"
    
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $pwshPath
    $shortcut.Arguments = $arguments
    $shortcut.Description = $Description
    $shortcut.WorkingDirectory = $env:USERPROFILE
    $shortcut.Save()
    
    # Set as admin
    $bytes = [System.IO.File]::ReadAllBytes($shortcutPath)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($shortcutPath, $bytes)
    
    Write-Host "✓ $Name" -ForegroundColor Green
}

# Claude + Gemini (быстрая и дешевая)
New-AIShortcut `
    -Name "Claude + Gemini Flash" `
    -Tool "claude" `
    -Provider "gemini" `
    -Model "gemini-2.0-flash-exp" `
    -Description "Claude CLI с Google Gemini 2.0 Flash (быстрая)"

# Claude + Gemini Pro (умная)
New-AIShortcut `
    -Name "Claude + Gemini Pro" `
    -Tool "claude" `
    -Provider "gemini" `
    -Model "gemini-1.5-pro" `
    -Description "Claude CLI с Google Gemini 1.5 Pro (умная)"

# Claude + GPT-5 (новейшая от OpenAI)
New-AIShortcut `
    -Name "Claude + GPT-5" `
    -Tool "claude" `
    -Provider "copilot" `
    -Model "gpt-5.2" `
    -Description "Claude CLI с GPT-5.2 через GitHub Copilot"

# Claude + Claude Sonnet (родная модель)
New-AIShortcut `
    -Name "Claude + Claude Sonnet" `
    -Tool "claude" `
    -Provider "copilot" `
    -Model "claude-sonnet-4.5" `
    -Description "Claude CLI с Claude Sonnet 4.5 через Copilot"

# Copilot + GPT-5
New-AIShortcut `
    -Name "Copilot + GPT-5" `
    -Tool "copilot" `
    -Provider "copilot" `
    -Model "gpt-5.2" `
    -Description "GitHub Copilot CLI с GPT-5.2"

# Claude + Qwen (китайская модель)
New-AIShortcut `
    -Name "Claude + Qwen Max" `
    -Tool "claude" `
    -Provider "qwen" `
    -Model "qwen-max" `
    -Description "Claude CLI с Qwen Max (требует авторизации)"

# Универсальный лаунчер с меню
$launcherPath = Join-Path $aiCliFolder "AI Launcher (Menu).lnk"
$launchScript = Join-Path $toolsPath "launch-ai.ps1"

if (Test-Path $launchScript) {
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($launcherPath)
    $shortcut.TargetPath = $pwshPath
    $shortcut.Arguments = "-NoExit -File `"$launchScript`""
    $shortcut.Description = "Универсальный лаунчер AI CLI с интерактивным меню"
    $shortcut.WorkingDirectory = $env:USERPROFILE
    $shortcut.Save()
    $bytes = [System.IO.File]::ReadAllBytes($launcherPath)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($launcherPath, $bytes)
    Write-Host "✓ AI Launcher (Menu)" -ForegroundColor Cyan
} else {
    Write-Host "⚠️  Файл не найден: $launchScript" -ForegroundColor Red
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ Ярлыки созданы в $aiCliFolder" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
