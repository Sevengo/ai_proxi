# 🚀 CLI Proxy API Plus - Автоматическая установка на новые машины

## 📋 Что делает установщик

Этот скрипт автоматически выполняет полную установку и настройку CLI Proxy API Plus:

1. ✅ Проверяет предварительные требования (Go, Git)
2. ✅ Скачивает и компилирует CLI Proxy API Plus
3. ✅ Запускает сервер на порту 8317
4. ✅ Создает все необходимые скрипты управления
5. ✅ Предлагает авторизовать AI провайдеры
6. ✅ Создает ярлыки на рабочем столе
7. ✅ Настраивает автозапуск (опционально)

## 🎯 Предварительные требования

Перед запуском установите:

### Go (обязательно)
```powershell
winget install GoLang.Go
# Или скачайте: https://go.dev/dl/
```

### Git (обязательно)
```powershell
winget install Git.Git
# Или скачайте: https://git-scm.com/download/win
```

**После установки перезапустите PowerShell!**

## 🚀 Способ 1: Быстрая установка (одна команда)

```powershell
# Скачать и запустить установщик
irm https://your-url/install-cliproxyapi-complete.ps1 | iex
```

## 🚀 Способ 2: Скачать и запустить

```powershell
# 1. Скачать установщик
Invoke-WebRequest -Uri "https://your-url/install-cliproxyapi-complete.ps1" -OutFile "$env:TEMP\install-cliproxyapi.ps1"

# 2. Запустить
& "$env:TEMP\install-cliproxyapi.ps1"
```

## 🚀 Способ 3: С USB флешки или сетевой папки

```powershell
# Скопируйте установщик на флешку/сетевую папку, затем:
& "E:\install-cliproxyapi-complete.ps1"
```

## 📦 Что будет установлено

### Основные файлы:
```
C:\Users\<username>\bin\
  └─ cliproxyapi-plus.exe          # Основной исполняемый файл

C:\Users\<username>\.cli-proxy-api\
  ├─ config.yaml                    # Конфигурация
  └─ *.json                         # Токены авторизации провайдеров

C:\tools\
  ├─ proxy.ps1                      # Главное меню
  ├─ start-proxy-server.ps1         # Запуск сервера
  ├─ stop-proxy-server.ps1          # Остановка сервера
  ├─ claude-proxy-setup.ps1         # Настройка Claude CLI
  ├─ copilot-proxy-setup.ps1        # Настройка Copilot CLI
  ├─ batch-oauth-login.ps1          # OAuth авторизация
  ├─ create-desktop-shortcuts.ps1   # Создание ярлыков
  ├─ powershell-aliases.ps1         # Алиасы
  ├─ README.md                      # Полная документация
  ├─ QUICKSTART.md                  # Быстрый старт
  ├─ CHEATSHEET.md                  # Шпаргалка
  ├─ INTEGRATION-GUIDE.md           # Интеграция с CLI
  └─ available-providers.md         # Список провайдеров

Рабочий стол\AI\
  ├─ [01] Proxy - Управление.lnk
  ├─ [02] Запустить сервер.lnk
  ├─ [03] Остановить сервер.lnk
  ├─ [04] Перезапуск сервера.lnk
  ├─ [05] Авторизация провайдеров.lnk
  ├─ [06] Статус и модели.lnk
  ├─ [07] Настроить Claude CLI.lnk
  ├─ [08] Настроить Copilot CLI.lnk
  ├─ [09] Документация.lnk
  └─ [10] Шпаргалка команд.lnk
```

## 🎛️ Параметры установщика

```powershell
# Пропустить OAuth авторизацию
& install-cliproxyapi-complete.ps1 -SkipOAuth

# Пропустить создание ярлыков
& install-cliproxyapi-complete.ps1 -SkipDesktopShortcuts

# Пропустить автозапуск
& install-cliproxyapi-complete.ps1 -SkipAutostart

# Установить в другую папку
& install-cliproxyapi-complete.ps1 -InstallPath "D:\MyTools"

# Комбинация параметров
& install-cliproxyapi-complete.ps1 -SkipOAuth -InstallPath "D:\Tools"
```

## ⚡ После установки

### 1. Проверить статус
```powershell
C:\tools\proxy.ps1 -Status
```

