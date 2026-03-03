# ═══════════════════════════════════════════════════════════════════
#  CLI Proxy API Plus - Universal Installation Script
#  Универсальный скрипт установки для новых машин
# ═══════════════════════════════════════════════════════════════════
# 
# Этот скрипт:
# 1. Проверяет и устанавливает необходимые зависимости (Git, Go)
# 2. Клонирует репозиторий CLIProxyAPIPlus
# 3. Компилирует бинарный файл
# 4. Создает структуру папок
# 5. Копирует скрипты управления
# 6. Создает ярлыки на рабочем столе
# 7. Запускает сервер и выполняет первоначальную настройку
#
# ═══════════════════════════════════════════════════════════════════

#Requires -RunAsAdministrator

param(
    [string]$TargetDrive = "D",
    [string]$ToolsPath = "$TargetDrive`:\tools\ai",
    [string]$BinPath = "$env:USERPROFILE\bin",
    [string]$ConfigPath = "$env:USERPROFILE\.cli-proxy-api",
    [switch]$SkipDependencies,
    [switch]$SkipCompile
)

$ErrorActionPreference = "Stop"

# ═══════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════

function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Text)
    Write-Host "▶ $Text" -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Text)
    Write-Host "  ✓ $Text" -ForegroundColor Green
}

function Write-Error {
    param([string]$Text)
    Write-Host "  ✗ $Text" -ForegroundColor Red
}

function Test-CommandExists {
    param([string]$Command)
    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# ═══════════════════════════════════════════════════════════════════
# Step 1: Check Dependencies
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 1: Проверка зависимостей"

if (-not $SkipDependencies) {
    # Check Git
    Write-Step "Проверка Git..."
    if (Test-CommandExists "git") {
        $gitVersion = git --version
        Write-Success "Git установлен: $gitVersion"
    } else {
        Write-Error "Git не установлен!"
        Write-Host "  Установите Git: https://git-scm.com/download/win" -ForegroundColor Yellow
        Write-Host "  Или используйте: winget install --id Git.Git -e --source winget" -ForegroundColor Yellow
        exit 1
    }

    # Check Go
    Write-Step "Проверка Go..."
    if (Test-CommandExists "go") {
        $goVersion = go version
        Write-Success "Go установлен: $goVersion"
    } else {
        Write-Error "Go не установлен!"
        Write-Host "  Установите Go: https://go.dev/dl/" -ForegroundColor Yellow
        Write-Host "  Или используйте: winget install --id GoLang.Go" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "  Пропущено (флаг -SkipDependencies)" -ForegroundColor Gray
}

# ═══════════════════════════════════════════════════════════════════
# Step 2: Create Directory Structure
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 2: Создание структуры папок"

Write-Step "Создание $ToolsPath..."
New-Item -Path $ToolsPath -ItemType Directory -Force | Out-Null
Write-Success "Папка создана: $ToolsPath"

Write-Step "Создание $BinPath..."
New-Item -Path $BinPath -ItemType Directory -Force | Out-Null
Write-Success "Папка создана: $BinPath"

Write-Step "Создание $ConfigPath..."
New-Item -Path $ConfigPath -ItemType Directory -Force | Out-Null
Write-Success "Папка создана: $ConfigPath"

# ═══════════════════════════════════════════════════════════════════
# Step 3: Clone Repository
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 3: Клонирование репозитория"

$repoPath = "$env:USERPROFILE\CLIProxyAPIPlus"

if (Test-Path $repoPath) {
    Write-Step "Репозиторий уже существует, обновление..."
    Push-Location $repoPath
    git pull
    Pop-Location
    Write-Success "Репозиторий обновлен"
} else {
    Write-Step "Клонирование репозитория..."
    git clone https://github.com/router-for-me/CLIProxyAPIPlus.git $repoPath
    Write-Success "Репозиторий склонирован в: $repoPath"
}

# ═══════════════════════════════════════════════════════════════════
# Step 4: Compile Binary
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 4: Компиляция бинарного файла"

if (-not $SkipCompile) {
    Write-Step "Компиляция cliproxyapi-plus.exe..."
    $exePath = "$BinPath\cliproxyapi-plus.exe"
    
    Push-Location $repoPath
    go build -o $exePath ./cmd/server
    Pop-Location
    
    if (Test-Path $exePath) {
        Write-Success "Бинарный файл создан: $exePath"
        $fileSize = (Get-Item $exePath).Length / 1MB
        Write-Success "Размер: $([math]::Round($fileSize, 2)) MB"
    } else {
        Write-Error "Ошибка компиляции!"
        exit 1
    }
} else {
    Write-Host "  Пропущено (флаг -SkipCompile)" -ForegroundColor Gray
}

# ═══════════════════════════════════════════════════════════════════
# Step 5: Add to PATH
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 5: Добавление в PATH"

$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$BinPath*") {
    Write-Step "Добавление $BinPath в PATH..."
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$BinPath", "User")
    $env:Path += ";$BinPath"
    Write-Success "PATH обновлен"
} else {
    Write-Success "PATH уже содержит $BinPath"
}

# ═══════════════════════════════════════════════════════════════════
# Step 6: Create Configuration
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 6: Создание конфигурации"

$configFile = "$ConfigPath\config.yaml"

if (-not (Test-Path $configFile)) {
    Write-Step "Создание config.yaml..."
    
    $config = @"
# CLI Proxy API Plus Configuration
port: 8317
api-keys:
  - sk-dummy
incognito-browser: true
request-retry: 3
log-level: info
"@
    
    $config | Out-File -FilePath $configFile -Encoding utf8
    Write-Success "Конфигурация создана: $configFile"
} else {
    Write-Success "Конфигурация уже существует: $configFile"
}

# ═══════════════════════════════════════════════════════════════════
# Step 7: Copy Management Scripts
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 7: Копирование скриптов управления"

$scriptFiles = @{
    "start-proxy-server.ps1" = @"
# Start CLI Proxy API Plus server
`$exePath = "$BinPath\cliproxyapi-plus.exe"
`$configPath = "$ConfigPath\config.yaml"

`$running = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue

if (`$running) {
    Write-Host "CLI Proxy API Plus уже запущен (PID: `$(`$running.Id))" -ForegroundColor Yellow
    Write-Host "Сервер: http://localhost:8317" -ForegroundColor Cyan
} else {
    Write-Host "Запуск CLI Proxy API Plus..." -ForegroundColor Green
    Start-Process -FilePath `$exePath -ArgumentList "--config", `$configPath -WindowStyle Hidden
    Start-Sleep -Seconds 2
    
    `$process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    if (`$process) {
        Write-Host "✓ Сервер запущен (PID: `$(`$process.Id))" -ForegroundColor Green
        Write-Host "✓ URL: http://localhost:8317" -ForegroundColor Cyan
    } else {
        Write-Host "✗ Ошибка запуска" -ForegroundColor Red
        exit 1
    }
}

