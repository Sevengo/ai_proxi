# Create Desktop Shortcuts for CLI Proxy API Plus (D:\tools\ai)
# Создание ярлыков на рабочем столе для управления прокси сервером
# Ярлыки запускают PowerShell 7+ с правами администратора

$desktopPath = [Environment]::GetFolderPath("Desktop")
$aiFolder = Join-Path $desktopPath "AI"
$toolsPath = "D:\tools\ai"

# Detect PowerShell executable (prefer pwsh.exe for PowerShell 7+)
$pwshPath = Get-Command pwsh.exe -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
if (-not $pwshPath) {
    # Fallback to Windows PowerShell if pwsh not found
    $pwshPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    Write-Host "⚠️  PowerShell 7+ не найден, используется Windows PowerShell" -ForegroundColor Yellow
} else {
    Write-Host "✓ Используется PowerShell 7+: $pwshPath" -ForegroundColor Green
}

# Create AI folder on desktop if not exists
if (!(Test-Path $aiFolder)) {
    New-Item -Path $aiFolder -ItemType Directory -Force | Out-Null
    Write-Host "✓ Created AI folder on Desktop" -ForegroundColor Green
}

# Function to create shortcut
function New-Shortcut {
    param(
        [string]$Name,
        [string]$TargetPath,
        [string]$Arguments = "",
        [string]$Description = "",
        [string]$IconLocation = ""
    )
    
    $shortcutPath = Join-Path $aiFolder "$Name.lnk"
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $TargetPath
    if ($Arguments) { $shortcut.Arguments = $Arguments }
    if ($Description) { $shortcut.Description = $Description }
    if ($IconLocation) { $shortcut.IconLocation = $IconLocation }
    $shortcut.WorkingDirectory = $toolsPath
    $shortcut.Save()
    
    # Set shortcut to run as administrator
    $bytes = [System.IO.File]::ReadAllBytes($shortcutPath)
    $bytes[0x15] = $bytes[0x15] -bor 0x20 # Set byte 21 (0x15) bit 6 (0x20) to enable "Run as administrator"
    [System.IO.File]::WriteAllBytes($shortcutPath, $bytes)
    
    Write-Host "✓ Created: $Name" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  Creating Desktop Shortcuts for AI Tools" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host ""

# Main management script
New-Shortcut `
    -Name "[01] Proxy - Управление" `
    -TargetPath $pwshPath `
    -Arguments "-NoExit -File `"$toolsPath\proxy.ps1`"" `
    -Description "Главное меню управления CLI Proxy API Plus"

# Server control shortcuts
New-Shortcut `
    -Name "[02] Запустить сервер" `
    -TargetPath $pwshPath `
    -Arguments "-File `"$toolsPath\start-proxy-server.ps1`"" `
    -Description "Запустить прокси сервер"

New-Shortcut `
    -Name "[03] Остановить сервер" `
    -TargetPath $pwshPath `
    -Arguments "-File `"$toolsPath\stop-proxy-server.ps1`"" `
    -Description "Остановить прокси сервер"

New-Shortcut `
    -Name "[04] Перезапуск сервера" `
    -TargetPath $pwshPath `
    -Arguments "-File `"$toolsPath\proxy.ps1`" -Restart" `
    -Description "Перезапустить прокси сервер"

# OAuth and status shortcuts
New-Shortcut `
    -Name "[05] Авторизация провайдеров" `
    -TargetPath $pwshPath `
    -Arguments "-NoExit -File `"$toolsPath\batch-oauth-login.ps1`"" `
    -Description "Авторизация AI провайдеров (Claude, Qwen, Codex и др.)"

New-Shortcut `
    -Name "[06] Статус и модели" `
    -TargetPath $pwshPath `
    -Arguments "-NoExit -File `"$toolsPath\proxy.ps1`" -Status" `
    -Description "Проверить статус сервера и список моделей"

# CLI setup shortcuts
New-Shortcut `
    -Name "[07] Настроить Claude CLI" `
    -TargetPath $pwshPath `
    -Arguments "-NoExit -File `"$toolsPath\claude-proxy-setup.ps1`"" `
    -Description "Настроить Claude CLI для работы через прокси"

New-Shortcut `
    -Name "[08] Настроить Copilot CLI" `
    -TargetPath $pwshPath `
    -Arguments "-NoExit -File `"$toolsPath\copilot-proxy-setup.ps1`"" `
    -Description "Настроить GitHub Copilot CLI для работы через прокси"

# Documentation shortcuts
New-Shortcut `
    -Name "[09] Документация" `
    -TargetPath "notepad.exe" `
    -Arguments "`"$toolsPath\README.md`"" `
    -Description "Полная документация по использованию"

New-Shortcut `
    -Name "[10] Шпаргалка команд" `
    -TargetPath "notepad.exe" `
    -Arguments "`"$toolsPath\CHEATSHEET.md`"" `
    -Description "Шпаргалка по командам"

Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ All shortcuts created successfully!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Location: $aiFolder" -ForegroundColor Cyan
Write-Host ""
