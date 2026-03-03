# ═══════════════════════════════════════════════════════════════════
# GitHub Copilot CLI - Интерактивный режим
# ═══════════════════════════════════════════════════════════════════
# Удобная обертка для работы с Copilot CLI
# Просто вводите запросы и получайте команды
# ═══════════════════════════════════════════════════════════════════

param(
    [switch]$AutoStart  # Автоматически запустить прокси если нужно
)

# Цвета
$Host.UI.RawUI.ForegroundColor = "White"

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
        Write-Host "   Запустите: D:\tools\ai\start-proxy-server.ps1" -ForegroundColor Cyan
        Write-Host "   Или перезапустите с флагом: -AutoStart" -ForegroundColor Gray
        Write-Host ""
        exit 1
    }
}

# ═══════════════════════════════════════════════════════════════════
# Настройка окружения
# ═══════════════════════════════════════════════════════════════════

$env:GITHUB_COPILOT_API_BASE_URL = "http://localhost:8317"
$env:GITHUB_COPILOT_TOKEN = "sk-dummy"

# ═══════════════════════════════════════════════════════════════════
# Проверка установки Copilot
# ═══════════════════════════════════════════════════════════════════

try {
    gh copilot --version 2>&1 | Out-Null
} catch {
    Write-Host ""
    Write-Host "✗ GitHub Copilot CLI не установлен!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Установите:" -ForegroundColor Yellow
    Write-Host "  1. GitHub CLI: winget install --id GitHub.cli" -ForegroundColor Cyan
    Write-Host "  2. Copilot extension: gh extension install github/gh-copilot" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# ═══════════════════════════════════════════════════════════════════
# Заголовок
# ═══════════════════════════════════════════════════════════════════

Clear-Host
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         GitHub Copilot CLI - Интерактивный режим          ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "✓ Прокси:  http://localhost:8317" -ForegroundColor Green
Write-Host "✓ Модель:  Автоматический выбор GitHub Copilot" -ForegroundColor Green
Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Как использовать:" -ForegroundColor Yellow
Write-Host "  • Введите запрос → получите команду" -ForegroundColor White
Write-Host "  • Начните с 'explain:' → объяснение команды" -ForegroundColor White
Write-Host "  • Введите 'exit' → выход" -ForegroundColor White
Write-Host ""
Write-Host "Примеры:" -ForegroundColor Yellow
Write-Host "  find large files" -ForegroundColor Cyan
Write-Host "  compress all images in folder" -ForegroundColor Cyan
Write-Host "  explain: git rebase -i HEAD~5" -ForegroundColor Cyan
Write-Host "  backup MySQL database to S3" -ForegroundColor Cyan
Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

# ═══════════════════════════════════════════════════════════════════
# Интерактивный цикл
# ═══════════════════════════════════════════════════════════════════

while ($true) {
    # Приглашение
    Write-Host "copilot" -NoNewline -ForegroundColor Green
    Write-Host ">" -NoNewline -ForegroundColor DarkGray
    Write-Host " " -NoNewline
    
    # Читаем ввод
    $userInput = Read-Host
    
    # Проверка на выход
    if ($userInput -eq "exit" -or $userInput -eq "quit" -or $userInput -eq "q" -or $userInput -eq "") {
        Write-Host ""
        Write-Host "Do svidaniya!" -ForegroundColor Cyan
        Write-Host ""
        break
    }
    
    # Специальные команды
    if ($userInput -eq "help" -or $userInput -eq "?" -or $userInput -eq "h") {
        Write-Host ""
        Write-Host "Доступные команды:" -ForegroundColor Yellow
        Write-Host "  help, ?, h        - Показать эту справку" -ForegroundColor White
        Write-Host "  status            - Статус прокси сервера" -ForegroundColor White
        Write-Host "  clear, cls        - Очистить экран" -ForegroundColor White
        Write-Host "  exit, quit, q     - Выход" -ForegroundColor White
        Write-Host ""
        Write-Host "Для запросов команд просто введите что вы хотите сделать:" -ForegroundColor Yellow
        Write-Host "  find large files" -ForegroundColor Cyan
        Write-Host "  compress images" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Для объяснения команд начните с 'explain:':" -ForegroundColor Yellow
        Write-Host "  explain: git rebase -i HEAD~5" -ForegroundColor Cyan
        Write-Host "  explain: docker-compose up -d" -ForegroundColor Cyan
        Write-Host ""
        continue
    }
    
    if ($userInput -eq "status") {
        Write-Host ""
        if (Test-ProxyRunning) {
            Write-Host "Proxy server is running" -ForegroundColor Green
            Write-Host "  URL: http://localhost:8317" -ForegroundColor Cyan
        } else {
            Write-Host "Proxy server is not running" -ForegroundColor Red
        }
        Write-Host ""
        continue
    }
    
    if ($userInput -eq "clear" -or $userInput -eq "cls") {
        Clear-Host
        Write-Host ""
        Write-Host "GitHub Copilot CLI - Interactive Mode" -ForegroundColor Cyan
        Write-Host ""
        continue
    }
    
    # Обработка запроса
    Write-Host ""
    
    if ($userInput -match "^explain:\s*(.+)") {
        # Режим объяснения
        $command = $matches[1].Trim()
        Write-Host "Explaining command: $command" -ForegroundColor Yellow
        Write-Host ""
        gh copilot explain $command
    } else {
        # Режим предложения команды
        Write-Host "Finding command for: $userInput" -ForegroundColor Yellow
        Write-Host ""
        gh copilot suggest $userInput
    }
    
    Write-Host ""
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
}
