# Интеграция CLI Proxy API Plus с Claude CLI и GitHub Copilot CLI

## 🎯 Цель
Настроить Claude CLI и GitHub Copilot CLI для работы через локальный прокси-сервер CLI Proxy API Plus, что позволяет использовать различные AI модели (Gemini, GPT, Claude и др.) через единый интерфейс.

---

## 📋 Предварительные требования

✅ **Выполнено:**
- CLI Proxy API Plus установлен в C:\Users\s.semihod\bin\
- Сервер запущен на http://localhost:8317
- Авторизованы провайдеры: Gemini, GitHub Copilot
- Созданы скрипты настройки в C:\tools\

⚠️ **Необходимо установить (если ещё нет):**
- Claude CLI (Anthropic CLI)
- GitHub CLI с Copilot extension

---

## 1️⃣ Установка Claude CLI

### Если Claude CLI еще не установлен:

#### Через NPM:
```powershell
npm install -g @anthropic-ai/claude-cli
```

#### Или через скачивание бинарника:
```powershell
# Скачайте с официального сайта Anthropic
# https://docs.anthropic.com/claude/docs/claude-cli
```

### Проверка установки:
```powershell
claude --version
```

---

## 2️⃣ Настройка Claude CLI для работы через прокси

### Автоматическая настройка:
```powershell
C:\tools\claude-proxy-setup.ps1
```

### Ручная настройка:
```powershell
# Установить переменные окружения для текущего пользователя
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_URL", "http://localhost:8317/v1", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-dummy", "User")

# Для текущей сессии
$env:ANTHROPIC_API_URL = "http://localhost:8317/v1"
$env:ANTHROPIC_API_KEY = "sk-dummy"
```

### Проверка настройки:
```powershell
# Проверить переменные
$env:ANTHROPIC_API_URL
$env:ANTHROPIC_API_KEY

# Должно вывести:
# http://localhost:8317/v1
# sk-dummy
```

---

## 3️⃣ Использование Claude CLI

### После настройки Claude CLI будет использовать прокси автоматически:

```powershell
# Простой запрос
claude "Объясни квантовые вычисления простыми словами"

# Интерактивный режим
claude chat

# Работа с файлами
claude "Проанализируй этот код" --file script.py

# Указать конкретную модель через прокси
claude "Hello" --model claude-3-5-sonnet-20241022
```

### Примеры использования:

```powershell
# Генерация кода
claude "Создай Python скрипт для парсинга CSV файла"

# Рефакторинг
claude "Оптимизируй этот код" --file app.js

# Объяснение
claude "Объясни что делает эта функция" --file utils.py

# Перевод
claude "Переведи этот текст на английский" --file document.txt
```

---

## 4️⃣ Установка GitHub Copilot CLI

### Если GitHub CLI еще не установлен:

#### Через winget:
```powershell
winget install --id GitHub.cli
```

#### Через установщик:
```powershell
# Скачайте с https://cli.github.com/
```

### Установка расширения Copilot:
```powershell
gh auth login
gh extension install github/gh-copilot
```

### Проверка установки:
```powershell
gh copilot --version
```

---

## 5️⃣ Настройка GitHub Copilot CLI для работы через прокси

### Автоматическая настройка:
```powershell
C:\tools\copilot-proxy-setup.ps1
```

### Ручная настройка:
```powershell
# Установить переменные окружения
[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_API_BASE_URL", "http://localhost:8317", "User")
[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_TOKEN", "sk-dummy", "User")

# Для текущей сессии
$env:GITHUB_COPILOT_API_BASE_URL = "http://localhost:8317"
$env:GITHUB_COPILOT_TOKEN = "sk-dummy"
```

### Проверка настройки:
```powershell
$env:GITHUB_COPILOT_API_BASE_URL
$env:GITHUB_COPILOT_TOKEN
```

---

## 6️⃣ Использование GitHub Copilot CLI

### Основные команды:

```powershell
# Предложить команду
gh copilot suggest "найти все файлы больше 100MB"

# Объяснить команду
gh copilot explain "git rebase -i HEAD~3"

# Интерактивный режим
gh copilot
```

### Примеры использования:

```powershell
# Системные команды
gh copilot suggest "показать использование диска"
gh copilot suggest "найти процессы использующие порт 8080"

# Git команды
gh copilot suggest "отменить последний коммит"
gh copilot suggest "создать новую ветку и переключиться на неё"

# PowerShell команды
gh copilot suggest "получить список служб Windows"
gh copilot suggest "экспортировать данные в CSV"

# Объяснения
gh copilot explain "docker-compose up -d"
gh copilot explain "SELECT * FROM users WHERE created_at > NOW() - INTERVAL 7 DAY"
```

---

## 7️⃣ Использование различных моделей

Прокси поддерживает множество моделей. Проверьте доступные:

```powershell
C:\tools\proxy.ps1 -Models
```

### Доступные модели (примеры):

**Google Gemini:**
- gemini-2.0-flash-exp
- gemini-1.5-pro
- gemini-exp-1206

