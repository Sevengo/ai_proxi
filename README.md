# CLI Proxy API Plus - Полная инструкция по использованию

## ✅ Статус установки

**Сервер:** ✓ Работает на http://localhost:8317
**Бинарный файл:** C:\Users\s.semihod\bin\cliproxyapi-plus.exe
**Конфигурация:** C:\Users\s.semihod\.cli-proxy-api\config.yaml

## ✅ Авторизованные провайдеры

1. ✓ **Google Gemini** (semihod@gmail.com) - 7 проектов подключено
2. ✓ **GitHub Copilot** (Sevengo)

## 📁 Созданные скрипты в D:\tools\ai\

### Управление сервером:
- **start-proxy-server.ps1** - Запуск сервера
- **stop-proxy-server.ps1** - Остановка сервера

### OAuth авторизация:
- **batch-oauth-login.ps1** - Пакетная авторизация провайдеров
- **available-providers.md** - Список всех доступных провайдеров

### Интеграция с CLI:
- **claude-proxy-setup.ps1** - Настройка Claude CLI через прокси
- **copilot-proxy-setup.ps1** - Настройка GitHub Copilot CLI через прокси

---

## 🚀 Быстрый старт

### 1. Управление сервером

#### Запуск сервера:
```powershell
D:\tools\ai\start-proxy-server.ps1
```

#### Остановка сервера:
```powershell
D:\tools\ai\stop-proxy-server.ps1
```

#### Проверка статуса:
```powershell
Get-Process | Where-Object {$_.ProcessName -eq "cliproxyapi-plus"}
Test-NetConnection -ComputerName localhost -Port 8317 -InformationLevel Quiet
```

---

### 2. Авторизация дополнительных провайдеров

#### Интерактивное меню:
```powershell
D:\tools\ai\batch-oauth-login.ps1
```

#### Вручную (примеры):

**Claude:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --claude-login
```

**Codex:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --codex-login
```

**Qwen:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --qwen-login
```

**Kiro (Google):**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --kiro-google-login
```

#### Проверка авторизованных аккаунтов:
```powershell
Get-ChildItem "C:\Users\s.semihod\.cli-proxy-api" -Filter "*.json" | Select-Object Name, LastWriteTime
```

---

### 3. Настройка Claude CLI

#### Выполните скрипт настройки:
```powershell
D:\tools\ai\claude-proxy-setup.ps1
```

Это установит переменные окружения:
- `ANTHROPIC_API_URL = http://localhost:8317/v1`
- `ANTHROPIC_API_KEY = sk-dummy`

#### Использование Claude CLI:
```powershell
# После настройки используйте Claude CLI как обычно
claude "Explain quantum computing"

# Или через API
curl http://localhost:8317/v1/messages `
  -H "Content-Type: application/json" `
  -H "x-api-key: sk-dummy" `
  -H "anthropic-version: 2023-06-01" `
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 1024,
    "messages": [{"role": "user", "content": "Hello, Claude!"}]
  }'
```

---

### 4. Настройка GitHub Copilot CLI

#### Выполните скрипт настройки:
```powershell
D:\tools\ai\copilot-proxy-setup.ps1
```

Это установит переменные окружения:
- `GITHUB_COPILOT_API_BASE_URL = http://localhost:8317`
- `GITHUB_COPILOT_TOKEN = sk-dummy`

#### Использование Copilot CLI:
```powershell
# После настройки используйте Copilot как обычно
gh copilot suggest "create a python script"
gh copilot explain "git rebase"
```

---

## 🔧 Расширенная настройка

### Использование через прямые API запросы

#### Gemini (OpenAI-compatible format):
```powershell
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{
    "model": "gemini-2.0-flash-exp",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

#### GitHub Copilot:
```powershell
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "Write a hello world"}]
  }'
