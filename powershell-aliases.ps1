# Добавьте эти строки в ваш PowerShell профиль для быстрого доступа
# Откройте профиль: notepad $PROFILE

# CLI Proxy API Plus aliases
Set-Alias proxy "D:\tools\ai\proxy.ps1"

# Или создайте функции:
function proxy { D:\tools\ai\proxy.ps1 @args }
function proxy-start { D:\tools\ai\start-proxy-server.ps1 }
function proxy-stop { D:\tools\ai\stop-proxy-server.ps1 }
function proxy-login { D:\tools\ai\batch-oauth-login.ps1 }

# Continue CLI alias (cn)
function cn { 
    & "D:\tools\ai\launch-ai.ps1" @args 
}

# После добавления перезагрузите профиль:
# . $PROFILE

# Теперь можно использовать:
# proxy -Status
# proxy -Start
# proxy -Stop
# proxy -Models
# proxy-start
# proxy-stop
# proxy-login