**OpenAI (через GitHub Copilot):**
- gpt-5.2
- gpt-5
- gpt-4o

**Claude (после авторизации):**
- claude-3-5-sonnet-20241022
- claude-3-opus-20240229

---

## 8️⃣ Тестирование интеграции

### Тест Claude CLI:
```powershell
# Убедитесь что сервер запущен
C:\tools\proxy.ps1 -Status

# Простой тест
claude "Скажи привет"

# Если работает - вы увидите ответ от AI
```

### Тест Copilot CLI:
```powershell
# Простой тест
gh copilot suggest "вывести текущее время"

# Если работает - вы увидите предложенную команду
```

### Тест API напрямую:
```powershell
# Тест Gemini через OpenAI-compatible endpoint
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{
    "model": "gemini-2.0-flash-exp",
    "messages": [{"role": "user", "content": "Привет!"}]
  }'
```

---

## 9️⃣ Решение проблем

### Claude CLI не подключается:

1. **Проверьте сервер:**
```powershell
C:\tools\proxy.ps1 -Status
```

2. **Проверьте переменные окружения:**
```powershell
$env:ANTHROPIC_API_URL
$env:ANTHROPIC_API_KEY
```

3. **Переустановите настройки:**
```powershell
C:\tools\claude-proxy-setup.ps1
```

4. **Перезапустите терминал** для применения изменений

### Copilot CLI не работает:

1. **Проверьте авторизацию GitHub Copilot:**
```powershell
Get-ChildItem "C:\Users\s.semihod\.cli-proxy-api" -Filter "github-copilot*.json"
```

2. **Переавторизуйтесь если нужно:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --github-copilot-login
```

3. **Проверьте переменные:**
```powershell
$env:GITHUB_COPILOT_API_BASE_URL
$env:GITHUB_COPILOT_TOKEN
```

### Сервер не отвечает:

```powershell
# Перезапустите сервер
C:\tools\proxy.ps1 -Restart

# Или вручную
C:\tools\stop-proxy-server.ps1
C:\tools\start-proxy-server.ps1
```

---

## 🔟 Дополнительная настройка

### Автозапуск сервера при входе:

```powershell
# Создать задачу в планировщике
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle Hidden -File C:\tools\start-proxy-server.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
Register-ScheduledTask -TaskName "CLIProxyAPIPlus" -Action $action -Trigger $trigger -Description "Auto-start CLI Proxy API Plus on login"
```

### Добавить алиасы в PowerShell профиль:

```powershell
# Откройте профиль
notepad $PROFILE

# Добавьте (или скопируйте из C:\tools\powershell-aliases.ps1):
function proxy { C:\tools\proxy.ps1 @args }
function proxy-start { C:\tools\start-proxy-server.ps1 }
function proxy-stop { C:\tools\stop-proxy-server.ps1 }

# Сохраните и перезагрузите:
. $PROFILE
```

### Настройка конфигурации прокси:

```powershell
notepad C:\Users\s.semihod\.cli-proxy-api\config.yaml
```

Основные параметры:
- `port: 8317` - порт сервера
- `api-keys` - список API ключей для доступа
- `quota-exceeded.switch-project: true` - автопереключение проектов при превышении квоты
- `request-retry: 3` - количество попыток при ошибке

---

## 📊 Мониторинг использования

### Проверка статуса:
```powershell
proxy -Status
```

### Проверка доступных моделей:
```powershell
proxy -Models
```

### Тест подключения:
```powershell
proxy -Test
```

---

## 🎓 Полезные команды

```powershell
# Управление сервером
proxy -Start           # Запустить
proxy -Stop            # Остановить
proxy -Restart         # Перезапустить
proxy -Status          # Статус

# Информация
proxy -Models          # Список моделей
proxy -Test            # Тест API
proxy -Help            # Справка

# Авторизация
proxy -Login           # Интерактивное меню логина

# Настройка CLI
C:\tools\claude-proxy-setup.ps1    # Настроить Claude CLI
C:\tools\copilot-proxy-setup.ps1   # Настроить Copilot CLI
```

---

## 📚 Дополнительные ресурсы

- **Основная документация:** C:\tools\README.md
- **Список провайдеров:** C:\tools\available-providers.md
- **Алиасы PowerShell:** C:\tools\powershell-aliases.ps1
- **GitHub проекта:** https://github.com/router-for-me/CLIProxyAPIPlus

---

## ✅ Чеклист успешной настройки

- [ ] Сервер CLI Proxy API Plus запущен
- [ ] Авторизован хотя бы один провайдер (Gemini/Copilot/Claude)
- [ ] Claude CLI установлен (если планируется использовать)
- [ ] GitHub Copilot CLI установлен (если планируется использовать)
- [ ] Переменные окружения настроены (запущены скрипты setup)
- [ ] Тесты выполнены успешно
- [ ] Алиасы добавлены в PowerShell профиль (опционально)
- [ ] Автозапуск настроен (опционально)

---

**Версия:** 1.0  
**Дата:** 2026-02-02  
**Автор:** GitHub Copilot CLI Assistant
