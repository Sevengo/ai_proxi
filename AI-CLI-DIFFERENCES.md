# ⚠️ ВАЖНО: Особенности работы с разными AI CLI

## Claude CLI vs GitHub Copilot CLI

### 🎯 Claude CLI (РЕКОМЕНДУЕТСЯ для выбора модели)

**Поддерживает выбор модели через прокси:**
- ✅ Можно выбрать любую модель (Gemini, GPT-5, Claude, Qwen и т.д.)
- ✅ Работает через переменные окружения
- ✅ Полная гибкость

**Пример:**
```powershell
# Claude CLI с Gemini Flash
D:\tools\ai\launch-ai.ps1 -Tool claude -Provider gemini -Model "gemini-2.0-flash-exp"

# Использование:
claude "your question"
```

---

### 🔧 GitHub Copilot CLI (Ограничения)

**Особенности:**
- ⚠️ **НЕ поддерживает выбор конкретной модели**
- ⚠️ Copilot сам выбирает модель (обычно GPT-4 или GPT-3.5-turbo)
- ⚠️ Параметр `-Model` игнорируется
- ✅ Хорош для команд терминала (suggest/explain)

**Пример:**
```powershell
# Copilot CLI (модель выбирается автоматически)
D:\tools\ai\launch-ai.ps1 -Tool copilot -Provider copilot

# Использование:
gh copilot suggest "find large files"
gh copilot explain "git rebase"
```

---

## 💡 Когда что использовать

### Используйте Claude CLI когда:
- ✅ Нужна конкретная модель (Gemini, GPT-5, Claude Sonnet и т.д.)
- ✅ Работаете с кодом, текстом, анализом
- ✅ Нужна максимальная гибкость
- ✅ Хотите использовать бесплатные модели (Gemini)

**Примеры задач:**
```bash
claude "Explain this code" < script.py
claude "Write a Python web scraper"
claude "Review this SQL query" < query.sql
claude "Generate API documentation"
```

---

### Используйте GitHub Copilot CLI когда:
- ✅ Нужна помощь с командами терминала
- ✅ Хотите объяснение сложных команд
- ✅ Работаете с git, docker, kubectl и т.д.

**Примеры задач:**
```bash
gh copilot suggest "backup database to S3"
gh copilot suggest "compress all images in folder"
gh copilot explain "docker-compose up -d --scale web=3"
gh copilot explain "kubectl get pods -A"
```

---

## 🚀 Рекомендации

### Для большинства задач:
**Используйте ярлык "Claude + Gemini Flash"**
- ⚡ Быстро
- 💰 Бесплатно
- 🎯 Универсально
- ✅ Покрывает 90% задач

### Для команд терминала:
**Используйте ярлык "Copilot + GPT-5"**
- 💻 Специализация на командах
- 🤖 Интеграция с GitHub
- 📚 База знаний CLI команд

### Для сложных задач:
**Используйте ярлык "Claude + GPT-5"**
- 🧠 Умная модель
- 🆕 Новейшие возможности
- 📝 Детальные ответы

---

## 📋 Сравнительная таблица

| Функция | Claude CLI | Copilot CLI |
|---------|-----------|-------------|
| **Выбор модели** | ✅ Да | ❌ Нет |
| **Gemini** | ✅ Да | ❌ Нет |
| **GPT-5** | ✅ Да | ~Автоматически |
| **Claude** | ✅ Да | ~Автоматически |
| **Работа с кодом** | ✅ Отлично | ✅ Хорошо |
| **Терминальные команды** | ⚠️ Нормально | ✅ Отлично |
| **Интерактивный режим** | ✅ Да | ✅ Да |
| **Прямые запросы** | ✅ Да | ✅ Да |
| **Через прокси** | ✅ Да | ✅ Да |

---

## 🎯 Практические примеры

### Задача: Сгенерировать код

**✅ РЕКОМЕНДУЕТСЯ - Claude CLI:**
```powershell
# Запустить ярлык "Claude + Gemini Flash"
claude "Write a Python function to parse JSON with error handling"
```

**⚠️ НЕ РЕКОМЕНДУЕТСЯ - Copilot CLI:**
```powershell
# Copilot предназначен для команд, не для генерации кода
gh copilot suggest "Write a Python function..."  # Не лучший вариант
```

---

### Задача: Найти команду для задачи

**✅ РЕКОМЕНДУЕТСЯ - Copilot CLI:**
```powershell
# Запустить ярлык "Copilot + GPT-5"
gh copilot suggest "find all files larger than 1GB and delete them"
```

**✅ ТОЖЕ ХОРОШО - Claude CLI:**
```powershell
# Запустить ярлык "Claude + Gemini Flash"
claude "Give me a bash command to find all files larger than 1GB"
```

---

### Задача: Объяснить команду

**✅ ОТЛИЧНО - Copilot CLI:**
```powershell
gh copilot explain "kubectl apply -f deployment.yaml --dry-run=client"
```

**✅ ТОЖЕ ХОРОШО - Claude CLI:**
```powershell
claude "Explain this command: kubectl apply -f deployment.yaml --dry-run=client"
```

---

## 🔧 Исправление для скрипта

Обновленный скрипт `launch-ai.ps1` теперь:
- ✅ Предупреждает о невозможности выбора модели в Copilot CLI
- ✅ Предлагает использовать Claude CLI для выбора конкретной модели
- ✅ Добавлен интерактивный режим для Copilot CLI
- ✅ Упрощен ввод команд (не нужно писать `gh copilot`)

---

## 💡 Pro Tips

1. **Для быстрых вопросов** → Claude + Gemini Flash
2. **Для терминальных команд** → Copilot CLI
3. **Для сложного кода** → Claude + GPT-5
4. **Для ревью кода** → Claude + Claude Sonnet

---

**Вывод:** Используйте Claude CLI для максимальной гибкости и выбора модели. Используйте Copilot CLI для помощи с терминальными командами. 🚀
