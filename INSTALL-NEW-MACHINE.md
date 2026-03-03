# 🚀 Быстрая установка CLI Proxy API Plus на новую машину

## Требования

- **Windows 10/11**
- **Git**: https://git-scm.com/download/win
- **Go 1.21+**: https://go.dev/dl/
- **PowerShell** (встроен в Windows)

## Установка за 2 минуты

### Вариант 1: Автоматическая установка (Рекомендуется)

1. **Откройте PowerShell от имени администратора**
   ```
   Win + X → "Windows PowerShell (Администратор)"
   ```

2. **Скачайте и запустите скрипт установки:**
   ```powershell
   # Если у вас есть доступ к D:\tools\ai\INSTALL-UNIVERSAL.ps1
   D:\tools\ai\INSTALL-UNIVERSAL.ps1
   
   # ИЛИ скачайте напрямую из репозитория
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/router-for-me/CLIProxyAPIPlus/main/install.ps1" -OutFile "$env:TEMP\install.ps1"
   & "$env:TEMP\install.ps1"
   ```

3. **Следуйте инструкциям скрипта**
   - Скрипт автоматически проверит зависимости
   - Склонирует репозиторий
   - Скомпилирует бинарный файл
   - Создаст конфигурацию
   - Создаст ярлыки на рабочем столе

4. **Готово!** Сервер запущен на http://localhost:8317

---

### Вариант 2: Ручная установка

#### Шаг 1: Установить зависимости

```powershell
# Git
winget install --id Git.Git -e --source winget

# Go
winget install --id GoLang.Go

# Перезапустите PowerShell после установки
```

#### Шаг 2: Клонировать репозиторий

```powershell
cd $env:USERPROFILE
git clone https://github.com/router-for-me/CLIProxyAPIPlus.git
```

#### Шаг 3: Скомпилировать

```powershell
# Создать папки
New-Item -Path "$env:USERPROFILE\bin" -ItemType Directory -Force
New-Item -Path "$env:USERPROFILE\.cli-proxy-api" -ItemType Directory -Force
New-Item -Path "D:\tools\ai" -ItemType Directory -Force

# Скомпилировать
cd "$env:USERPROFILE\CLIProxyAPIPlus"
go build -o "$env:USERPROFILE\bin\cliproxyapi-plus.exe" ./cmd/server
```

#### Шаг 4: Добавить в PATH

```powershell
$binPath = "$env:USERPROFILE\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", "$currentPath;$binPath", "User")
$env:Path += ";$binPath"
```

#### Шаг 5: Создать конфигурацию

```powershell
$config = @"
port: 8317
api-keys:
  - sk-dummy
incognito-browser: true
request-retry: 3
log-level: info
"@

$config | Out-File -FilePath "$env:USERPROFILE\.cli-proxy-api\config.yaml" -Encoding utf8
```

#### Шаг 6: Скопировать скрипты управления

```powershell
# Скопируйте файлы из D:\tools\ai\ на эту машину
# Или используйте скрипт INSTALL-UNIVERSAL.ps1 для автоматического создания
```

#### Шаг 7: Запустить сервер

```powershell
cliproxyapi-plus.exe --config "$env:USERPROFILE\.cli-proxy-api\config.yaml"
```

---

## После установки

### 1. Авторизовать провайдеров

```powershell
# Google Gemini
cliproxyapi-plus.exe --config "$env:USERPROFILE\.cli-proxy-api\config.yaml" --login

# GitHub Copilot
cliproxyapi-plus.exe --config "$env:USERPROFILE\.cli-proxy-api\config.yaml" --github-copilot-login

# Claude
cliproxyapi-plus.exe --config "$env:USERPROFILE\.cli-proxy-api\config.yaml" --claude-login

# Qwen
cliproxyapi-plus.exe --config "$env:USERPROFILE\.cli-proxy-api\config.yaml" --qwen-login

# Antigravity
cliproxyapi-plus.exe --config "$env:USERPROFILE\.cli-proxy-api\config.yaml" --antigravity-login
```

### 2. Настроить CLI инструменты (опционально)

#### Claude CLI:
```powershell
# Установить
npm install -g @anthropic-ai/claude-cli

# Настроить
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_URL", "http://localhost:8317/v1", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-dummy", "User")

# Использовать
claude "Explain quantum computing"
```

#### GitHub Copilot CLI:
```powershell
# Установить
winget install --id GitHub.cli
gh extension install github/gh-copilot

# Настроить
[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_API_BASE_URL", "http://localhost:8317", "User")
[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_TOKEN", "sk-dummy", "User")

# Использовать
gh copilot suggest "create a python script"
```