### 2. Авторизовать провайдеры
```powershell
C:\tools\batch-oauth-login.ps1
```

Выберите провайдеры:
- Google Gemini (бесплатно, рекомендуется)
- GitHub Copilot (требует подписку)
- Claude (Anthropic)
- Qwen (Alibaba Cloud)
- Antigravity

### 3. Настроить CLI инструменты

**Claude CLI:**
```powershell
# Установить
npm install -g @anthropic-ai/claude-cli

# Настроить
C:\tools\claude-proxy-setup.ps1

# Использовать
claude "Привет!"
```

**GitHub Copilot CLI:**
```powershell
# Установить
winget install GitHub.cli
gh extension install github/gh-copilot

# Настроить
C:\tools\copilot-proxy-setup.ps1

# Использовать
gh copilot suggest "найти большие файлы"
```

### 4. Проверить доступные модели
```powershell
C:\tools\proxy.ps1 -Models
```

## 📚 Документация

После установки вся документация доступна в `C:\tools\`:
- **QUICKSTART.md** - Быстрый старт
- **README.md** - Полная инструкция
- **CHEATSHEET.md** - Шпаргалка команд
- **INTEGRATION-GUIDE.md** - Интеграция с CLI

## 🔧 Управление сервером

```powershell
# Через главное меню
C:\tools\proxy.ps1 -Status    # Статус
C:\tools\proxy.ps1 -Start     # Запустить
C:\tools\proxy.ps1 -Stop      # Остановить
C:\tools\proxy.ps1 -Restart   # Перезапустить
C:\tools\proxy.ps1 -Models    # Список моделей

# Или через отдельные скрипты
C:\tools\start-proxy-server.ps1
C:\tools\stop-proxy-server.ps1
```

## 🌐 Использование API

После установки сервер доступен по адресу: `http://localhost:8317`

### Пример запроса (Gemini):
```powershell
curl http://localhost:8317/v1/chat/completions `
  -H "Content-Type: application/json" `
  -H "Authorization: Bearer sk-dummy" `
  -d '{
    "model": "gemini-2.0-flash-exp",
    "messages": [{"role": "user", "content": "Привет!"}]
  }'
```

## ❓ Решение проблем

### Go или Git не найдены
```powershell
# Установите и перезапустите PowerShell
winget install GoLang.Go
winget install Git.Git
```

### Сервер не запускается
```powershell
# Проверьте, не занят ли порт 8317
netstat -ano | findstr :8317

# Остановите процесс если нужно
C:\tools\stop-proxy-server.ps1

# Перезапустите
C:\tools\start-proxy-server.ps1
```

### OAuth не работает
```powershell
# Попробуйте с incognito режимом
C:\Users\<username>\bin\cliproxyapi-plus.exe `
  --config C:\Users\<username>\.cli-proxy-api\config.yaml `
  --login -incognito
```

## 🔄 Обновление

Для обновления на новую версию:
```powershell
# Остановите сервер
C:\tools\stop-proxy-server.ps1

# Запустите установщик заново
& install-cliproxyapi-complete.ps1 -SkipOAuth -SkipDesktopShortcuts
```

## 📞 Полезные ссылки

- GitHub: https://github.com/router-for-me/CLIProxyAPIPlus
- Документация: https://deepwiki.com/router-for-me/CLIProxyAPIPlus
- Локальная документация: C:\tools\README.md

## ✅ Чеклист успешной установки

- [ ] Go и Git установлены
- [ ] Установщик выполнен без ошибок
- [ ] Сервер запущен (`C:\tools\proxy.ps1 -Status`)
- [ ] Порт 8317 отвечает
- [ ] Авторизован хотя бы один провайдер (Gemini рекомендуется)
- [ ] Ярлыки созданы на рабочем столе
- [ ] Тестовый запрос выполнен успешно

## 🎉 Готово!

После установки вы получаете:
- ✅ Локальный прокси-сервер для AI моделей
- ✅ Доступ к GPT-5, Claude-4.5, Gemini-3 и другим моделям
- ✅ Удобные ярлыки на рабочем столе
- ✅ Интеграцию с Claude CLI и Copilot CLI
- ✅ Полную документацию и скрипты управления

**Начните использовать прямо сейчас!** 🚀
