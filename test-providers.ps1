# ═══════════════════════════════════════════════════════════════════
# Тестирование провайдеров через прокси
# ═══════════════════════════════════════════════════════════════════

param(
    [string]$Model = "",  # Тестировать конкретную модель
    [switch]$All          # Тестировать все модели
)

$proxyUrl = "http://localhost:8317"

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "  Тестирование провайдеров через CLI Proxy API Plus" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

# Проверка прокси
$process = Get-Process -Name "cliproxyapi-plus" -ErrorAction SilentlyContinue
if (-not $process) {
    $scriptPath = $PSScriptRoot
    if (-not $scriptPath) {
        $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    Write-Host "X Прокси сервер не запущен!" -ForegroundColor Red
    Write-Host "  Запустите: $scriptPath\start-proxy-server.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "V Прокси сервер работает (PID: $($process.Id))" -ForegroundColor Green
Write-Host ""

# Получить список моделей
try {
    $response = Invoke-RestMethod -Uri "$proxyUrl/v1/models" -Headers @{"Authorization"="Bearer sk-dummy"} -TimeoutSec 10
    $models = $response.data | Select-Object -ExpandProperty id | Sort-Object
    Write-Host "V Доступно моделей: $($models.Count)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "X Ошибка получения списка моделей: $_" -ForegroundColor Red
    exit 1
}

# Функция тестирования модели
function Test-Model {
    param([string]$ModelName)
    
    Write-Host "Testing: $ModelName" -NoNewline -ForegroundColor Yellow
    
    $body = @{
        model = $ModelName
        messages = @(@{role="user"; content="Say just 'OK' and nothing else"})
        max_tokens = 10
    } | ConvertTo-Json -Depth 3
    
    try {
        $startTime = Get-Date
        $result = Invoke-RestMethod -Uri "$proxyUrl/v1/chat/completions" `
            -Method POST `
            -Headers @{"Authorization"="Bearer sk-dummy"; "Content-Type"="application/json"} `
            -Body $body `
            -TimeoutSec 30
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds
        
        $content = $result.choices[0].message.content
        Write-Host " -> " -NoNewline
        Write-Host "OK" -NoNewline -ForegroundColor Green
        Write-Host " ($([math]::Round($duration, 2))s) " -NoNewline -ForegroundColor Gray
        Write-Host "Response: $($content.Substring(0, [Math]::Min(30, $content.Length)))..." -ForegroundColor Cyan
        return $true
    } catch {
        Write-Host " -> " -NoNewline
        Write-Host "FAILED" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor DarkRed
        return $false
    }
}

# Тестирование
if ($Model) {
    # Тест конкретной модели
    Write-Host "Тестирование модели: $Model" -ForegroundColor Yellow
    Write-Host ""
    Test-Model -ModelName $Model
} elseif ($All) {
    # Тест всех моделей
    Write-Host "Тестирование всех $($models.Count) моделей..." -ForegroundColor Yellow
    Write-Host ""
    
    $success = 0
    $failed = 0
    
    foreach ($m in $models) {
        if (Test-Model -ModelName $m) {
            $success++
        } else {
            $failed++
        }
    }
    
    Write-Host ""
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host "  Результаты: $success успешно, $failed ошибок" -ForegroundColor Cyan
    Write-Host "=======================================================" -ForegroundColor Cyan
} else {
    # Тест основных моделей
    $testModels = @(
        "gemini-2.0-flash-exp",
        "gemini-1.5-pro",
        "gpt-5.2",
        "claude-sonnet-4.5",
        "qwen-max"
    )
    
    Write-Host "Тестирование основных моделей:" -ForegroundColor Yellow
    Write-Host ""
    
    $success = 0
    $failed = 0
    
    foreach ($m in $testModels) {
        if ($models -contains $m) {
            if (Test-Model -ModelName $m) {
                $success++
            } else {
                $failed++
            }
        } else {
            Write-Host "Testing: $m" -NoNewline -ForegroundColor Yellow
            Write-Host " -> " -NoNewline
            Write-Host "NOT AVAILABLE" -ForegroundColor DarkYellow
        }
    }
    
    Write-Host ""
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host "  Результаты: $success успешно, $failed ошибок" -ForegroundColor Cyan
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host ""
    $scriptPath = $PSScriptRoot
    if (-not $scriptPath) {
        $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    Write-Host "Для теста всех моделей: $scriptPath\test-providers.ps1 -All" -ForegroundColor Gray
    Write-Host "Для теста конкретной:   $scriptPath\test-providers.ps1 -Model gemini-2.0-flash-exp" -ForegroundColor Gray
}

Write-Host ""
