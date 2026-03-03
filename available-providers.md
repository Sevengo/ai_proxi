# CLI Proxy API Plus - Список доступных провайдеров для авторизации
# Создано: 2026-02-02

## Сервисы Google:

### 1. Google Gemini (основной Google аккаунт)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --login
```
**Описание:** Доступ к Google Gemini AI через OAuth
**Модели:** gemini-pro, gemini-1.5-pro, gemini-2.0-flash и др.

### 2. Google Vertex AI (импорт service account)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --vertex-import "path\to\service-account-key.json"
```
**Описание:** Импорт ключа сервисного аккаунта Google Cloud для Vertex AI
**Требует:** JSON файл service account key из Google Cloud Console

### 3. Kiro (Google OAuth)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --kiro-google-login
# или
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --kiro-login
```
**Описание:** Kiro AI через Google OAuth

---

## Другие провайдеры:

### 4. GitHub Copilot ✓ (УЖЕ НАСТРОЕН)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --github-copilot-login
```
**Статус:** ✓ Авторизован как Sevengo

### 5. Claude (Anthropic)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --claude-login
```
**Описание:** Claude AI через OAuth
**Модели:** claude-3.5-sonnet, claude-3-opus и др.

### 6. Codex (OpenAI)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --codex-login
```
**Описание:** OpenAI Codex через OAuth

### 7. Qwen (Alibaba Cloud)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --qwen-login
```
**Описание:** Qwen AI через OAuth

### 8. Antigravity
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --antigravity-login
```
**Описание:** Antigravity AI через OAuth

### 9. iFlow (OAuth)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --iflow-login
```
**Описание:** iFlow AI через OAuth

### 10. iFlow (Cookie-based)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --iflow-cookie
```
**Описание:** iFlow AI через Cookie (альтернативный метод)

### 11. Kiro (AWS Builder ID - Device Code)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --kiro-aws-login
```
**Описание:** Kiro через AWS Builder ID (device code flow)

### 12. Kiro (AWS Builder ID - Auth Code - Рекомендуется)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --kiro-aws-authcode
```
**Описание:** Kiro через AWS Builder ID (лучший UX)

### 13. Kiro (Import from Kiro IDE)
**Команда:**
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --kiro-import
```
**Описание:** Импорт токена из Kiro IDE (~/.aws/sso/cache/kiro-auth-token.json)

---

## Дополнительные опции:

### Incognito Mode (для нескольких аккаунтов)
Добавьте флаг `-incognito` к любой команде логина для использования приватного режима браузера:
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --login -incognito
```

### Без автоматического открытия браузера
Добавьте флаг `-no-browser` чтобы получить URL вручную:
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --login -no-browser
```

### Указать проект (только для Gemini)
```powershell
C:\Users\s.semihod\bin\cliproxyapi-plus.exe --config C:\Users\s.semihod\.cli-proxy-api\config.yaml --login -project_id "your-gcp-project-id"
```

---

## Рекомендуемый порядок настройки Google сервисов:

1. **Gemini (--login)** - основной, бесплатный доступ к Gemini
2. **Vertex AI (--vertex-import)** - если есть Google Cloud проект
3. **Kiro Google (--kiro-google-login)** - дополнительный доступ через Kiro

---

## Проверка авторизованных аккаунтов:
```powershell
Get-ChildItem "C:\Users\s.semihod\.cli-proxy-api" -Filter "*.json" | Select-Object Name
```
