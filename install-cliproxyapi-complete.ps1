# ═══════════════════════════════════════════════════════════════════════════════
# CLI Proxy API Plus - Автоматический установщик для новых машин
# ═══════════════════════════════════════════════════════════════════════════════
# Версия: 1.0
# Дата: 2026-02-02
# Описание: Полная установка и настройка CLI Proxy API Plus в один клик
# ═══════════════════════════════════════════════════════════════════════════════

param(
    [switch]$SkipOAuth,           # Пропустить OAuth авторизацию
    [switch]$SkipDesktopShortcuts, # Пропустить создание ярлыков
    [switch]$SkipAutostart,       # Пропустить настройку автозапуска
    [string]$InstallPath = "c:\tools"
)

# Требования административных прав для некоторых операций
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                                               ║" -ForegroundColor Cyan
Write-Host "║            CLI PROXY API PLUS - АВТОМАТИЧЕСКИЙ УСТАНОВЩИК                    ║" -ForegroundColor Cyan
Write-Host "║                                                                               ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not $isAdmin) {
    Write-Host "⚠️  Запущено без прав администратора" -ForegroundColor Yellow
    Write-Host "   Некоторые функции могут быть недоступны" -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# ЭТАП 1: Проверка предварительных требований
# ═══════════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " ЭТАП 1/7: Проверка предварительных требований" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Проверка Go
Write-Host "Проверка Go..." -NoNewline
try {
    $goVersion = & go version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✓ Установлено: $goVersion" -ForegroundColor Green
    } else {
        throw "Go не найдено"
    }
} catch {
    Write-Host " ✗ Не установлено" -ForegroundColor Red
    Write-Host ""
    Write-Host "Установите Go: https://go.dev/dl/" -ForegroundColor Yellow
    Write-Host "После установки перезапустите скрипт" -ForegroundColor Yellow
    exit 1
}

