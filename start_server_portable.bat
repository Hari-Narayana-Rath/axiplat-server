@echo off
REM Age Gate Server - Portable Standalone Launcher (Windows)
REM This script can run from anywhere and will set up everything automatically

setlocal enabledelayedexpansion

REM Get the directory where this batch file is located
set "BAT_DIR=%~dp0"
cd /d "%BAT_DIR%"

echo ========================================
echo Age Gate Server - Portable Launcher
echo ========================================
echo.

REM Check if Python is installed
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

REM Check if we're in a project folder (has app.py)
if exist "app.py" (
    echo [OK] Project folder detected
    set "PROJECT_DIR=%BAT_DIR%"
    goto :setup_server
)

REM Not in project folder - check if we should clone/download
echo [INFO] Not in project folder. Setting up...
echo.

REM Option 1: Check if there's a project folder nearby
if exist "..\app.py" (
    echo [OK] Found project folder in parent directory
    set "PROJECT_DIR=%~dp0.."
    cd /d "!PROJECT_DIR!"
    goto :setup_server
)

REM Option 2: Clone from GitHub
echo [INFO] Cloning project from GitHub...
echo.

REM Check if git is available
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

REM Clone the repository
set "REPO_URL=https://github.com/Hari-Narayana-Rath/axiplat.git"
set "CLONE_DIR=age_gate_server"

if exist "%CLONE_DIR%" (
    echo [INFO] Folder %CLONE_DIR% already exists, using it...
    set "PROJECT_DIR=%BAT_DIR%%CLONE_DIR%"
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

echo [OK] Project cloned successfully
echo.

:setup_server
cd /d "!PROJECT_DIR!"

echo [INFO] Setting up server in: !PROJECT_DIR!
echo.

REM Check if virtual environment exists
if exist "venv\Scripts\activate.bat" (
    echo [OK] Virtual environment found
    goto :start_server
)

REM Create virtual environment
echo [INFO] Creating virtual environment...
python -m venv venv
if errorlevel 1 (
    echo [ERROR] Failed to create virtual environment.
    pause
    exit /b 1
)

echo [OK] Virtual environment created
echo.

REM Install dependencies
echo [INFO] Installing dependencies...
echo This may take a few minutes on first run...
echo.

call venv\Scripts\activate.bat
pip install --upgrade pip --quiet
pip install -r requirements.txt --quiet

if errorlevel 1 (
    echo [ERROR] Failed to install dependencies.
    echo.
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)

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

REM Start server (visible window for now - user can minimize)
call venv\Scripts\activate.bat
python app.py

pause

