# 🚀 Руководство по использованию AI CLI Launcher

## Что это?

**AI CLI Launcher** - это удобный инструмент для запуска различных AI CLI (Claude, GitHub Copilot и др.) через **CLI Proxy API Plus** с автоматическим выбором провайдера и модели.

### Преимущества:
✅ Автоматически запускает прокси-сервер, если он не запущен  
✅ Настраивает переменные окружения для выбранного CLI  
✅ Позволяет выбирать провайдера и модель из меню  
✅ Готовые ярлыки для популярных комбинаций  
✅ Поддержка командной строки для автоматизации

---

## 📁 Расположение файлов

```
D:\tools\ai\
├── launch-ai.ps1                    # Главный скрипт-лаунчер
├── create-ai-cli-shortcuts.ps1      # Создание готовых ярлыков
└── AI-CLI-USAGE.md                  # Это руководство

%USERPROFILE%\Desktop\AI\CLI\        # Готовые ярлыки
├── AI Launcher (Menu).lnk           # Интерактивное меню
├── Claude + Gemini Flash.lnk        # Быстрая модель
├── Claude + Gemini Pro.lnk          # Умная модель
├── Claude + GPT-5.lnk               # Новейшая GPT
├── Claude + Claude Sonnet.lnk       # Родная Claude
├── Copilot + GPT-5.lnk              # GitHub Copilot
└── Claude + Qwen Max.lnk            # Китайская модель
```

---

## 🎯 Способы использования

### 1️⃣ Через готовые ярлыки (самый простой)

**Шаг 1:** Откройте папку `Desktop\AI\CLI\`

**Шаг 2:** Запустите нужный ярлык:
- **Claude + Gemini Flash** - быстрые ответы (рекомендуется для начала)
- **Claude + GPT-5** - новейшая модель от OpenAI
- **Claude + Claude Sonnet** - родная модель Claude
- **AI Launcher (Menu)** - выбрать вручную из меню

**Шаг 3:** Начните работать!

```
# Пример использования Claude CLI
claude "Explain quantum computing"
claude "Write a Python script to analyze logs"
```

---

### 2️⃣ Через интерактивное меню

**Запустите скрипт:**
```powershell
D:\tools\ai\launch-ai.ps1
```

**Следуйте меню:**

```
═══════════════════════════════════════════════
  Выбор CLI Инструмента
═══════════════════════════════════════════════

1) ✓ Claude CLI
2) ✓ GitHub Copilot CLI
3) ✗ Cursor (OpenAI API)

Выберите инструмент (1-3): 1

═══════════════════════════════════════════════
  Выбор Провайдера
═══════════════════════════════════════════════

1) Google Gemini      (рекомендуется)
2) GitHub Copilot     (GPT-5, Claude)
3) Claude             (требует авторизации)
4) Qwen               (требует авторизации)
5) Antigravity        (требует авторизации)

Выберите провайдера (1-5): 1

═══════════════════════════════════════════════
  Выбор Модели (gemini)
═══════════════════════════════════════════════

1) gemini-2.0-flash-exp
2) gemini-2.0-flash-thinking-exp
3) gemini-1.5-pro
4) gemini-exp-1206

0) Ввести вручную

Выберите модель (0-4): 1
```

---

### 3️⃣ Через командную строку (для автоматизации)

#### Базовое использование:
```powershell
# Claude + Gemini
D:\tools\ai\launch-ai.ps1 -Tool claude -Provider gemini -Model "gemini-2.0-flash-exp"

# Claude + GPT-5
D:\tools\ai\launch-ai.ps1 -Tool claude -Provider copilot -Model "gpt-5.2"

# Copilot CLI
D:\tools\ai\launch-ai.ps1 -Tool copilot -Provider copilot -Model "gpt-5.2"
```

#### С прямым запросом (без интерактивного режима):
```powershell
# Получить ответ на вопрос
D:\tools\ai\launch-ai.ps1 -Tool claude -Provider gemini -Model "gemini-2.0-flash-exp" -Prompt "Explain Docker"

# Сгенерировать код
D:\tools\ai\launch-ai.ps1 -Tool claude -Provider copilot -Model "gpt-5.2" -Prompt "Write a Python web scraper"
```

#### Дополнительные параметры:
```powershell
# Показать статус прокси
D:\tools\ai\launch-ai.ps1 -Status

# Показать список доступных моделей
D:\tools\ai\launch-ai.ps1 -List
```

---

## 📊 Рекомендации по выбору модели

### Для быстрых задач (код, вопросы):
- **gemini-2.0-flash-exp** ⚡ - самая быстрая и бесплатная
- **gpt-4.1** - быстрая от OpenAI

### Для сложных задач (архитектура, анализ):
- **gemini-1.5-pro** 🧠 - очень умная с большим контекстом
- **gpt-5.2** - новейшая от OpenAI
- **claude-sonnet-4.5** - отлично для кода и документации

### Для творческих задач:
- **claude-opus-4.5** 🎨 - самая креативная
- **gemini-2.0-flash-thinking-exp** - с цепочкой размышлений

### Для локальных/приватных задач:
- **qwen-max** 🇨🇳 - китайская модель, хороша для кода

---

## 💡 Примеры использования

### Пример 1: Быстрый вопрос через ярлык

1. Откройте ярлык **Claude + Gemini Flash**
2. Введите команду:
```
claude "How to fix git merge conflicts?"
```

### Пример 2: Работа с кодом

```powershell
# Запустить с GPT-5
D:\tools\ai\launch-ai.ps1 -Tool claude -Provider copilot -Model "gpt-5.2"

