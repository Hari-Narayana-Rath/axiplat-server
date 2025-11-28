@echo off
REM Portable Windows launcher (auto setup anywhere)

setlocal enabledelayedexpansion

set "BAT_DIR=%~dp0"
cd /d "%BAT_DIR%"

echo ========================================
echo AXIPLAT Server - Portable Launcher
echo ========================================
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH.
    echo.
    echo Please install Python from https://www.python.org/
    echo Make sure to check "Add Python to PATH" during installation.
    echo.
    pause
    exit /b 1
)

echo [OK] Python found
echo.

if exist "app.py" (
    echo [OK] Project folder detected
    set "PROJECT_DIR=%BAT_DIR%"
    goto :setup_server
)

echo [INFO] Not in project folder. Setting up...
echo.

if exist "..\app.py" (
    echo [OK] Found project folder in parent directory
    set "PROJECT_DIR=%~dp0.."
    cd /d "!PROJECT_DIR!"
    goto :setup_server
)

echo [INFO] Cloning project from GitHub...
echo.

git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed.
    echo.
    echo Please either:
    echo 1. Place this .bat file in the project folder, OR
    echo 2. Install Git from https://git-scm.com/ and try again
    echo.
    pause
    exit /b 1
)

set "REPO_URL=https://github.com/Hari-Narayana-Rath/axiplat.git"
set "CLONE_DIR=axiplat_server"
set "LEGACY_CLONE_DIR=age_gate_server"

if exist "%CLONE_DIR%" (
    echo [INFO] Folder %CLONE_DIR% already exists, using it...
    set "PROJECT_DIR=%BAT_DIR%%CLONE_DIR%"
) else (
    if exist "%LEGACY_CLONE_DIR%" (
        echo [INFO] Found legacy folder %LEGACY_CLONE_DIR%, using it...
        set "PROJECT_DIR=%BAT_DIR%%LEGACY_CLONE_DIR%"
    ) else (
        echo [INFO] Cloning repository...
        git clone %REPO_URL% %CLONE_DIR%
        if errorlevel 1 (
            echo [ERROR] Failed to clone repository.
            echo.
            echo Please check your internet connection and try again.
            echo.
            pause
            exit /b 1
        )
        set "PROJECT_DIR=%BAT_DIR%%CLONE_DIR%"
    )
)

echo [OK] Project cloned successfully
echo.

:setup_server
cd /d "!PROJECT_DIR!"

echo [INFO] Setting up server in: !PROJECT_DIR!
echo.

if exist "venv\Scripts\activate.bat" (
    echo [OK] Virtual environment found
    goto :start_server
)

echo [INFO] Creating virtual environment...
python -m venv venv
if errorlevel 1 (
    echo [ERROR] Failed to create virtual environment.
    pause
    exit /b 1
)

echo [OK] Virtual environment created
echo.

echo [INFO] Installing dependencies...
echo This may take a few minutes on first run...
echo.

call venv\Scripts\activate.bat
python -m pip install --upgrade pip --quiet 2>nul || echo [INFO] Pip upgrade skipped

echo [INFO] Installing core dependencies...
pip install Flask==2.2.5 flask-cors==4.0.0 opencv-python==4.8.1.78 mediapipe==0.10.11 numpy==1.26.4 --quiet
if errorlevel 1 (
    echo [ERROR] Failed to install core dependencies.
    echo.
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)

echo [INFO] Installing optional dependencies...
pip install scikit-learn==1.3.2 joblib==1.3.2 pandas==2.2.3 --quiet 2>nul || echo [INFO] Some optional packages failed, continuing...

echo [OK] Dependencies installed
echo.

:start_server
echo [INFO] Starting server...
echo.
echo Server will run in the background.
echo Access it at: http://localhost:5000
echo.
echo Press Ctrl+C in this window to stop the server.
echo (Or close this window)
echo.

call venv\Scripts\activate.bat
python app.py

pause