`$testResult = Test-NetConnection -ComputerName localhost -Port 8317 -InformationLevel Quiet
if (`$testResult) {
    Write-Host "✓ Сервер отвечает на порту 8317" -ForegroundColor Green
} else {
    Write-Host "✗ Сервер не отвечает" -ForegroundColor Red
}
"@
    
    "stop-proxy-server.ps1" = @"
# Stop CLI Proxy API Plus server
`$process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue

if (`$process) {
    Write-Host "Остановка CLI Proxy API Plus (PID: `$(`$process.Id))..." -ForegroundColor Yellow
    Stop-Process -Id `$process.Id -Force
    Start-Sleep -Seconds 1
    
    `$check = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    if (-not `$check) {
        Write-Host "✓ Сервер остановлен" -ForegroundColor Green
    } else {
        Write-Host "✗ Ошибка остановки" -ForegroundColor Red
    }
} else {
    Write-Host "Сервер не запущен" -ForegroundColor Gray
}
"@
    
    "claude-proxy-setup.ps1" = @"
# Setup Claude CLI to use proxy
Write-Host "Настройка Claude CLI для работы через прокси..." -ForegroundColor Green

[Environment]::SetEnvironmentVariable("ANTHROPIC_API_URL", "http://localhost:8317/v1", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-dummy", "User")

`$env:ANTHROPIC_API_URL = "http://localhost:8317/v1"
`$env:ANTHROPIC_API_KEY = "sk-dummy"

Write-Host "✓ ANTHROPIC_API_URL = http://localhost:8317/v1" -ForegroundColor Cyan
Write-Host "✓ ANTHROPIC_API_KEY = sk-dummy" -ForegroundColor Cyan
Write-Host ""
Write-Host "Теперь можете использовать Claude CLI!" -ForegroundColor Green
"@
    
    "copilot-proxy-setup.ps1" = @"
# Setup GitHub Copilot CLI to use proxy
Write-Host "Настройка GitHub Copilot CLI для работы через прокси..." -ForegroundColor Green

[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_API_BASE_URL", "http://localhost:8317", "User")
[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_TOKEN", "sk-dummy", "User")

`$env:GITHUB_COPILOT_API_BASE_URL = "http://localhost:8317"
`$env:GITHUB_COPILOT_TOKEN = "sk-dummy"

Write-Host "✓ GITHUB_COPILOT_API_BASE_URL = http://localhost:8317" -ForegroundColor Cyan
Write-Host "✓ GITHUB_COPILOT_TOKEN = sk-dummy" -ForegroundColor Cyan
Write-Host ""
Write-Host "Теперь можете использовать GitHub Copilot CLI!" -ForegroundColor Green
"@
}

foreach ($script in $scriptFiles.GetEnumerator()) {
    $scriptPath = "$ToolsPath\$($script.Key)"
    Write-Step "Создание $($script.Key)..."
    $script.Value | Out-File -FilePath $scriptPath -Encoding utf8
    Write-Success "Создан: $scriptPath"
}

# ═══════════════════════════════════════════════════════════════════
# Step 8: Create Desktop Shortcuts
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 8: Создание ярлыков на рабочем столе"

$desktopPath = [Environment]::GetFolderPath("Desktop")
$aiFolder = Join-Path $desktopPath "AI"

New-Item -Path $aiFolder -ItemType Directory -Force | Out-Null
Write-Success "Папка AI создана на рабочем столе"

# Detect PowerShell executable (prefer pwsh.exe for PowerShell 7+)
$pwshPath = Get-Command pwsh.exe -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
if (-not $pwshPath) {
    $pwshPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    Write-Host "  ⚠️  PowerShell 7+ не найден, используется Windows PowerShell" -ForegroundColor Yellow
} else {
    Write-Success "Используется PowerShell 7+: $pwshPath"
}

function New-Shortcut {
    param(
        [string]$Name,
        [string]$TargetPath,
        [string]$Arguments = "",
        [string]$Description = ""
    )
    
    $shortcutPath = Join-Path $aiFolder "$Name.lnk"
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $TargetPath
    if ($Arguments) { $shortcut.Arguments = $Arguments }
    if ($Description) { $shortcut.Description = $Description }
    $shortcut.WorkingDirectory = $ToolsPath
    $shortcut.Save()
    
    # Set shortcut to run as administrator
    $bytes = [System.IO.File]::ReadAllBytes($shortcutPath)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($shortcutPath, $bytes)
}

$shortcuts = @(
    @{Name="[01] Запустить сервер"; Target=$pwshPath; Args="-File `"$ToolsPath\start-proxy-server.ps1`""; Desc="Запустить прокси сервер"},
    @{Name="[02] Остановить сервер"; Target=$pwshPath; Args="-File `"$ToolsPath\stop-proxy-server.ps1`""; Desc="Остановить прокси сервер"},
    @{Name="[03] Настроить Claude CLI"; Target=$pwshPath; Args="-NoExit -File `"$ToolsPath\claude-proxy-setup.ps1`""; Desc="Настроить Claude CLI"},
    @{Name="[04] Настроить Copilot CLI"; Target=$pwshPath; Args="-NoExit -File `"$ToolsPath\copilot-proxy-setup.ps1`""; Desc="Настроить Copilot CLI"}
)

foreach ($shortcut in $shortcuts) {
    Write-Step "Создание: $($shortcut.Name)..."
    New-Shortcut -Name $shortcut.Name -TargetPath $shortcut.Target -Arguments $shortcut.Args -Description $shortcut.Desc
    Write-Success "Ярлык создан"
}

# ═══════════════════════════════════════════════════════════════════
# Step 9: Start Server
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 9: Запуск сервера"

$response = Read-Host "Запустить сервер сейчас? (Y/n)"
if ($response -eq "" -or $response -eq "Y" -or $response -eq "y") {
    & "$ToolsPath\start-proxy-server.ps1"
} else {
    Write-Host "Сервер не запущен. Используйте: $ToolsPath\start-proxy-server.ps1" -ForegroundColor Yellow
}

# ═══════════════════════════════════════════════════════════════════
# Step 10: OAuth Setup
# ═══════════════════════════════════════════════════════════════════

Write-Header "Шаг 10: Авторизация провайдеров"

Write-Host "Для использования AI моделей нужно авторизовать провайдеров:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Доступные провайдеры:" -ForegroundColor Cyan
Write-Host "  • Google Gemini     (--login)" -ForegroundColor White
Write-Host "  • GitHub Copilot    (--github-copilot-login)" -ForegroundColor White
Write-Host "  • Claude            (--claude-login)" -ForegroundColor White
Write-Host "  • Qwen              (--qwen-login)" -ForegroundColor White
Write-Host "  • Antigravity       (--antigravity-login)" -ForegroundColor White
Write-Host ""

$response = Read-Host "Начать авторизацию провайдеров? (Y/n)"
if ($response -eq "" -or $response -eq "Y" -or $response -eq "y") {
    Write-Host ""
    Write-Host "Выберите провайдера:" -ForegroundColor Yellow
    Write-Host "1) Google Gemini"
    Write-Host "2) GitHub Copilot"
    Write-Host "3) Claude"
    Write-Host "4) Qwen"
    Write-Host "5) Antigravity"
    Write-Host "0) Пропустить"
    Write-Host ""
    
    $choice = Read-Host "Ваш выбор"
    
    $exePath = "$BinPath\cliproxyapi-plus.exe"
    $configFile = "$ConfigPath\config.yaml"
    
    switch ($choice) {
        "1" { & $exePath --config $configFile --login }
        "2" { & $exePath --config $configFile --github-copilot-login }
        "3" { & $exePath --config $configFile --claude-login }
        "4" { & $exePath --config $configFile --qwen-login }
        "5" { & $exePath --config $configFile --antigravity-login }
        "0" { Write-Host "Авторизация пропущена" -ForegroundColor Gray }
        default { Write-Host "Неверный выбор" -ForegroundColor Red }
    }
} else {
    Write-Host "Авторизация пропущена" -ForegroundColor Gray
    Write-Host "Для авторизации используйте:" -ForegroundColor Yellow
    Write-Host "  cliproxyapi-plus.exe --config $ConfigPath\config.yaml --login" -ForegroundColor Cyan
}

# ═══════════════════════════════════════════════════════════════════
# Final Summary
# ═══════════════════════════════════════════════════════════════════

Write-Header "✓ Установка завершена!"

Write-Host "Расположение файлов:" -ForegroundColor Yellow
Write-Host "  Бинарный файл:  $BinPath\cliproxyapi-plus.exe" -ForegroundColor Cyan
Write-Host "  Конфигурация:   $ConfigPath\config.yaml" -ForegroundColor Cyan
Write-Host "  Скрипты:        $ToolsPath\" -ForegroundColor Cyan
Write-Host "  Ярлыки:         $aiFolder\" -ForegroundColor Cyan
Write-Host ""

Write-Host "Быстрые команды:" -ForegroundColor Yellow
Write-Host "  Запустить:  $ToolsPath\start-proxy-server.ps1" -ForegroundColor Cyan
Write-Host "  Остановить: $ToolsPath\stop-proxy-server.ps1" -ForegroundColor Cyan
Write-Host ""

Write-Host "API Endpoint: http://localhost:8317" -ForegroundColor Green
Write-Host "API Key:      sk-dummy" -ForegroundColor Green
Write-Host ""

Write-Host "Следующие шаги:" -ForegroundColor Yellow
Write-Host "  1. Авторизуйте нужные провайдеры" -ForegroundColor White
Write-Host "  2. Настройте Claude CLI или Copilot CLI" -ForegroundColor White
Write-Host "  3. Начните использовать AI модели!" -ForegroundColor White
Write-Host ""

Write-Host "Документация и примеры:" -ForegroundColor Yellow
Write-Host "  https://github.com/router-for-me/CLIProxyAPIPlus" -ForegroundColor Cyan
Write-Host ""

Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