```

### Редактирование конфигурации
```powershell
notepad C:\Users\s.semihod\.cli-proxy-api\config.yaml
```

Основные настройки:
- `port: 8317` - порт сервера
- `api-keys: ["sk-dummy"]` - API ключи для доступа
- `incognito-browser: true` - использовать приватный режим браузера
- `request-retry: 3` - количество попыток при ошибке

После изменений перезапустите сервер:
```powershell
C:\tools\stop-proxy-server.ps1
C:\tools\start-proxy-server.ps1
```

---

## 📊 Мониторинг и логи

### Проверка работы сервера:
```powershell
# Проверить процесс
Get-Process cliproxyapi-plus -ErrorAction SilentlyContinue | Format-List

# Проверить порт
Test-NetConnection localhost -Port 8317

# Проверить API
Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers @{"Authorization"="Bearer sk-dummy"}
```

### Логи
Логи сохраняются в директории с конфигурацией:
```powershell
Get-ChildItem "C:\Users\s.semihod\.cli-proxy-api" -Filter "*.log"
```

---

## 🔄 Обновление

Для обновления CLI Proxy API Plus:
```powershell
cd C:\Users\s.semihod\CLIProxyAPIPlus
git pull
go build -o C:\Users\s.semihod\bin\cliproxyapi-plus.exe ./cmd/server

# Перезапустите сервер
C:\tools\stop-proxy-server.ps1
C:\tools\start-proxy-server.ps1
```

---

## ❗ Решение проблем

### Сервер не запускается:
```powershell
# Проверьте, что порт 8317 свободен
netstat -ano | findstr :8317

# Убейте процесс если нужно (замените PID)
Stop-Process -Id <PID> -Force
```

### Не работает OAuth:
```powershell
# Попробуйте с флагом -incognito
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --login -incognito

# Или откройте браузер вручную с флагом -no-browser
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --login -no-browser
```

### Claude CLI не подключается:
```powershell
# Проверьте переменные окружения
$env:ANTHROPIC_API_URL
$env:ANTHROPIC_API_KEY

# Переустановите если пусто
C:\tools\claude-proxy-setup.ps1
```

---

## 📝 Доступные модели

### Google Gemini:
- `gemini-2.0-flash-exp`
- `gemini-2.0-flash-thinking-exp`
- `gemini-1.5-pro`
- `gemini-1.5-flash`
- `gemini-exp-1206`

### GitHub Copilot:
- `gpt-4o`
- `gpt-4o-mini`
- `o1-preview`
- `o1-mini`

### Claude (после авторизации):
- `claude-3-5-sonnet-20241022`
- `claude-3-5-haiku-20241022`
- `claude-3-opus-20240229`

### Получить полный список:
```powershell
Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers @{"Authorization"="Bearer sk-dummy"} | ConvertTo-Json -Depth 5
```

---

## 🎯 Полезные команды

### Автозапуск при входе в систему:
```powershell
# Создать задачу в планировщике
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File D:\tools\ai\start-proxy-server.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName "CLIProxyAPIPlus" -Action $action -Trigger $trigger -RunLevel Highest
```

### Быстрый доступ к скриптам:
```powershell
# Добавьте алиасы в PowerShell профиль
notepad $PROFILE

# Добавьте в файл:
Set-Alias proxy-start "D:\tools\ai\start-proxy-server.ps1"
Set-Alias proxy-stop "D:\tools\ai\stop-proxy-server.ps1"
Set-Alias proxy-login "D:\tools\ai\batch-oauth-login.ps1"
```

---

## 📞 Полезные ссылки

- GitHub: https://github.com/router-for-me/CLIProxyAPIPlus
- Документация: https://deepwiki.com/router-for-me/CLIProxyAPIPlus
- Доступные провайдеры: D:\tools\ai\available-providers.md
- Ярлыки на рабочем столе: %USERPROFILE%\Desktop\AI\

---

**Автор:** GitHub Copilot CLI Assistant
**Дата создания:** 2026-02-02
**Версия:** 1.0
