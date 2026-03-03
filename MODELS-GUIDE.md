# 🤖 Справочник по доступным моделям через CLI Proxy API Plus

**Всего доступно: 31 модель**  
**Прокси:** http://localhost:8317/v1  
**API Key:** sk-dummy (для всех моделей)

---

## 🏢 Провайдер: Anthropic Claude (5 моделей)

| Модель | Тип | Статус | Описание |
|--------|-----|--------|----------|
| **claude-sonnet-4.5** | Балансированный | ✅ FREE | Оптимальный баланс скорости и качества |
| **claude-opus-4.5** | Премиум | 💰 PAID | Самый мощный, для сложных задач |
| **claude-haiku-4.5** | Быстрый | ✅ FREE | Быстрые ответы, простые задачи |
| claude-sonnet-4 | Старая версия | ✅ FREE | Предыдущее поколение Sonnet |
| claude-opus-4.1 | Старая версия | 💰 PAID | Предыдущее поколение Opus |

**Рекомендация:** `claude-sonnet-4.5` для большинства задач

---

## 🌟 Провайдер: Google Gemini (9 моделей)

### Основные модели Gemini

| Модель | Тип | Статус | Описание |
|--------|-----|--------|----------|
| **gemini-2.5-pro** | Премиум | ✅ FREE | Лучший Gemini, большой контекст |
| **gemini-2.5-flash** | Быстрый | ✅ FREE | Быстрый, оптимизированный |
| **gemini-3-pro-preview** | Preview | 🧪 BETA | Gemini 3 поколение (тестовая) |
| **gemini-3-flash-preview** | Preview | 🧪 BETA | Gemini 3 Flash (тестовая) |
| gemini-2.5-flash-lite | Lite | ✅ FREE | Облегченная версия Flash |
| gemini-3-pro-image-preview | Multimodal | 🧪 BETA | С поддержкой изображений |

### Гибридные модели (Gemini + Claude)

| Модель | Описание | Статус |
|--------|----------|--------|
| gemini-claude-sonnet-4-5 | Gemini + Claude Sonnet | ✅ FREE |
| gemini-claude-sonnet-4-5-thinking | С расширенным reasoning | ✅ FREE |
| gemini-claude-opus-4-5-thinking | Gemini + Claude Opus с reasoning | 💰 PAID |

**Рекомендация:** `gemini-2.5-pro` или `gemini-2.5-flash` для быстрых задач

---

## 🚀 Провайдер: Antigravity GPT (11 моделей)

### GPT-5 серия

| Модель | Тип | Статус | Описание |
|--------|-----|--------|----------|
| **gpt-5.2** | Стандарт | ✅ FREE | Новейшая версия GPT-5 |
| **gpt-5.2-codex** | Код | ✅ FREE | GPT-5.2 оптимизированный для кода |
| **gpt-5.1** | Стандарт | ✅ FREE | Стабильная версия GPT-5 |
| **gpt-5.1-codex** | Код | ✅ FREE | Для программирования |
| **gpt-5.1-codex-max** | Код Премиум | 💰 PAID | Максимальная версия для кода |
| **gpt-5.1-codex-mini** | Код Lite | ✅ FREE | Легкая версия для кода |
| **gpt-5** | Базовый | ✅ FREE | Базовая GPT-5 |
| **gpt-5-mini** | Lite | ✅ FREE | Облегченная GPT-5 |
| **gpt-5-codex** | Код | ✅ FREE | Базовая Codex версия |

### GPT-4 серия

| Модель | Тип | Статус | Описание |
|--------|-----|--------|----------|
| gpt-4.1 | Legacy | ✅ FREE | GPT-4 улучшенная |

### Open Source

| Модель | Тип | Статус | Описание |
|--------|-----|--------|----------|
| gpt-oss-120b-medium | Open Source | ✅ FREE | Open source 120B параметров |

**Рекомендация:** 
- Универсальные задачи: `gpt-5.2`
- Программирование: `gpt-5.2-codex`
- Быстрые задачи: `gpt-5-mini`

---

## 🐉 Провайдер: Qwen (Alibaba) (2 модели)

| Модель | Тип | Статус | Описание |
|--------|-----|--------|----------|
| **qwen3-coder-plus** | Код Премиум | ✅ FREE | Qwen 3 для программирования |
| **qwen3-coder-flash** | Код Быстрый | ✅ FREE | Быстрая версия для кода |

**Рекомендация:** `qwen3-coder-plus` для кода на китайском и английском

---

## 🦊 Провайдер: xAI Grok (1 модель)

| Модель | Тип | Статус | Описание |
|--------|-----|--------|----------|
| **grok-code-fast-1** | Код Быстрый | ✅ FREE | Grok оптимизированный для кода |

