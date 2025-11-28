@echo off
REM Hidden Windows launcher (runs AXIPLAT silently)

setlocal enabledelayedexpansion

set "BAT_DIR=%~dp0"
cd /d "%BAT_DIR%"

python --version >nul 2>&1
if errorlevel 1 (
    mshta vbscript:Execute("msgbox ""Python is not installed. Please install Python from https://www.python.org/"", vbCritical, ""AXIPLAT Server Error"")(window.close)")
    exit /b 1
)

if exist "app.py" (
    set "PROJECT_DIR=%BAT_DIR%"
    goto :setup_server
)

if exist "..\app.py" (
    set "PROJECT_DIR=%~dp0.."
    cd /d "!PROJECT_DIR!"
    goto :setup_server
)

set "REPO_URL=https://github.com/Hari-Narayana-Rath/axiplat.git"
set "CLONE_DIR=axiplat_server"
set "LEGACY_CLONE_DIR=age_gate_server"
set "PROJECT_DIR=%BAT_DIR%%CLONE_DIR%"

if not exist "%CLONE_DIR%" (
    if exist "%LEGACY_CLONE_DIR%" (
        set "PROJECT_DIR=%BAT_DIR%%LEGACY_CLONE_DIR%"
        goto :setup_server
    )
    start "" cmd /k "echo Cloning AXIPLAT Server... && git clone %REPO_URL% %CLONE_DIR% && echo. && echo Setup complete! You can close this window. && pause"
    timeout /t 3 /nobreak >nul
    set /a count=0
    :wait_loop
    if exist "%CLONE_DIR%\app.py" goto :setup_server
    timeout /t 2 /nobreak >nul
    set /a count+=1
    if !count! geq 30 (
        mshta vbscript:Execute("msgbox ""Setup is taking too long. Please run start_server_portable.bat instead for first-time setup."", vbCritical, ""AXIPLAT Server"")(window.close)")
        exit /b 1
    )
    goto :wait_loop
)

:setup_server
cd /d "!PROJECT_DIR!"

if exist "venv\Scripts\activate.bat" (
    goto :start_server_hidden
)

python -m venv venv >nul 2>&1
if errorlevel 1 exit /b 1

call venv\Scripts\activate.bat
python -m pip install --upgrade pip --quiet >nul 2>&1

python -m pip install Flask==2.2.5 flask-cors==4.0.0 opencv-python==4.8.1.78 mediapipe==0.10.11 numpy==1.26.4 --quiet >nul 2>&1
python -m pip install scikit-learn==1.3.2 joblib==1.3.2 pandas==2.2.3 --quiet >nul 2>&1

:start_server_hidden
set "VBS_SCRIPT=%TEMP%\axiplat_launcher_%RANDOM%.vbs"

(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.CurrentDirectory = "!PROJECT_DIR!"
echo WshShell.Run "cmd /c ""!PROJECT_DIR!venv\Scripts\activate.bat && python app.py""", 0, False
) > "%VBS_SCRIPT%"

cscript //nologo "%VBS_SCRIPT%"
del "%VBS_SCRIPT%" >nul 2>&1

exit /b 0