# В открывшемся Claude CLI:
claude "Review this Python code and suggest improvements"
```

### Пример 3: GitHub Copilot для команд

```powershell
# Запустить Copilot
D:\tools\ai\launch-ai.ps1 -Tool copilot -Provider copilot -Model "gpt-5.2"

# Использовать:
gh copilot suggest "find all files larger than 1GB"
gh copilot explain "git rebase -i HEAD~5"
```

### Пример 4: Автоматизация в скрипте

```powershell
# Создать скрипт analyze.ps1
$question = "Analyze this log file and find errors"
$result = D:\tools\ai\launch-ai.ps1 -Tool claude -Provider gemini -Model "gemini-1.5-pro" -Prompt $question

Write-Output $result
```

---

## 🔧 Установка CLI инструментов

### Claude CLI:
```powershell
npm install -g @anthropic-ai/claude-cli
```

### GitHub Copilot CLI:
```powershell
winget install --id GitHub.cli
gh extension install github/gh-copilot
```

---

## ⚙️ Настройка

### Создать новый ярлык с кастомной моделью:

1. Откройте скрипт:
```powershell
notepad D:\tools\ai\create-ai-cli-shortcuts.ps1
```

2. Добавьте свою комбинацию:
```powershell
New-AIShortcut `
    -Name "Claude + Моя Модель" `
    -Tool "claude" `
    -Provider "gemini" `
    -Model "gemini-exp-1206" `
    -Description "Описание"
```

3. Запустите скрипт:
```powershell
D:\tools\ai\create-ai-cli-shortcuts.ps1
```

---

## 🎨 Кастомизация

### Изменить прокси URL:
Отредактируйте в `launch-ai.ps1`:
```powershell
$proxyUrl = "http://localhost:8317"
```

### Добавить новый CLI инструмент:
Добавьте в секцию `$availableTools`:
```powershell
"mytool" = @{
    Name        = "My Tool"
    Command     = "mytool"
    EnvVars     = @{
        "MY_API_URL" = "$proxyUrl/v1"
        "MY_API_KEY" = "sk-dummy"
    }
    CheckCommand = "mytool --version"
    InstallHelp = "npm install -g my-tool"
}
```

---

## 📝 Часто задаваемые вопросы

### Q: Как узнать, какие модели доступны?
```powershell
D:\tools\ai\launch-ai.ps1 -List
```

### Q: Прокси не запускается автоматически
Запустите вручную:
```powershell
D:\tools\ai\start-proxy-server.ps1
```

### Q: Как сменить модель во время работы?
Перезапустите ярлык или установите переменную:
```powershell
$env:ANTHROPIC_MODEL = "gemini-1.5-pro"
```

### Q: Claude CLI не видит прокси
Проверьте переменные окружения:
```powershell
$env:ANTHROPIC_API_URL
$env:ANTHROPIC_API_KEY
```

### Q: Хочу использовать модель не из списка
Используйте параметр `-Model`:
```powershell
D:\tools\ai\launch-ai.ps1 -Tool claude -Provider gemini -Model "gemini-custom-model"
```

---

## 🚨 Решение проблем

### Ошибка: "CLI не установлен"
Установите нужный CLI (см. раздел "Установка CLI инструментов")

### Ошибка: "Прокси не отвечает"
1. Проверьте статус:
```powershell
D:\tools\ai\proxy.ps1 -Status
```

2. Перезапустите сервер:
```powershell
D:\tools\ai\stop-proxy-server.ps1
D:\tools\ai\start-proxy-server.ps1
```

### Ошибка: "Провайдер не авторизован"
Авторизуйтесь:
```powershell
D:\tools\ai\batch-oauth-login.ps1
```

---

## 📚 Дополнительные ресурсы

- **Полная документация**: `D:\tools\ai\README.md`
- **Быстрый старт**: `D:\tools\ai\QUICKSTART.md`
- **Шпаргалка**: `D:\tools\ai\CHEATSHEET.md`
- **Список провайдеров**: `D:\tools\ai\available-providers.md`

---

## 🎯 Полезные алиасы

Добавьте в PowerShell профиль (`notepad $PROFILE`):

```powershell
# Быстрый запуск AI
function ai { D:\tools\ai\launch-ai.ps1 @args }

# Быстрый Claude с Gemini
function claude-gemini { D:\tools\ai\launch-ai.ps1 -Tool claude -Provider gemini -Model "gemini-2.0-flash-exp" }

# Быстрый Claude с GPT-5
function claude-gpt5 { D:\tools\ai\launch-ai.ps1 -Tool claude -Provider copilot -Model "gpt-5.2" }

# Список моделей
function ai-models { D:\tools\ai\launch-ai.ps1 -List }

# Статус прокси
function ai-status { D:\tools\ai\launch-ai.ps1 -Status }
```

После перезагрузки профиля:
```powershell
. $PROFILE

# Теперь можно использовать:
claude-gemini
ai-models
ai-status
```

---

**Автор:** CLI Proxy API Plus Team  
**Дата:** 2026-02-02  
**Версия:** 1.0

Наслаждайтесь работой с AI! 🚀