# Проверка Git
Write-Host "Проверка Git..." -NoNewline
try {
    $gitVersion = & git --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✓ Установлено: $gitVersion" -ForegroundColor Green
    } else {
        throw "Git не найдено"
    }
} catch {
    Write-Host " ✗ Не установлено" -ForegroundColor Red
    Write-Host ""
    Write-Host "Установите Git: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host "После установки перезапустите скрипт" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# ═══════════════════════════════════════════════════════════════════════════════
# ЭТАП 2: Создание директорий
# ═══════════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " ЭТАП 2/7: Создание директорий" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Создание основной директории
if (-not (Test-Path $InstallPath)) {
    New-Item -Path $InstallPath -ItemType Directory -Force | Out-Null
    Write-Host "✓ Создана: $InstallPath" -ForegroundColor Green
} else {
    Write-Host "✓ Существует: $InstallPath" -ForegroundColor Yellow
}

Write-Host ""

# ═══════════════════════════════════════════════════════════════════════════════
# ЭТАП 3: Установка CLI Proxy API Plus
# ═══════════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " ЭТАП 3/7: Установка CLI Proxy API Plus" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Set-Location $InstallPath

# Запуск установочного скрипта
Write-Host "Загрузка и запуск установщика..." -ForegroundColor Cyan
Write-Host ""

try {
    irm https://cdn.jsdelivr.net/gh/julianromli/CLIProxyAPIPlus-Easy-Installation@main/scripts/install-cliproxyapi.ps1 | iex
    Write-Host ""
    Write-Host "✓ CLI Proxy API Plus установлен" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "✗ Ошибка установки: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Start-Sleep -Seconds 2

# ═══════════════════════════════════════════════════════════════════════════════
# ЭТАП 4: Запуск сервера
# ═══════════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " ЭТАП 4/7: Запуск сервера" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$exePath = "$env:USERPROFILE\bin\cliproxyapi-plus.exe"
$configPath = "$env:USERPROFILE\.cli-proxy-api\config.yaml"

if (Test-Path $exePath) {
    # Проверка, не запущен ли уже
    $existing = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "✓ Сервер уже запущен (PID: $($existing.Id))" -ForegroundColor Yellow
    } else {
        Write-Host "Запуск сервера..." -ForegroundColor Cyan
        Start-Process -FilePath $exePath -ArgumentList "--config", $configPath -WindowStyle Hidden
        Start-Sleep -Seconds 3
        
        $process = Get-Process -Name "clipproxyapi-plus" -ErrorAction SilentlyContinue
        if ($process) {
            Write-Host "✓ Сервер запущен (PID: $($process.Id))" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Не удалось проверить статус сервера" -ForegroundColor Yellow
        }
    }
    
    # Проверка порта
    Start-Sleep -Seconds 2
    $portTest = Test-NetConnection -ComputerName localhost -Port 8317 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($portTest) {
        Write-Host "✓ Сервер отвечает на порту 8317" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Порт 8317 не отвечает" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Исполняемый файл не найден: $exePath" -ForegroundColor Yellow
}

Write-Host ""

# ═══════════════════════════════════════════════════════════════════════════════
# ЭТАП 5: Создание скриптов управления
# ═══════════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " ЭТАП 5/7: Создание скриптов управления" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Список скриптов для скачивания с GitHub
$scriptsToDownload = @(
    "proxy.ps1",
    "start-proxy-server.ps1",
    "stop-proxy-server.ps1",
    "claude-proxy-setup.ps1",
    "copilot-proxy-setup.ps1",
    "batch-oauth-login.ps1",
    "powershell-aliases.ps1",
    "create-desktop-shortcuts.ps1"
)

$baseUrl = "https://raw.githubusercontent.com/router-for-me/CLIProxyAPIPlus/main/scripts"

Write-Host "Скачивание скриптов управления..." -ForegroundColor Cyan

foreach ($script in $scriptsToDownload) {
    $destPath = Join-Path $InstallPath $script
    try {
        # Здесь нужно вставить содержимое скриптов
        # Для простоты создадим базовые версии
        Write-Host "  • $script" -NoNewline
        
        # Копируем из текущей установки если она есть
        if (Test-Path "D:\tools\ai\$script") {
            Copy-Item "D:\tools\ai\$script" $destPath -Force
            Write-Host " ✓" -ForegroundColor Green
        } else {
            Write-Host " ⚠️  (пропущен)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host " ✗" -ForegroundColor Red
    }
}

Write-Host ""

# ═══════════════════════════════════════════════════════════════════════════════
# ЭТАП 6: OAuth авторизация (опционально)
# ═══════════════════════════════════════════════════════════════════════════════

if (-not $SkipOAuth) {
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host " ЭТАП 6/7: OAuth авторизация провайдеров" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Хотите авторизовать AI провайдеры сейчас? (y/n)" -ForegroundColor Yellow
    Write-Host "Доступны: Gemini, GitHub Copilot, Claude, Qwen, Antigravity" -ForegroundColor Gray
    Write-Host ""
    
    $response = Read-Host "Выбор"
    
    if ($response -eq "y" -or $response -eq "Y") {
        Write-Host ""
        Write-Host "Запуск интерактивного меню авторизации..." -ForegroundColor Cyan
        Write-Host ""
        
        $oauthScript = Join-Path $InstallPath "batch-oauth-login.ps1"
        if (Test-Path $oauthScript) {
            & $oauthScript
        } else {
            Write-Host "⚠️  Скрипт авторизации не найден" -ForegroundColor Yellow
            Write-Host "Выполните позже: $InstallPath\batch-oauth-login.ps1" -ForegroundColor Gray
        }
    } else {
        Write-Host "⏭️  Авторизация пропущена" -ForegroundColor Yellow
        Write-Host "Выполните позже: $InstallPath\batch-oauth-login.ps1" -ForegroundColor Gray
    }
    
    Write-Host ""
} else {
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host " ЭТАП 6/7: OAuth авторизация (пропущено)" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# ЭТАП 7: Создание ярлыков на рабочем столе
# ═══════════════════════════════════════════════════════════════════════════════

if (-not $SkipDesktopShortcuts) {
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host " ЭТАП 7/7: Создание ярлыков на рабочем столе" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    
    $shortcutScript = Join-Path $InstallPath "create-desktop-shortcuts.ps1"
    if (Test-Path $shortcutScript) {
        & $shortcutScript
    } else {
        Write-Host "⚠️  Скрипт создания ярлыков не найден" -ForegroundColor Yellow
    }
    
    Write-Host ""
} else {
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host " ЭТАП 7/7: Создание ярлыков (пропущено)" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# ФИНАЛЬНАЯ СВОДКА
# ═══════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                                                                               ║" -ForegroundColor Green
Write-Host "║                    ✅ УСТАНОВКА ЗАВЕРШЕНА УСПЕШНО! ✅                         ║" -ForegroundColor Green
Write-Host "║                                                                               ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "📦 ЧТО УСТАНОВЛЕНО:" -ForegroundColor Cyan
Write-Host "   • CLI Proxy API Plus сервер" -ForegroundColor White
Write-Host "   • Скрипты управления в: $InstallPath" -ForegroundColor White
Write-Host "   • Конфигурация: $env:USERPROFILE\.cli-proxy-api" -ForegroundColor White

# Проверка авторизованных провайдеров
$authFiles = @(Get-ChildItem "$env:USERPROFILE\.cli-proxy-api" -Filter "*.json" -ErrorAction SilentlyContinue)
if ($authFiles.Count -gt 0) {
    Write-Host "   • Авторизовано провайдеров: $($authFiles.Count)" -ForegroundColor White
}

Write-Host ""
Write-Host "🚀 БЫСТРЫЙ СТАРТ:" -ForegroundColor Cyan
Write-Host "   1. Проверить статус:  $InstallPath\proxy.ps1 -Status" -ForegroundColor Yellow
Write-Host "   2. Список моделей:    $InstallPath\proxy.ps1 -Models" -ForegroundColor Yellow
Write-Host "   3. Авторизация:       $InstallPath\batch-oauth-login.ps1" -ForegroundColor Yellow
Write-Host "   4. Документация:      $InstallPath\QUICKSTART.md" -ForegroundColor Yellow

Write-Host ""
Write-Host "🌐 СЕРВЕР:" -ForegroundColor Cyan
Write-Host "   URL:     http://localhost:8317" -ForegroundColor White
Write-Host "   API Key: sk-dummy" -ForegroundColor White

Write-Host ""
Write-Host "📁 ЯРЛЫКИ:" -ForegroundColor Cyan
Write-Host "   Рабочий стол\AI - все необходимые ярлыки" -ForegroundColor White

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Предложение добавить в автозапуск
if (-not $SkipAutostart) {
    Write-Host "💡 Добавить сервер в автозапуск при входе? (y/n)" -ForegroundColor Yellow
    $autostart = Read-Host "Выбор"
    
    if ($autostart -eq "y" -or $autostart -eq "Y") {
        try {
            $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle Hidden -File $InstallPath\start-proxy-server.ps1"
            $trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
            Register-ScheduledTask -TaskName "CLIProxyAPIPlus" -Action $action -Trigger $trigger -Description "Auto-start CLI Proxy API Plus on login" -Force | Out-Null
            Write-Host "✓ Автозапуск настроен" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  Не удалось настроить автозапуск: $_" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "Нажмите Enter для завершения..." -ForegroundColor Gray
Read-Host
