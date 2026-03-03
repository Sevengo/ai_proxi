# 🔄 Переключение провайдеров через CLI Proxy API Plus

## Важное понимание

### GitHub Copilot CLI (`gh copilot`)
❌ **НЕ поддерживает выбор провайдера** - это официальный инструмент GitHub, который работает ТОЛЬКО с GitHub Copilot API. Переменные окружения `GITHUB_COPILOT_API_BASE_URL` перенаправляют запросы на прокси, но сам Copilot CLI всё равно запрашивает модели GitHub Copilot.

### Claude CLI
✅ **Поддерживает выбор провайдера** - Claude CLI использует переменные `ANTHROPIC_API_URL` и `ANTHROPIC_MODEL`, что позволяет выбирать любую модель через прокси.

### Вывод
**Для переключения провайдеров используйте Claude CLI, а не Copilot CLI!**

---

## 🎯 Как работает прокси

CLI Proxy API Plus предоставляет **OpenAI-совместимый API**:
- URL: `http://localhost:8317/v1`
- Поддерживает эндпоинты: `/v1/chat/completions`, `/v1/models`, `/v1/messages`

Любой инструмент, поддерживающий OpenAI API, может работать через прокси с ЛЮБЫМ авторизованным провайдером!

---

## 🔧 Способы использования разных провайдеров

### 1. Через Claude CLI (РЕКОМЕНДУЕТСЯ)

```powershell
# Gemini
D:\tools\ai\claude-interactive.ps1 -Model "gemini-2.0-flash-exp" -Provider gemini -AutoStart

# GPT-5 через Copilot
D:\tools\ai\claude-interactive.ps1 -Model "gpt-5.2" -Provider copilot -AutoStart

# Claude через Copilot
D:\tools\ai\claude-interactive.ps1 -Model "claude-sonnet-4.5" -Provider copilot -AutoStart

# Qwen
D:\tools\ai\claude-interactive.ps1 -Model "qwen-max" -Provider qwen -AutoStart
```

### 2. Через прямые API запросы (curl/Invoke-RestMethod)

```powershell
# Gemini
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{"model":"gemini-2.0-flash-exp","messages":[{"role":"user","content":"Hello"}]}'

# GPT-5
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{"model":"gpt-5.2","messages":[{"role":"user","content":"Hello"}]}'

# Qwen
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{"model":"qwen-max","messages":[{"role":"user","content":"Hello"}]}'
```

---

## 🖥️ VS Code - Настройка работы через прокси

### Вариант 1: Расширение "Continue" (РЕКОМЕНДУЕТСЯ)

**Установка:**
1. Откройте VS Code
2. Extensions → Найдите "Continue"
3. Установите

**Настройка (`~/.continue/config.json`):**
```json
{
  "models": [
    {
      "title": "Gemini Flash (Proxy)",
      "provider": "openai",
      "model": "gemini-2.0-flash-exp",
      "apiBase": "http://localhost:8317/v1",
      "apiKey": "sk-dummy"
    },
    {
      "title": "GPT-5 (Proxy)",
      "provider": "openai",
      "model": "gpt-5.2",
      "apiBase": "http://localhost:8317/v1",
      "apiKey": "sk-dummy"
    },
    {
      "title": "Claude Sonnet (Proxy)",
      "provider": "openai",
      "model": "claude-sonnet-4.5",
      "apiBase": "http://localhost:8317/v1",
      "apiKey": "sk-dummy"
    },
    {
      "title": "Qwen Max (Proxy)",
      "provider": "openai",
      "model": "qwen-max",
      "apiBase": "http://localhost:8317/v1",
      "apiKey": "sk-dummy"
    }
  ],
  "tabAutocompleteModel": {
    "title": "Gemini Flash",
    "provider": "openai",
    "model": "gemini-2.0-flash-exp",
    "apiBase": "http://localhost:8317/v1",
    "apiKey": "sk-dummy"
  }
}
```

### Вариант 2: Расширение "CodeGPT"

**Настройка в VS Code settings.json:**
```json
{
  "codegpt.apiKey": "sk-dummy",
  "codegpt.model": "gemini-2.0-flash-exp",
  "codegpt.baseUrl": "http://localhost:8317/v1"
}
```

### Вариант 3: Расширение "Cody" (Sourcegraph)

**Настройка:**
```json
{
  "cody.serverEndpoint": "http://localhost:8317",
  "cody.accessToken": "sk-dummy"
}
```

### Вариант 4: GitHub Copilot через прокси

⚠️ **Ограничение:** GitHub Copilot extension в VS Code НЕ поддерживает переключение на другие провайдеры. Он всегда использует модели GitHub Copilot.

Но если прокси настроен, Copilot будет использовать модели через прокси (те, что доступны через GitHub Copilot аккаунт).

---

## ✅ Как проверить работу через прокси

### 1. Проверить доступные модели:
```powershell
# Все модели через прокси
Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers @{"Authorization"="Bearer sk-dummy"} | 
  Select-Object -ExpandProperty data | 
  Select-Object id | 
  Sort-Object id
```

### 2. Тестовый запрос к конкретной модели:
```powershell
# Тест Gemini
$body = @{
    model = "gemini-2.0-flash-exp"
    messages = @(@{role="user"; content="Say hello in one word"})
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8317/v1/chat/completions" `
    -Method POST `
    -Headers @{"Authorization"="Bearer sk-dummy"; "Content-Type"="application/json"} `
    -Body $body | 
    Select-Object -ExpandProperty choices | 
    Select-Object -ExpandProperty message | 
    Select-Object content
```

### 3. Скрипт для тестирования всех провайдеров:
```powershell
D:\tools\ai\test-providers.ps1
```

---

## 📊 Сравнение возможностей

| Инструмент | Выбор модели | Выбор провайдера | Работает через прокси |
|------------|--------------|------------------|----------------------|
| **Claude CLI** | ✅ Да | ✅ Да | ✅ Да |
| **gh copilot** | ❌ Нет | ❌ Нет | ⚠️ Только Copilot модели |
| **curl/API** | ✅ Да | ✅ Да | ✅ Да |
| **Continue (VS Code)** | ✅ Да | ✅ Да | ✅ Да |
| **CodeGPT (VS Code)** | ✅ Да | ✅ Да | ✅ Да |
| **Copilot (VS Code)** | ❌ Нет | ❌ Нет | ⚠️ Только Copilot модели |

---

## 🎯 Рекомендации

1. **Для CLI работы:** Используйте **Claude CLI** с разными моделями
2. **Для VS Code:** Используйте **Continue** расширение
3. **Для автоматизации:** Используйте **прямые API запросы**

**Главное:** Выбор модели происходит в параметре `model` запроса, а не в CLI инструменте!

---

## 💡 Быстрое переключение провайдеров

Используйте готовые ярлыки в `Desktop\AI\CLI\`:
- **[1] Claude - Gemini Flash** → Google Gemini
- **[2] Claude - Gemini Pro** → Google Gemini Pro
- **[3] Claude - GPT-5** → OpenAI GPT-5 через Copilot
- **[4] Claude - Claude Sonnet** → Anthropic Claude через Copilot
- **[5] Claude - GPT-5 Codex** → OpenAI Codex через Copilot

Каждый ярлык автоматически настраивает нужную модель!
