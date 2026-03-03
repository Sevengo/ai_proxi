# ═══════════════════════════════════════════════════════════════════
# CLI AI Launcher - Универсальный лаунчер для AI CLI инструментов
# ═══════════════════════════════════════════════════════════════════
# Автоматически настраивает и запускает CLI инструменты через прокси
# с выбранным провайдером и моделью
# ═══════════════════════════════════════════════════════════════════

param(
    [string]$Tool = "",           # claude, copilot, cursor, или пусто для меню
    [string]$Provider = "",        # gemini, copilot, claude, qwen, antigravity
    [string]$Model = "",           # название модели
    [string]$Prompt = "",          # прямой запрос (пропускает интерактивный режим)
    [switch]$List,                 # показать доступные модели
    [switch]$Status                # показать статус прокси
)

$ErrorActionPreference = "Stop"

# ═══════════════════════════════════════════════════════════════════
# Конфигурация
# ═══════════════════════════════════════════════════════════════════

$proxyUrl = "http://localhost:8317"
$proxyPort = 8317
$exePath = "$env:USERPROFILE\bin\cliproxyapi-plus.exe"
$configPath = "$env:USERPROFILE\.cli-proxy-api\config.yaml"

# Доступные CLI инструменты
$availableTools = @{
    "claude"    = @{
        Name        = "Claude CLI"
        Command     = "claude"
        EnvVars     = @{
            "ANTHROPIC_API_URL" = "$proxyUrl/v1"
            "ANTHROPIC_API_KEY" = "sk-dummy"
        }
        CheckCommand = "claude --version"
        InstallHelp = "npm install -g @anthropic-ai/claude-cli"
    }
    "copilot"   = @{
        Name        = "GitHub Copilot CLI"
        Command     = "gh copilot"
        EnvVars     = @{
            "GITHUB_COPILOT_API_BASE_URL" = $proxyUrl
            "GITHUB_COPILOT_TOKEN"         = "sk-dummy"
        }
        CheckCommand = "gh copilot --version"
        InstallHelp = "winget install --id GitHub.cli && gh extension install github/gh-copilot"
    }
    "cursor"    = @{
        Name        = "Cursor (OpenAI API)"
        Command     = "curl"
        EnvVars     = @{
            "OPENAI_API_BASE"   = "$proxyUrl/v1"
            "OPENAI_API_KEY"    = "sk-dummy"
        }
        CheckCommand = "curl --version"
        InstallHelp = "Cursor использует OpenAI API"
    }
}

# Рекомендуемые модели для разных провайдеров
$providerModels = @{
    "gemini"       = @("gemini-2.0-flash-exp", "gemini-2.0-flash-thinking-exp", "gemini-1.5-pro", "gemini-exp-1206")
    "copilot"      = @("gpt-5.2", "gpt-5.2-codex", "gpt-5.1", "gpt-4.1", "claude-sonnet-4.5", "claude-opus-4.5")
    "claude"       = @("claude-3-5-sonnet-20241022", "claude-3-5-haiku-20241022", "claude-3-opus-20240229")
    "qwen"         = @("qwen-max", "qwen-plus", "qwen-turbo")
    "antigravity"  = @("gpt-4", "claude-3", "gemini-pro")
}

# ═══════════════════════════════════════════════════════════════════
# Функции
# ═══════════════════════════════════════════════════════════════════

function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Test-ProxyRunning {
    $process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    if ($process) {
        return $true
    }
    return $false
}

function Start-ProxyServer {
    if (Test-ProxyRunning) {
        Write-Host "✓ Прокси сервер уже запущен" -ForegroundColor Green
        return $true
    }
    
    Write-Host "⚠️  Прокси сервер не запущен. Запускаю..." -ForegroundColor Yellow
    
    if (-not (Test-Path $exePath)) {
        Write-Host "✗ Не найден: $exePath" -ForegroundColor Red
        return $false
    }
    
    Start-Process -FilePath $exePath -ArgumentList "--config", $configPath -WindowStyle Hidden
    Start-Sleep -Seconds 3
    
    if (Test-ProxyRunning) {
        Write-Host "✓ Прокси сервер запущен" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ Не удалось запустить прокси сервер" -ForegroundColor Red
        return $false
    }
}

