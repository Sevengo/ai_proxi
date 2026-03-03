# 🚀 Как запустить GitHub Copilot CLI через прокси

## Способ 1: Через готовый ярлык (САМЫЙ ПРОСТОЙ)

1. Откройте папку: `Desktop\AI\CLI\`
2. Запустите ярлык: **"Copilot + GPT-5"**
3. Готово! Copilot уже настроен на прокси

---

## Способ 2: Через лаунчер

```powershell
D:\tools\ai\launch-ai.ps1 -Tool copilot -Provider copilot
```

Лаунчер автоматически:
- ✅ Запустит прокси (если не запущен)
- ✅ Настроит переменные окружения
- ✅ Запустит интерактивный режим Copilot

---

## Способ 3: Вручную (для понимания как это работает)

### Шаг 1: Запустить прокси сервер
```powershell
D:\tools\ai\start-proxy-server.ps1
```

### Шаг 2: Установить переменные окружения
```powershell
$env:GITHUB_COPILOT_API_BASE_URL = "http://localhost:8317"
$env:GITHUB_COPILOT_TOKEN = "sk-dummy"
```

### Шаг 3: Использовать Copilot
```powershell
# Предложить команду
gh copilot suggest "find large files"

# Объяснить команду
gh copilot explain "git rebase -i HEAD~5"
```

---

## Способ 4: Постоянная настройка (работает всегда)

### Для текущего пользователя (рекомендуется):

```powershell
# Выполните один раз:
[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_API_BASE_URL", "http://localhost:8317", "User")
[Environment]::SetEnvironmentVariable("GITHUB_COPILOT_TOKEN", "sk-dummy", "User")
```

Или используйте готовый скрипт:
```powershell
D:\tools\ai\copilot-proxy-setup.ps1
```

После этого **перезапустите PowerShell** и Copilot всегда будет работать через прокси!

---

## Проверка настройки

### 1. Проверить переменные окружения:
```powershell
Write-Host "API URL: $env:GITHUB_COPILOT_API_BASE_URL"
Write-Host "Token: $env:GITHUB_COPILOT_TOKEN"
```

**Должно вывести:**
```
API URL: http://localhost:8317
Token: sk-dummy
```

### 2. Проверить прокси:
```powershell
D:\tools\ai\proxy.ps1 -Status
```

**Должно показать:**
```
Статус:  ✓ Запущен
URL:     http://localhost:8317
```

### 3. Протестировать Copilot:
```powershell
gh copilot suggest "list all running processes"
```

---

## Примеры использования

### Базовое использование:

```powershell
# Получить команду для задачи
gh copilot suggest "find all files larger than 1GB"

# Объяснить сложную команду
gh copilot explain "docker-compose up -d --scale web=3"

# Объяснить git команду
gh copilot explain "git rebase -i HEAD~5"

# Найти команду для Docker
gh copilot suggest "stop all running containers"

# Найти команду для Kubernetes
gh copilot suggest "list all pods in all namespaces"
```

---

## Интерактивный режим (через лаунчер)

```powershell
D:\tools\ai\launch-ai.ps1 -Tool copilot -Provider copilot
```

В интерактивном режиме можно вводить команды без префикса `gh copilot`:

```
copilot> suggest find large files
copilot> explain git rebase
copilot> suggest compress images
copilot> exit
```

---

## Автоматизация в скриптах

```powershell
# Скрипт example.ps1

# Настроить окружение для Copilot
$env:GITHUB_COPILOT_API_BASE_URL = "http://localhost:8317"
$env:GITHUB_COPILOT_TOKEN = "sk-dummy"

# Получить команду
$command = gh copilot suggest "backup MySQL database" --format json | ConvertFrom-Json

# Выполнить команду
Invoke-Expression $command
```

---

## Решение проблем

### Проблема: "Copilot not authenticated"

**Решение:**
```powershell
# 1. Проверить переменные
$env:GITHUB_COPILOT_TOKEN

# 2. Если пусто, настроить:
D:\tools\ai\copilot-proxy-setup.ps1

# 3. Перезапустить PowerShell
```

### Проблема: "Connection refused"

**Решение:**
```powershell
# 1. Проверить прокси
D:\tools\ai\proxy.ps1 -Status

# 2. Запустить прокси
D:\tools\ai\start-proxy-server.ps1

# 3. Проверить порт
Test-NetConnection localhost -Port 8317
```

### Проблема: "gh: 'copilot' is not a gh command"

**Решение:**
```powershell
# Установить расширение
gh extension install github/gh-copilot

# Проверить установку
gh copilot --version
```

---

## Быстрые команды (добавьте в $PROFILE)

```powershell
# Открыть профиль
notepad $PROFILE

# Добавить алиасы:
function copilot-suggest { 
    $env:GITHUB_COPILOT_API_BASE_URL = "http://localhost:8317"
    $env:GITHUB_COPILOT_TOKEN = "sk-dummy"
    gh copilot suggest $args 
}

function copilot-explain { 
    $env:GITHUB_COPILOT_API_BASE_URL = "http://localhost:8317"
    $env:GITHUB_COPILOT_TOKEN = "sk-dummy"
    gh copilot explain $args 
}

# Использование:
copilot-suggest "find large files"
copilot-explain "git rebase"
```

---

## Сравнение со скриптом настройки

### Скрипт `copilot-proxy-setup.ps1`:
- ✅ Устанавливает переменные **постоянно** (для текущего пользователя)
- ✅ Работает после перезагрузки системы
- ✅ Один раз настроил - забыл

### Лаунчер `launch-ai.ps1`:
- ✅ Устанавливает переменные **временно** (только для текущей сессии)
- ✅ Автоматически запускает прокси
- ✅ Интерактивный режим с удобным вводом

### Рекомендация:
1. **Один раз выполните:** `D:\tools\ai\copilot-proxy-setup.ps1`
2. **Используйте всегда:** `gh copilot suggest/explain`

Или используйте ярлыки для быстрого доступа!

---

## ⚡ Быстрый старт (прямо сейчас)

```powershell
# Если прокси не запущен
D:\tools\ai\start-proxy-server.ps1

# Настроить Copilot (временно для этой сессии)
$env:GITHUB_COPILOT_API_BASE_URL = "http://localhost:8317"
$env:GITHUB_COPILOT_TOKEN = "sk-dummy"

# Использовать!
gh copilot suggest "find all files modified today"
```

---

## 📊 Проверка что все работает через прокси

```powershell
# 1. Проверить переменные
Write-Host "Base URL: $env:GITHUB_COPILOT_API_BASE_URL" -ForegroundColor Cyan
Write-Host "Token: $env:GITHUB_COPILOT_TOKEN" -ForegroundColor Cyan

# 2. Проверить прокси
Test-NetConnection localhost -Port 8317 -InformationLevel Detailed

# 3. Проверить модели через прокси
curl http://localhost:8317/v1/models -H "Authorization: Bearer sk-dummy" | ConvertFrom-Json | Select-Object -ExpandProperty data | Select-Object id

# 4. Запустить Copilot
gh copilot suggest "test command"
```

Если все шаги прошли успешно - Copilot работает через прокси! ✅

---

**Итог:** Самый простой способ - использовать ярлык **"Copilot + GPT-5"** из `Desktop\AI\CLI\` 🚀
