# CLI Proxy API Plus - Quick Menu
# Быстрое меню управления

param(
    [switch]$Status,
    [switch]$Start,
    [switch]$Stop,
    [switch]$Restart,
    [switch]$Login,
    [switch]$Test,
    [switch]$Models,
    [switch]$Help
)

$configPath = "C:\Users\s.semihod\.cli-proxy-api\config.yaml"
$exePath = "C:\Users\s.semihod\bin\cliproxyapi-plus.exe"

# Определяем путь к скриптам
$scriptPath = $PSScriptRoot
if (-not $scriptPath) {
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
}

function Show-Menu {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "     CLI Proxy API Plus - Quick Menu" -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Команды:" -ForegroundColor Yellow
    Write-Host "  proxy -Status    " -NoNewline; Write-Host "Проверить статус сервера" -ForegroundColor Gray
    Write-Host "  proxy -Start     " -NoNewline; Write-Host "Запустить сервер" -ForegroundColor Gray
    Write-Host "  proxy -Stop      " -NoNewline; Write-Host "Остановить сервер" -ForegroundColor Gray
    Write-Host "  proxy -Restart   " -NoNewline; Write-Host "Перезапустить сервер" -ForegroundColor Gray
    Write-Host "  proxy -Login     " -NoNewline; Write-Host "Авторизация провайдеров" -ForegroundColor Gray
    Write-Host "  proxy -Test      " -NoNewline; Write-Host "Тест подключения" -ForegroundColor Gray
    Write-Host "  proxy -Models    " -NoNewline; Write-Host "Список доступных моделей" -ForegroundColor Gray
    Write-Host "  proxy -Help      " -NoNewline; Write-Host "Показать справку" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Скрипты настройки:" -ForegroundColor Yellow
    Write-Host "  $scriptPath\claude-proxy-setup.ps1" -ForegroundColor Cyan
    Write-Host "  $scriptPath\copilot-proxy-setup.ps1" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Документация: $scriptPath\README.md" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""
}

function Get-ServerStatus {
    $process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "              Статус сервера" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    
    if ($process) {
        Write-Host "Статус:     " -NoNewline -ForegroundColor Yellow
        Write-Host "✓ Запущен" -ForegroundColor Green
        Write-Host "PID:        " -NoNewline -ForegroundColor Yellow
        Write-Host $process.Id -ForegroundColor White
        Write-Host "Запущен:    " -NoNewline -ForegroundColor Yellow
        Write-Host $process.StartTime -ForegroundColor White
        Write-Host "Память:     " -NoNewline -ForegroundColor Yellow
        Write-Host ("{0:N2} MB" -f ($process.WorkingSet64/1MB)) -ForegroundColor White
        
        $testResult = Test-NetConnection -ComputerName localhost -Port 8317 -InformationLevel Quiet -WarningAction SilentlyContinue
        Write-Host "Порт 8317:  " -NoNewline -ForegroundColor Yellow
        if ($testResult) {
            Write-Host "✓ Открыт" -ForegroundColor Green
        } else {
            Write-Host "✗ Закрыт" -ForegroundColor Red
        }
        
        Write-Host "URL:        " -NoNewline -ForegroundColor Yellow
        Write-Host "http://localhost:8317" -ForegroundColor Cyan
    } else {
        Write-Host "Статус:     " -NoNewline -ForegroundColor Yellow
        Write-Host "✗ Остановлен" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Авторизованные провайдеры:" -ForegroundColor Yellow
    $authFiles = Get-ChildItem "C:\Users\s.semihod\.cli-proxy-api" -Filter "*.json" -ErrorAction SilentlyContinue
    if ($authFiles) {
        foreach ($file in $authFiles) {
            Write-Host "  ✓ " -NoNewline -ForegroundColor Green
            Write-Host $file.Name -ForegroundColor White
        }
    } else {
        Write-Host "  (нет авторизованных провайдеров)" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Start-ProxyServer {
    $process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    
    if ($process) {
        Write-Host "✓ Сервер уже запущен (PID: $($process.Id))" -ForegroundColor Yellow
    } else {
        Write-Host "Запуск сервера..." -ForegroundColor Green
        Start-Process -FilePath $exePath -ArgumentList "--config", $configPath -WindowStyle Hidden
        Start-Sleep -Seconds 2
        
        $newProcess = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
        if ($newProcess) {
            Write-Host "✓ Сервер успешно запущен (PID: $($newProcess.Id))" -ForegroundColor Green
        } else {
            Write-Host "✗ Не удалось запустить сервер" -ForegroundColor Red
        }
    }
}

function Stop-ProxyServer {
    $process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
    
    if ($process) {
        Write-Host "Остановка сервера (PID: $($process.Id))..." -ForegroundColor Yellow
        Stop-Process -Id $process.Id -Force
        Start-Sleep -Seconds 1
        
        $stillRunning = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
        if (-not $stillRunning) {
            Write-Host "✓ Сервер остановлен" -ForegroundColor Green
        } else {
            Write-Host "✗ Не удалось остановить сервер" -ForegroundColor Red
        }
    } else {
        Write-Host "✓ Сервер не запущен" -ForegroundColor Yellow
    }
}

function Test-ProxyAPI {
    Write-Host ""
    Write-Host "Тестирование API..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers @{"Authorization"="Bearer sk-dummy"} -ErrorAction Stop
        Write-Host "✓ API отвечает!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Доступно моделей: $($response.data.Count)" -ForegroundColor Cyan
        Write-Host ""
    } catch {
        Write-Host "✗ Ошибка подключения: $_" -ForegroundColor Red
        Write-Host ""
    }
}

function Show-Models {
    Write-Host ""
    Write-Host "Загрузка списка моделей..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers @{"Authorization"="Bearer sk-dummy"} -ErrorAction Stop
        Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "       Доступные модели ($($response.data.Count))" -ForegroundColor Cyan
        Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host ""
        
        foreach ($model in $response.data) {
            Write-Host "  • " -NoNewline -ForegroundColor Green
            Write-Host $model.id -ForegroundColor White
        }
        
        Write-Host ""
        Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host ""
    } catch {
        Write-Host "✗ Ошибка: $_" -ForegroundColor Red
        Write-Host ""
    }
}

# Main logic
if ($Help -or (-not ($Status -or $Start -or $Stop -or $Restart -or $Login -or $Test -or $Models))) {
    Show-Menu
    exit 0
}

if ($Status) { Get-ServerStatus }
if ($Start) { Start-ProxyServer }
if ($Stop) { Stop-ProxyServer }
if ($Restart) { 
    Stop-ProxyServer
    Start-Sleep -Seconds 2
    Start-ProxyServer
}
if ($Login) { & "$scriptPath\batch-oauth-login.ps1" }
if ($Test) { Test-ProxyAPI }
if ($Models) { Show-Models }