**Рекомендация:** Быстрые ответы по коду

---

## 🔧 Специальные модели (3 модели)

| Модель | Назначение | Статус |
|--------|------------|--------|
| **tab_flash_lite_preview** | Tab autocomplete | ✅ FREE |
| vision-model | Работа с изображениями | ✅ FREE |
| oswe-vscode-prime | VS Code оптимизация | ✅ FREE |

---

## 📊 Статистика по провайдерам

| Провайдер | Кол-во моделей | Бесплатных | Платных |
|-----------|----------------|------------|---------|
| Antigravity (GPT) | 11 | 10 | 1 |
| Google (Gemini) | 9 | 8 | 1 |
| Anthropic (Claude) | 5 | 3 | 2 |
| Qwen | 2 | 2 | 0 |
| Grok | 1 | 1 | 0 |
| Другие | 3 | 3 | 0 |
| **ИТОГО** | **31** | **27** | **4** |

---

## 🎯 Рекомендации по выбору

### Для разных задач:

| Задача | Рекомендуемая модель | Альтернатива |
|--------|---------------------|--------------|
| **Общий чат** | claude-sonnet-4.5 | gpt-5.2 |
| **Программирование** | gpt-5.2-codex | qwen3-coder-plus |
| **Быстрые ответы** | gemini-2.5-flash | gpt-5-mini |
| **Сложные задачи** | claude-opus-4.5 💰 | gemini-2.5-pro |
| **Анализ кода** | qwen3-coder-plus | gpt-5.1-codex |
| **Большой контекст** | gemini-2.5-pro | claude-sonnet-4.5 |
| **Tab completion** | tab_flash_lite_preview | - |

### По скорости (от быстрого к медленному):

1. ⚡ **gemini-2.5-flash** - самый быстрый
2. ⚡ **gpt-5-mini** - очень быстрый
3. ⚡ **claude-haiku-4.5** - быстрый
4. 🔵 **gpt-5.2** - средний
5. 🔵 **claude-sonnet-4.5** - средний
6. 🐢 **gemini-2.5-pro** - медленный но качественный
7. 🐢 **claude-opus-4.5** - самый медленный но самый умный

### По стоимости:

**Бесплатные (27 моделей):**
- Все GPT кроме gpt-5.1-codex-max
- Все Gemini кроме gemini-claude-opus-4-5-thinking
- Claude: haiku-4.5, sonnet-4, sonnet-4.5
- Все Qwen и Grok

**Платные (4 модели):**
- 💰 claude-opus-4.5
- 💰 claude-opus-4.1
- 💰 gpt-5.1-codex-max
- 💰 gemini-claude-opus-4-5-thinking

---

## 🔍 Как проверить модель

### Через скрипт:

```powershell
# Тест конкретной модели
D:\tools\ai\test-providers.ps1 -Model "gpt-5.2"

# Тест всех моделей
D:\tools\ai\test-providers.ps1 -All
```

### Через Claude CLI:

```powershell
$env:ANTHROPIC_API_URL = "http://localhost:8317/v1"
$env:ANTHROPIC_API_KEY = "sk-dummy"
$env:ANTHROPIC_MODEL = "gpt-5.2"
claude "test message"
```

### Через VS Code Continue:

1. Ctrl+L для открытия чата
2. Выбрать модель из списка вверху
3. Написать запрос

---

## 📝 Настройка в Continue

Конфиг: `C:\Users\s.semihod\.continue\config.yaml`

Модели уже настроены в Continue:
- GPT-5.2
- GPT-5.2-Codex
- Claude Sonnet 4.5
- Claude Opus 4.5
- Gemini 2.5 Pro
- Gemini 3 Pro Preview
- Gemini 2.5 Flash
- Qwen3 Coder Plus
- Qwen3 Coder Flash
- Grok Code Fast

---

## ⚠️ Важные замечания

1. **Прокси должен быть запущен:** `D:\tools\ai\start-proxy-server.ps1`
2. **API Key всегда:** `sk-dummy` для всех моделей
3. **URL прокси:** `http://localhost:8317/v1`
4. **Платные модели** могут требовать подписку у провайдера
5. **Beta модели** (🧪) могут работать нестабильно

---

## 📚 Дополнительная информация

- Список моделей: `D:\tools\ai\proxy.ps1 -Models`
- Тест провайдеров: `D:\tools\ai\test-providers.ps1`
- Запуск Claude: `D:\tools\ai\launch-ai.ps1`
- Документация: `D:\tools\ai\README.md`

---

**Последнее обновление:** 02.02.2026  
**Версия прокси:** CLI Proxy API Plus  
**Всего моделей:** 31 (27 бесплатных, 4 платных)
