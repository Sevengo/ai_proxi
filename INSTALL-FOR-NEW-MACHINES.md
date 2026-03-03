# ⚡ Быстрая установка CLI Proxy API Plus на новую машину

## 🎯 Для установки на другую машину:

### Вариант 1: Через интернет (быстрее всего)

```powershell
# 1. Установите предварительные требования
winget install GoLang.Go
winget install Git.Git

# 2. Перезапустите PowerShell

# 3. Запустите установщик
irm https://cdn.jsdelivr.net/gh/julianromli/CLIProxyAPIPlus-Easy-Installation@main/scripts/install-cliproxyapi.ps1 | iex

# 4. Создайте скрипты управления - скопируйте из C:\tools\ на эту машину
```

### Вариант 2: С USB флешки или сетевой папки

#### Что скопировать на флешку/в сетевую папку:

```
USBDrive:\CLIProxyAPIPlus\
├─ install-cliproxyapi-complete.ps1    # Установщик
└─ scripts\                             # Папка со скриптами
   ├─ proxy.ps1
   ├─ start-proxy-server.ps1
   ├─ stop-proxy-server.ps1
   ├─ claude-proxy-setup.ps1
   ├─ copilot-proxy-setup.ps1
   ├─ batch-oauth-login.ps1
   ├─ create-desktop-shortcuts.ps1
   ├─ powershell-aliases.ps1
   ├─ README.md
   ├─ QUICKSTART.md
   ├─ CHEATSHEET.md
   ├─ INTEGRATION-GUIDE.md
   ├─ INSTALL-GUIDE.md
   └─ available-providers.md
```

#### На новой машине:

```powershell
# 1. Установите Go и Git
winget install GoLang.Go
winget install Git.Git

# 2. Перезапустите PowerShell

# 3. Запустите установщик с флешки
& E:\CLIProxyAPIPlus\install-cliproxyapi-complete.ps1

# Установщик сам:
# - Скомпилирует CLI Proxy API Plus
# - Скопирует все скрипты в C:\tools\
# - Создаст ярлыки на рабочем столе
# - Запустит сервер
# - Предложит авторизовать провайдеры
```

### Вариант 3: Ручная установка

```powershell
# 1. Установите Go и Git (см. выше)

# 2. Скачайте и запустите базовый установщик
irm https://cdn.jsdelivr.net/gh/julianromli/CLIProxyAPIPlus-Easy-Installation@main/scripts/install-cliproxyapi.ps1 | iex

# 3. Скопируйте все скрипты из C:\tools\ с этой машины на новую

# 4. Запустите создание ярлыков
C:\tools\create-desktop-shortcuts.ps1

# 5. Авторизуйте провайдеры
C:\tools\batch-oauth-login.ps1
```

## 📋 Что нужно для установки:

### Минимальные требования:
- ✅ Windows 10/11
- ✅ PowerShell 5.1+
- ✅ Go 1.21+ (будет установлен)
- ✅ Git (будет установлен)
- ✅ Интернет (для скачивания и OAuth)

### Рекомендуемые:
- ✅ Claude CLI (для использования Claude)
- ✅ GitHub CLI + Copilot extension (для использования Copilot)

## 🚀 После установки:

```powershell
# Проверить статус
C:\tools\proxy.ps1 -Status

# Авторизовать провайдеры
C:\tools\batch-oauth-login.ps1

# Посмотреть модели
C:\tools\proxy.ps1 -Models

# Прочитать документацию
notepad C:\tools\QUICKSTART.md
```

## 💾 Подготовка USB флешки с установщиком

На текущей машине выполните:

```powershell
# 1. Создайте папку на флешке
$usbPath = "E:\CLIProxyAPIPlus"  # Измените E: на вашу флешку
New-Item -Path $usbPath -ItemType Directory -Force
New-Item -Path "$usbPath\scripts" -ItemType Directory -Force

# 2. Скопируйте установщик
Copy-Item "C:\tools\install-cliproxyapi-complete.ps1" $usbPath

# 3. Скопируйте все скрипты и документацию
Copy-Item "C:\tools\*.ps1" "$usbPath\scripts\"
Copy-Item "C:\tools\*.md" "$usbPath\scripts\"

# 4. Создайте README для быстрого старта
@"
УСТАНОВКА CLI PROXY API PLUS
=============================

1. Установите предварительные требования:
   winget install GoLang.Go
   winget install Git.Git

2. Перезапустите PowerShell

3. Запустите установщик:
   PowerShell -ExecutionPolicy Bypass -File install-cliproxyapi-complete.ps1

4. Следуйте инструкциям на экране

Документация: scripts\INSTALL-GUIDE.md
"@ | Out-File "$usbPath\README.txt" -Encoding UTF8

Write-Host "✓ USB флешка готова: $usbPath" -ForegroundColor Green
```

## 🔑 Важно!

**Токены OAuth НЕ переносятся автоматически!**

На каждой новой машине нужно:
1. Авторизоваться заново: `C:\tools\batch-oauth-login.ps1`
2. Или скопировать токены вручную из:
   ```
   C:\Users\<username>\.cli-proxy-api\*.json
   ```

## ⚡ Самый быстрый способ (если все уже установлено):

```powershell
# 1 команда - всё установится автоматически
irm https://cdn.jsdelivr.net/gh/julianromli/CLIProxyAPIPlus-Easy-Installation@main/scripts/install-cliproxyapi.ps1 | iex
```

Затем скопируйте скрипты и создайте ярлыки.

## 📞 Файлы на текущей машине:

Все необходимое находится в:
- **Установщик:** `C:\tools\install-cliproxyapi-complete.ps1`
- **Скрипты:** `C:\tools\*.ps1`
- **Документация:** `C:\tools\*.md`
- **Шаблон для USB:** см. скрипт выше

---

**Версия:** 1.0  
**Дата:** 2026-02-02  
**Для:** Установки на новые машины
