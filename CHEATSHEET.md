# CLI Proxy API Plus - Шпаргалка

## Быстрые команды

### Управление сервером
```powershell
C:\tools\proxy.ps1 -Start      # Запустить
C:\tools\proxy.ps1 -Stop       # Остановить  
C:\tools\proxy.ps1 -Restart    # Перезапустить
C:\tools\proxy.ps1 -Status     # Статус
```

### Информация
```powershell
C:\tools\proxy.ps1 -Models     # Список моделей
C:\tools\proxy.ps1 -Test       # Тест API
C:\tools\proxy.ps1 -Help       # Справка
```

### OAuth авторизация
```powershell
C:\tools\batch-oauth-login.ps1  # Интерактивное меню

# Или вручную:
cliproxyapi-plus --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --login           # Gemini
cliproxyapi-plus --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --claude-login    # Claude
cliproxyapi-plus --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --codex-login     # Codex
cliproxyapi-plus --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --qwen-login      # Qwen
```

### Настройка CLI инструментов
```powershell
C:\tools\claude-proxy-setup.ps1    # Claude CLI
C:\tools\copilot-proxy-setup.ps1   # Copilot CLI
```

### Использование Claude CLI
```powershell
claude "Твой вопрос"
claude chat                         # Интерактивный режим
claude "Анализ кода" --file app.py
```

### Использование Copilot CLI  
```powershell
gh copilot suggest "найти большие файлы"
gh copilot explain "docker run -d -p 8080:80 nginx"
```

### API запросы напрямую
```powershell
# Gemini
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{"model": "gemini-2.0-flash-exp", "messages": [{"role": "user", "content": "Hi"}]}'

# Claude
curl http://localhost:8317/v1/messages `
  -H "Content-Type: application/json" `
  -H "x-api-key: sk-dummy" `
  -H "anthropic-version: 2023-06-01" `
  -d '{"model": "claude-3-5-sonnet-20241022", "max_tokens": 1024, "messages": [{"role": "user", "content": "Hi"}]}'
```

## Основные пути

```
Бинарник:   C:\Users\s.semihod\bin\cliproxyapi-plus.exe
Конфиг:     C:\Users\s.semihod\.cli-proxy-api\config.yaml
Токены:     C:\Users\s.semihod\.cli-proxy-api\*.json
Скрипты:    C:\tools\*.ps1
Документы:  C:\tools\*.md
```

## Проверка статуса

```powershell
# Процесс запущен?
Get-Process cliproxyapi-plus

# Порт открыт?
Test-NetConnection localhost -Port 8317

# Авторизованные провайдеры
Get-ChildItem "C:\Users\s.semihod\.cli-proxy-api" -Filter "*.json"

# Доступные модели
Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers @{"Authorization"="Bearer sk-dummy"}
```

## Популярные модели

```
GPT:     gpt-5.2, gpt-5, gpt-4o
Claude:  claude-4.5, claude-sonnet-4
Gemini:  gemini-3-flash-preview, gemini-2.0-flash-exp
```

## Переменные окружения

### Claude CLI
```powershell
$env:ANTHROPIC_API_URL = "http://localhost:8317/v1"
$env:ANTHROPIC_API_KEY = "sk-dummy"
```

### Copilot CLI
```powershell
$env:GITHUB_COPILOT_API_BASE_URL = "http://localhost:8317"
$env:GITHUB_COPILOT_TOKEN = "sk-dummy"
```

## Автозапуск

```powershell
# Создать задачу
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle Hidden -File C:\tools\start-proxy-server.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
Register-ScheduledTask -TaskName "CLIProxyAPIPlus" -Action $action -Trigger $trigger

# Удалить задачу
Unregister-ScheduledTask -TaskName "CLIProxyAPIPlus" -Confirm:$false
```

## Алиасы PowerShell

Добавьте в `$PROFILE`:
```powershell
function proxy { C:\tools\proxy.ps1 @args }
function proxy-start { C:\tools\start-proxy-server.ps1 }
function proxy-stop { C:\tools\stop-proxy-server.ps1 }
```

Затем: `. $PROFILE`

## Решение проблем

```powershell
# Перезапуск
C:\tools\proxy.ps1 -Restart

# Переустановка настроек CLI
C:\tools\claude-proxy-setup.ps1
C:\tools\copilot-proxy-setup.ps1

# Повторная авторизация
C:\tools\batch-oauth-login.ps1

# Проверка логов
Get-ChildItem "C:\Users\s.semihod\.cli-proxy-api" -Filter "*.log"

# Убить процесс вручную
$pid = (Get-Process cliproxyapi-plus).Id
Stop-Process -Id $pid -Force
```

## Полезные ссылки

📚 Документация:
- C:\tools\README.md
- C:\tools\INTEGRATION-GUIDE.md
- C:\tools\available-providers.md

🔗 Внешние:
- https://github.com/router-for-me/CLIProxyAPIPlus
- https://deepwiki.com/router-for-me/CLIProxyAPIPlus