### 3. Проверить работу

```powershell
# Проверить процесс
Get-Process cliproxyapi-plus

# Проверить порт
Test-NetConnection localhost -Port 8317

# Проверить API
curl http://localhost:8317/v1/models -H "Authorization: Bearer sk-dummy"
```

---

## Использование

### Через API (OpenAI-compatible):

```powershell
# Gemini
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{"model":"gemini-2.0-flash-exp","messages":[{"role":"user","content":"Hello!"}]}'

# GPT-5 (через GitHub Copilot)
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{"model":"gpt-5.2","messages":[{"role":"user","content":"Hello!"}]}'

# Claude (после авторизации)
curl http://localhost:8317/v1/messages `
  -H "Content-Type: application/json" `
  -H "x-api-key: sk-dummy" `
  -H "anthropic-version: 2023-06-01" `
  -d '{"model":"claude-3-5-sonnet-20241022","max_tokens":1024,"messages":[{"role":"user","content":"Hello!"}]}'
```

---

## Структура после установки

```
C:\Users\{username}\
├── bin\
│   └── cliproxyapi-plus.exe         # Основной бинарник
├── .cli-proxy-api\
│   ├── config.yaml                  # Конфигурация
│   ├── gemini-*.json                # Токены провайдеров
│   ├── github-copilot-*.json
│   └── ...
└── CLIProxyAPIPlus\                 # Исходный код (для обновлений)

D:\tools\ai\                         # Скрипты управления
├── start-proxy-server.ps1
├── stop-proxy-server.ps1
├── claude-proxy-setup.ps1
├── copilot-proxy-setup.ps1
├── INSTALL-UNIVERSAL.ps1
└── README.md

%USERPROFILE%\Desktop\AI\            # Ярлыки
├── [01] Запустить сервер.lnk
├── [02] Остановить сервер.lnk
└── ...
```

---

## Обновление

```powershell
# Обновить исходный код
cd $env:USERPROFILE\CLIProxyAPIPlus
git pull

# Перекомпилировать
go build -o "$env:USERPROFILE\bin\cliproxyapi-plus.exe" ./cmd/server

# Перезапустить сервер
Stop-Process -Name cliproxyapi-plus -Force
cliproxyapi-plus.exe --config "$env:USERPROFILE\.cli-proxy-api\config.yaml"
```

---

## Автозапуск при входе в систему

```powershell
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle Hidden -File D:\tools\ai\start-proxy-server.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName "CLIProxyAPIPlus" -Action $action -Trigger $trigger -RunLevel Highest -Description "Запуск CLI Proxy API Plus при входе"
```

---

## Решение проблем

### Сервер не запускается
```powershell
# Проверить порт
netstat -ano | findstr :8317

# Убить процесс если нужно
Stop-Process -Name cliproxyapi-plus -Force
```

### OAuth не работает
```powershell
# Попробовать с флагом -incognito
cliproxyapi-plus.exe --config "$env:USERPROFILE\.cli-proxy-api\config.yaml" --login -incognito
```

### PATH не обновился
```powershell
# Перезапустите PowerShell или выполните:
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

---

## Полезные ссылки

- **GitHub**: https://github.com/router-for-me/CLIProxyAPIPlus
- **Документация**: https://deepwiki.com/router-for-me/CLIProxyAPIPlus

---

## Доступные модели

После авторизации провайдеров доступны:

### Google Gemini:
- `gemini-2.0-flash-exp`
- `gemini-2.0-flash-thinking-exp`
- `gemini-1.5-pro`
- `gemini-exp-1206`

### GitHub Copilot:
- `gpt-5.2`, `gpt-5.2-codex`
- `gpt-5.1`, `gpt-5.1-codex`, `gpt-5.1-codex-max`
- `gpt-5`, `gpt-5-mini`
- `gpt-4.1`, `gpt-4o`, `gpt-4o-mini`
- `o1-preview`, `o1-mini`
- `claude-sonnet-4.5`, `claude-opus-4.5`, `claude-haiku-4.5`

### Claude (требует авторизации):
- `claude-3-5-sonnet-20241022`
- `claude-3-5-haiku-20241022`
- `claude-3-opus-20240229`

### Qwen (требует авторизации):
- `qwen-max`, `qwen-plus`, `qwen-turbo`

### Antigravity (требует авторизации):
- Доступ к множеству моделей через единый интерфейс

---

**Автор:** s.semihod  
**Дата:** 2026-02-02  
**Версия:** 1.0
