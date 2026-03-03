# 🚀 AI CLI - Быстрая шпаргалка

## Самый быстрый способ начать

### Через ярлык (РЕКОМЕНДУЕТСЯ):
1. Откройте `Desktop\AI\CLI\`
2. Запустите **Claude + Gemini Flash.lnk**
3. Введите: `claude "your question here"`

---

## Популярные команды

### Через готовые ярлыки:
```
Desktop\AI\CLI\
├── Claude + Gemini Flash    ← БЫСТРАЯ (рекомендуется)
├── Claude + GPT-5           ← НОВЕЙШАЯ
├── Claude + Claude Sonnet   ← РОДНАЯ CLAUDE
└── AI Launcher (Menu)       ← ВЫБОР ВРУЧНУЮ
```

### Через командную строку:

```powershell
# Интерактивное меню
D:\tools\ai\launch-ai.ps1

# С параметрами
D:\tools\ai\launch-ai.ps1 -Tool claude -Provider gemini -Model "gemini-2.0-flash-exp"

# Прямой вопрос (без интерактива)
D:\tools\ai\launch-ai.ps1 -Tool claude -Provider gemini -Model "gemini-2.0-flash-exp" -Prompt "Explain Docker"

# Статус прокси
D:\tools\ai\launch-ai.ps1 -Status

# Список моделей
D:\tools\ai\launch-ai.ps1 -List
```

---

## Примеры использования Claude CLI

```bash
# Простой вопрос
claude "What is Kubernetes?"

# Генерация кода
claude "Write a Python script to parse JSON"

# Анализ файла
claude "Analyze this log file" < error.log

# Ревью кода
claude "Review this code for security issues" < app.py

# Рефакторинг
claude "Refactor this function to be more efficient" < script.js

# Документация
claude "Generate API documentation for this code" < api.ts

# Дебаг
claude "Why is this code throwing an error?" < buggy.py

# Оптимизация
claude "Optimize this SQL query" < query.sql
```

---

## Примеры GitHub Copilot CLI

```bash
# Предложить команду
gh copilot suggest "find large files"
gh copilot suggest "compress all images in folder"
gh copilot suggest "backup database to S3"

# Объяснить команду
gh copilot explain "git rebase -i HEAD~5"
gh copilot explain "docker run -d -p 80:80 nginx"
gh copilot explain "kubectl get pods --all-namespaces"
```

---

## Выбор модели для задачи

| Задача | Рекомендуемая модель | Почему |
|--------|---------------------|--------|
| **Быстрые вопросы** | `gemini-2.0-flash-exp` | ⚡ Очень быстро |
| **Генерация кода** | `gpt-5.2-codex` или `claude-sonnet-4.5` | 💻 Специализация |
| **Сложный анализ** | `gemini-1.5-pro` или `gpt-5.2` | 🧠 Умные модели |
| **Ревью кода** | `claude-sonnet-4.5` | 📝 Детальные отзывы |
| **Творчество** | `claude-opus-4.5` | 🎨 Креативность |
| **Большой контекст** | `gemini-1.5-pro` | 📚 2M токенов |

---

## Настройка под себя

### Добавить алиасы в PowerShell:

```powershell
# Открыть профиль
notepad $PROFILE

# Добавить:
function ai { D:\tools\ai\launch-ai.ps1 @args }
function ai-gemini { D:\tools\ai\launch-ai.ps1 -Tool claude -Provider gemini -Model "gemini-2.0-flash-exp" }
function ai-gpt5 { D:\tools\ai\launch-ai.ps1 -Tool claude -Provider copilot -Model "gpt-5.2" }
function ai-models { D:\tools\ai\launch-ai.ps1 -List }

# Сохранить и перезагрузить
. $PROFILE

# Использовать:
ai-gemini
ai-gpt5
ai-models
```

---

## Автоматизация

### В PowerShell скриптах:

```powershell
# Простой пример
$answer = D:\tools\ai\launch-ai.ps1 `
    -Tool claude `
    -Provider gemini `
    -Model "gemini-2.0-flash-exp" `
    -Prompt "Summarize this: $text"

Write-Output $answer
```

### Пакетная обработка:

```powershell
# Обработать все файлы
Get-ChildItem *.py | ForEach-Object {
    $analysis = D:\tools\ai\launch-ai.ps1 `
        -Tool claude `
        -Provider gemini `
        -Model "gemini-1.5-pro" `
        -Prompt "Analyze this Python file for bugs" `
        < $_.FullName
    
    "$($_.Name): $analysis" | Out-File -Append analysis.txt
}
```

---

## Решение проблем

### Прокси не работает:
```powershell
D:\tools\ai\proxy.ps1 -Status
D:\tools\ai\start-proxy-server.ps1
```

### Claude не установлен:
```powershell
npm install -g @anthropic-ai/claude-cli
```

### Copilot не установлен:
```powershell
gh extension install github/gh-copilot
```

### Провайдер не авторизован:
```powershell
D:\tools\ai\batch-oauth-login.ps1
```

---

## Быстрые ссылки

- 📖 **Полное руководство**: `D:\tools\ai\AI-CLI-USAGE.md`
- 📚 **Документация прокси**: `D:\tools\ai\README.md`
- 🚀 **Быстрый старт**: `D:\tools\ai\QUICKSTART.md`
- 🔧 **Список провайдеров**: `D:\tools\ai\available-providers.md`

---

## Горячие комбинации

| Ярлык | Провайдер | Модель | Для чего |
|-------|-----------|--------|----------|
| **Claude + Gemini Flash** | Google | gemini-2.0-flash-exp | ⚡ Быстрые вопросы |
| **Claude + GPT-5** | Copilot | gpt-5.2 | 🆕 Новейшая модель |
| **Claude + Claude Sonnet** | Copilot | claude-sonnet-4.5 | 📝 Работа с кодом |
| **Claude + Gemini Pro** | Google | gemini-1.5-pro | 🧠 Сложные задачи |

---

**Pro Tip**: Начните с **Claude + Gemini Flash** - это быстро, бесплатно и покрывает 90% задач! 🚀
