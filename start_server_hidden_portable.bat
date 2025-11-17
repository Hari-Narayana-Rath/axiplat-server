@echo off
REM Age Gate Server - Portable Hidden Launcher (Windows)
REM This script can run from anywhere and will set up everything automatically
REM Runs completely hidden in the background

setlocal enabledelayedexpansion

REM Get the directory where this batch file is located
set "BAT_DIR=%~dp0"
cd /d "%BAT_DIR%"

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    REM Show error in a message box since we're running hidden
    mshta vbscript:Execute("msgbox ""Python is not installed. Please install Python from https://www.python.org/"", vbCritical, ""Age Gate Server Error"")(window.close)")
    exit /b 1
)

REM Check if we're in a project folder (has app.py)
if exist "app.py" (
    set "PROJECT_DIR=%BAT_DIR%"
    goto :setup_server
)

REM Check if project folder is in parent directory
if exist "..\app.py" (
    set "PROJECT_DIR=%~dp0.."
    cd /d "!PROJECT_DIR!"
    goto :setup_server
)

REM Need to clone - but we can't show output when hidden
REM So we'll create a visible setup window first
set "REPO_URL=https://github.com/Hari-Narayana-Rath/axiplat.git"
set "CLONE_DIR=age_gate_server"
set "PROJECT_DIR=%BAT_DIR%%CLONE_DIR%"

if not exist "%CLONE_DIR%" (
    REM Show setup window
    start "" cmd /k "echo Cloning Age Gate Server... && git clone %REPO_URL% %CLONE_DIR% && echo. && echo Setup complete! You can close this window. && pause"
    REM Wait a bit for clone to start
    timeout /t 3 /nobreak >nul
    REM Check if clone completed (simple check - wait up to 60 seconds)
    set /a count=0
    :wait_loop
    if exist "%CLONE_DIR%\app.py" goto :setup_server
    timeout /t 2 /nobreak >nul
    set /a count+=1
    if !count! geq 30 (
        REM Timeout - show error
        mshta vbscript:Execute("msgbox ""Setup is taking too long. Please run start_server_portable.bat instead for first-time setup."", vbCritical, ""Age Gate Server"")(window.close)")
        exit /b 1
    )
    goto :wait_loop
)

:setup_server
cd /d "!PROJECT_DIR!"

REM Check if virtual environment exists
if exist "venv\Scripts\activate.bat" (
    goto :start_server_hidden
)

REM Create venv and install (silently)
python -m venv venv >nul 2>&1
if errorlevel 1 exit /b 1

call venv\Scripts\activate.bat
pip install --upgrade pip --quiet >nul 2>&1
pip install -r requirements.txt --quiet >nul 2>&1

:start_server_hidden
REM Run server completely hidden using VBS
set "VBS_SCRIPT=%TEMP%\age_gate_launcher_%RANDOM%.vbs"

(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.CurrentDirectory = "!PROJECT_DIR!"
echo WshShell.Run "cmd /c ""!PROJECT_DIR!venv\Scripts\activate.bat && python app.py""", 0, False
) > "%VBS_SCRIPT%"

cscript //nologo "%VBS_SCRIPT%"
del "%VBS_SCRIPT%" >nul 2>&1

exit /b 0

