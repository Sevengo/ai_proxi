# ⚡ Быстрый старт - CLI Proxy API Plus

## ✅ Что уже сделано

- ✓ Сервер установлен и запущен на http://localhost:8317
- ✓ Авторизованы: Google Gemini (7 проектов) + GitHub Copilot
- ✓ Доступны 22 AI модели (GPT-5, Claude-4.5, Gemini-3 и др.)
- ✓ Созданы скрипты управления в D:\tools\ai\

## 🚀 Использование прямо сейчас

### Через API (работает сразу!)

```powershell
# Gemini
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{"model":"gemini-2.0-flash-exp","messages":[{"role":"user","content":"Привет!"}]}'

# GitHub Copilot (GPT-5)
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{"model":"gpt-5.2","messages":[{"role":"user","content":"Hello"}]}'
```

## 📝 Что нужно сделать дальше

### 1. Добавить больше провайдеров (5 минут)

```powershell
D:\tools\ai\batch-oauth-login.ps1
```

Выберите провайдеры для авторизации:
- Claude (Anthropic)
- Codex (OpenAI)
- Qwen (Alibaba)
- Kiro, Antigravity, iFlow

### 2. Настроить Claude CLI (если установлен)

```powershell
# Установить если нужно
npm install -g @anthropic-ai/claude-cli

# Настроить прокси
D:\tools\ai\claude-proxy-setup.ps1

# Использовать!
claude "Объясни квантовые вычисления"
```

### 3. Настроить GitHub Copilot CLI (если установлен)

```powershell
# Установить если нужно
winget install --id GitHub.cli
gh extension install github/gh-copilot

# Настроить прокси
D:\tools\ai\copilot-proxy-setup.ps1

# Использовать!
gh copilot suggest "найти большие файлы"
```

### 4. Добавить удобные алиасы

```powershell
# Открыть профиль
notepad $PROFILE

# Добавить строки:
function proxy { D:\tools\ai\proxy.ps1 @args }

# Сохранить и перезагрузить
. $PROFILE

# Теперь можно использовать:
proxy -Status
proxy -Models
proxy -Test
```

## 🎯 Полезные команды

```powershell
# Управление
D:\tools\ai\proxy.ps1 -Start      # Запустить сервер
D:\tools\ai\proxy.ps1 -Stop       # Остановить сервер
D:\tools\ai\proxy.ps1 -Status     # Проверить статус
D:\tools\ai\proxy.ps1 -Models     # Список моделей

# Авторизация
D:\tools\ai\batch-oauth-login.ps1 # Добавить провайдеры

# Настройка CLI
D:\tools\ai\claude-proxy-setup.ps1   # Claude CLI
D:\tools\ai\copilot-proxy-setup.ps1  # Copilot CLI
```

## 📚 Документация

- **D:\tools\ai\CHEATSHEET.md** - Шпаргалка команд
- **D:\tools\ai\README.md** - Полная документация
- **D:\tools\ai\INTEGRATION-GUIDE.md** - Интеграция с CLI
- **D:\tools\ai\available-providers.md** - Все провайдеры
- **%USERPROFILE%\Desktop\AI\** - Ярлыки на рабочем столе

## 🔧 Проверка работы

```powershell
# Проверить сервер
D:\tools\ai\proxy.ps1 -Status

# Проверить API
D:\tools\ai\proxy.ps1 -Test

# Список моделей
D:\tools\ai\proxy.ps1 -Models
```

## ❓ Помощь

Все команды и детали в документации:
```powershell
notepad D:\tools\ai\README.md
notepad D:\tools\ai\CHEATSHEET.md
```

---

**Сервер работает прямо сейчас!**  
Можете начинать использовать через API или настроить CLI инструменты.
