# Исправление предупреждения о профиле Windows Terminal

## Проблема

При запуске ярлыков появляется сообщение:
```
Не удалось найти в вашем списке профилей профиль по умолчанию, 
поэтому используется первый профиль. Проверьте, соответствует ли 
значение параметра "defaultProfile" идентификатору GUID одного из ваших профилей.
```

## Причина

Это предупреждение **не влияет на работу** скриптов и появляется только если:
1. PowerShell запускается через Windows Terminal
2. В настройках Terminal указан несуществующий профиль по умолчанию

## Решение 1: Игнорировать (рекомендуется)

Предупреждение **не критично** и не мешает работе. Скрипты работают корректно.

## Решение 2: Изменить профиль по умолчанию в Windows Terminal

1. Откройте Windows Terminal
2. Нажмите `Ctrl + ,` (Настройки)
3. Перейдите в раздел **"Startup"** или **"Запуск"**
4. В поле **"Default profile"** выберите **"PowerShell"** или **"Windows PowerShell"**
5. Сохраните изменения

## Решение 3: Отредактировать settings.json напрямую

1. Откройте файл настроек:
   ```powershell
   notepad "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
   ```

2. Найдите строку с `"defaultProfile"`

3. Замените GUID на один из доступных профилей:

   **Доступные профили в вашей системе:**
   - PowerShell 7: `{574e775e-4f2a-5b96-ac1e-a2962a402336}`
   - Windows PowerShell: `{61c54bbd-c2c6-5271-96e7-009a87ff44bf}`
   - Developer PowerShell for VS 2022: `{66319440-7874-5f33-a81c-b1d29d6e7834}`

4. Сохраните файл

## Решение 4: Запускать pwsh.exe напрямую (уже используется)

Ярлыки уже настроены на запуск `pwsh.exe` напрямую, а не через Windows Terminal, 
поэтому предупреждение не должно появляться при их использовании.

Если предупреждение все равно появляется, значит PowerShell настроен на запуск 
через Windows Terminal по умолчанию.

### Отключить Windows Terminal как обработчик по умолчанию:

1. Откройте **Settings (Win + I)**
2. Перейдите в **Privacy & security > For developers**
3. Найдите **"Terminal"**
4. Измените с **"Windows Terminal"** на **"Windows Console Host"**

## Проверка текущих профилей

Запустите команду для просмотра доступных профилей:

```powershell
$settings = Get-Content "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Raw | ConvertFrom-Json

Write-Host "Default Profile: $($settings.defaultProfile)" -ForegroundColor Cyan
Write-Host "`nДоступные профили:"

$settings.profiles.list | ForEach-Object {
    Write-Host "  Name: $($_.name)"
    Write-Host "  GUID: $($_.guid)"
    Write-Host ""
}
```

## Примечание

Все скрипты в проекте уже **обновлены** и больше не содержат жестко заданных путей:
- ✅ Автоматически определяют путь через `$PSScriptRoot`
- ✅ Проверяют существование файлов перед созданием ярлыков
- ✅ Работают из любой директории