function Get-ProxyStatus {
    Write-Header "Статус Прокси Сервера"
    
    if (Test-ProxyRunning) {
        $process = Get-Process -Name "cliproxyapi-plus"
        Write-Host "Статус:  ✓ Запущен" -ForegroundColor Green
        Write-Host "PID:     $($process.Id)" -ForegroundColor Cyan
        Write-Host "URL:     $proxyUrl" -ForegroundColor Cyan
        
        # Проверить доступные модели
        try {
            $response = Invoke-RestMethod -Uri "$proxyUrl/v1/models" -Headers @{"Authorization"="Bearer sk-dummy"} -TimeoutSec 5
            $models = $response.data | Select-Object -ExpandProperty id
            Write-Host "Модели:  $($models.Count) доступно" -ForegroundColor Cyan
        } catch {
            Write-Host "Модели:  Ошибка получения списка" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Статус:  ✗ Не запущен" -ForegroundColor Red
    }
}

function Get-AvailableModels {
    Write-Header "Доступные Модели"
    
    if (-not (Test-ProxyRunning)) {
        Write-Host "✗ Прокси сервер не запущен" -ForegroundColor Red
        return
    }
    
    try {
        $response = Invoke-RestMethod -Uri "$proxyUrl/v1/models" -Headers @{"Authorization"="Bearer sk-dummy"}
        $models = $response.data | Select-Object id, @{Name="Provider";Expression={
            if ($_.id -like "gemini*") { "Gemini" }
            elseif ($_.id -like "gpt*" -or $_.id -like "o1*") { "Copilot" }
            elseif ($_.id -like "claude*") { "Claude/Copilot" }
            elseif ($_.id -like "qwen*") { "Qwen" }
            else { "Other" }
        }}
        
        $groupedModels = $models | Group-Object Provider
        
        foreach ($group in $groupedModels) {
            Write-Host ""
            Write-Host "[$($group.Name)]" -ForegroundColor Yellow
            foreach ($model in $group.Group) {
                Write-Host "  • $($model.id)" -ForegroundColor Cyan
            }
        }
        Write-Host ""
    } catch {
        Write-Host "✗ Ошибка получения списка моделей: $_" -ForegroundColor Red
    }
}

function Set-ToolEnvironment {
    param(
        [string]$ToolName,
        [hashtable]$Tool
    )
    
    Write-Host "Настройка окружения для $($Tool.Name)..." -ForegroundColor Yellow
    
    foreach ($var in $Tool.EnvVars.GetEnumerator()) {
        [Environment]::SetEnvironmentVariable($var.Key, $var.Value, "Process")
        Write-Host "  ✓ $($var.Key) = $($var.Value)" -ForegroundColor Green
    }
}

function Show-ToolMenu {
    Write-Header "Выбор CLI Инструмента"
    
    $i = 1
    $toolList = @()
    foreach ($tool in $availableTools.GetEnumerator()) {
        $installed = try { Invoke-Expression "$($tool.Value.CheckCommand) 2>&1 | Out-Null"; $? } catch { $false }
        $status = if ($installed) { "✓" } else { "✗" }
        
        Write-Host "$i) $status $($tool.Value.Name)" -ForegroundColor $(if ($installed) { "Green" } else { "Yellow" })
        $toolList += $tool.Key
        $i++
    }
    
    Write-Host ""
    $choice = Read-Host "Выберите инструмент (1-$($toolList.Count))"
    
    try {
        $index = [int]$choice - 1
        if ($index -ge 0 -and $index -lt $toolList.Count) {
            return $toolList[$index]
        }
    } catch {}
    
    return $null
}

function Show-ProviderMenu {
    Write-Header "Выбор Провайдера"
    
    Write-Host "1) Google Gemini      (рекомендуется)" -ForegroundColor Green
    Write-Host "2) GitHub Copilot     (GPT-5, Claude)" -ForegroundColor Cyan
    Write-Host "3) Claude             (требует авторизации)" -ForegroundColor Yellow
    Write-Host "4) Qwen               (требует авторизации)" -ForegroundColor Yellow
    Write-Host "5) Antigravity        (требует авторизации)" -ForegroundColor Yellow
    Write-Host ""
    
    $choice = Read-Host "Выберите провайдера (1-5)"
    
    switch ($choice) {
        "1" { return "gemini" }
        "2" { return "copilot" }
        "3" { return "claude" }
        "4" { return "qwen" }
        "5" { return "antigravity" }
        default { return $null }
    }
}

function Show-ModelMenu {
    param([string]$Provider)
    
    Write-Header "Выбор Модели ($Provider)"
    
    $models = $providerModels[$Provider]
    if (-not $models) {
        Write-Host "✗ Нет предустановленных моделей для провайдера $Provider" -ForegroundColor Red
        return $null
    }
    
    for ($i = 0; $i -lt $models.Count; $i++) {
        Write-Host "$($i+1)) $($models[$i])" -ForegroundColor Cyan
    }
    Write-Host ""
    Write-Host "0) Ввести вручную" -ForegroundColor Gray
    Write-Host ""
    
    $choice = Read-Host "Выберите модель (0-$($models.Count))"
    
    if ($choice -eq "0") {
        return Read-Host "Введите название модели"
    }
    
    try {
        $index = [int]$choice - 1
        if ($index -ge 0 -and $index -lt $models.Count) {
            return $models[$index]
        }
    } catch {}
    
    return $null
}

function Start-ClaudeCLI {
    param(
        [string]$Model,
        [string]$Prompt
    )
    
    Write-Header "Запуск Claude CLI"
    
    # Проверить установку
    try {
        claude --version | Out-Null
    } catch {
        Write-Host "✗ Claude CLI не установлен" -ForegroundColor Red
        Write-Host "Установите: npm install -g @anthropic-ai/claude-cli" -ForegroundColor Yellow
        return
    }
    
    # Настроить окружение
    Set-ToolEnvironment -ToolName "claude" -Tool $availableTools["claude"]
    
    Write-Host ""
    Write-Host "Модель: $Model" -ForegroundColor Cyan
    Write-Host "Прокси: $proxyUrl" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Используйте Ctrl+C для выхода" -ForegroundColor Gray
    Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host ""
    
    # Запустить Claude CLI
    if ($Prompt) {
        # Прямой запрос
        $env:ANTHROPIC_MODEL = $Model
        claude $Prompt
    } else {
        # Интерактивный режим
        $env:ANTHROPIC_MODEL = $Model
        claude
    }
}

function Start-CopilotCLI {
    param(
        [string]$Model,
        [string]$Command
    )
    
    Write-Header "Запуск GitHub Copilot CLI"
    
    # Проверить установку
    try {
        gh copilot --version | Out-Null
    } catch {
        Write-Host "✗ GitHub Copilot CLI не установлен" -ForegroundColor Red
        Write-Host "Установите: gh extension install github/gh-copilot" -ForegroundColor Yellow
        return
    }
    
    # Настроить окружение
    Set-ToolEnvironment -ToolName "copilot" -Tool $availableTools["copilot"]
    
    Write-Host ""
    Write-Host "⚠️  ВАЖНО: GitHub Copilot сам выбирает модель" -ForegroundColor Yellow
    $scriptPath = $PSScriptRoot
    if (-not $scriptPath) {
        $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    Write-Host "   Для использования $Model запустите Claude CLI:" -ForegroundColor Yellow
    Write-Host "   $scriptPath\launch-ai.ps1 -Tool claude -Provider $Provider -Model $Model" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Прокси: $proxyUrl" -ForegroundColor Cyan
    Write-Host ""
    
    if ($Command) {
        # Если команда начинается с suggest/explain, использовать напрямую
        if ($Command -match "^(suggest|explain)\s") {
            gh copilot $Command
        } else {
            # Иначе считаем это запросом для suggest
            gh copilot suggest $Command
        }
    } else {
        Write-Host "GitHub Copilot CLI - Интерактивный режим" -ForegroundColor Green
        Write-Host "════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "Примеры:" -ForegroundColor Yellow
        Write-Host "  suggest find large files" -ForegroundColor Cyan
        Write-Host "  suggest compress all images" -ForegroundColor Cyan
        Write-Host "  explain git rebase -i HEAD~5" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Введите 'exit' для выхода" -ForegroundColor Gray
        Write-Host ""
        
        while ($true) {
            $input = Read-Host "copilot>"
            
            if ($input -eq "exit" -or $input -eq "quit" -or $input -eq "") {
                break
            }
            
            # Если команда начинается с suggest/explain, использовать напрямую
            if ($input -match "^(suggest|explain)\s") {
                gh copilot $input
            } else {
                # Иначе считаем это запросом для suggest
                gh copilot suggest $input
            }
            
            Write-Host ""
        }
    }
}

# ═══════════════════════════════════════════════════════════════════
# Главная логика
# ═══════════════════════════════════════════════════════════════════

Write-Header "CLI AI Launcher"

# Показать статус
if ($Status) {
    Get-ProxyStatus
    exit 0
}

# Показать список моделей
if ($List) {
    Get-AvailableModels
    exit 0
}

# Проверить и запустить прокси сервер
if (-not (Start-ProxyServer)) {
    Write-Host ""
    Write-Host "✗ Не удалось запустить прокси сервер" -ForegroundColor Red
    $scriptPath = $PSScriptRoot
    if (-not $scriptPath) {
        $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    Write-Host "Запустите вручную: $scriptPath\start-proxy-server.ps1" -ForegroundColor Yellow
    exit 1
}

# Выбрать CLI инструмент
if (-not $Tool) {
    $Tool = Show-ToolMenu
    if (-not $Tool) {
        Write-Host "✗ Не выбран инструмент" -ForegroundColor Red
        exit 1
    }
}

# Выбрать провайдера
if (-not $Provider) {
    $Provider = Show-ProviderMenu
    if (-not $Provider) {
        Write-Host "✗ Не выбран провайдер" -ForegroundColor Red
        exit 1
    }
}

# Выбрать модель
if (-not $Model) {
    $Model = Show-ModelMenu -Provider $Provider
    if (-not $Model) {
        Write-Host "✗ Не выбрана модель" -ForegroundColor Red
        exit 1
    }
}

# Запустить выбранный инструмент
switch ($Tool.ToLower()) {
    "claude" {
        Start-ClaudeCLI -Model $Model -Prompt $Prompt
    }
    "copilot" {
        Start-CopilotCLI -Model $Model -Command $Prompt
    }
    default {
        Write-Host "✗ Инструмент '$Tool' пока не поддерживается" -ForegroundColor Red
    }
}
