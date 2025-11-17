#!/bin/bash
# Age Gate Server - Portable Standalone Launcher (macOS/Linux)
# This script can run from anywhere and will set up everything automatically

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================"
echo "Age Gate Server - Portable Launcher"
echo "========================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python 3 is not installed or not in PATH."
    echo ""
    echo "Please install Python 3 from https://www.python.org/"
    echo "Or use your system package manager:"
    echo "  macOS: brew install python3"
    echo "  Ubuntu/Debian: sudo apt-get install python3"
    echo "  Fedora: sudo dnf install python3"
    echo ""
    exit 1
fi

echo "[OK] Python found"
echo ""

# Check if we're in a project folder (has app.py)
if [ -f "app.py" ]; then
    echo "[OK] Project folder detected"
    PROJECT_DIR="$SCRIPT_DIR"
else
    # Check if project folder is in parent directory
    if [ -f "../app.py" ]; then
        echo "[OK] Found project folder in parent directory"
        PROJECT_DIR="$(cd .. && pwd)"
        cd "$PROJECT_DIR"
    else
        # Need to clone from GitHub
        echo "[INFO] Not in project folder. Setting up..."
        echo ""
        
        # Check if git is available
        if ! command -v git &> /dev/null; then
            echo "[ERROR] Git is not installed."
            echo ""
            echo "Please either:"
            echo "1. Place this script in the project folder, OR"
            echo "2. Install Git and try again"
            echo ""
            exit 1
        fi
        
        REPO_URL="https://github.com/Hari-Narayana-Rath/axiplat.git"
        CLONE_DIR="age_gate_server"
        
        if [ -d "$CLONE_DIR" ]; then
            echo "[INFO] Folder $CLONE_DIR already exists, using it..."
            PROJECT_DIR="$SCRIPT_DIR/$CLONE_DIR"
        else
            echo "[INFO] Cloning repository..."
            git clone "$REPO_URL" "$CLONE_DIR"
            if [ $? -ne 0 ]; then
                echo "[ERROR] Failed to clone repository."
                echo ""
                echo "Please check your internet connection and try again."
                echo ""
                exit 1
            fi
            PROJECT_DIR="$SCRIPT_DIR/$CLONE_DIR"
        fi
        
        echo "[OK] Project cloned successfully"
        echo ""
        cd "$PROJECT_DIR"
    fi
fi

echo "[INFO] Setting up server in: $PROJECT_DIR"
echo ""

# Check if virtual environment exists
if [ -d "venv" ]; then
    echo "[OK] Virtual environment found"
else
    # Create virtual environment
    echo "[INFO] Creating virtual environment..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to create virtual environment."
        exit 1
    fi
    
    echo "[OK] Virtual environment created"
    echo ""
    
    # Install dependencies
    echo "[INFO] Installing dependencies..."
    echo "This may take a few minutes on first run..."
    echo ""
    
    source venv/bin/activate
    pip install --upgrade pip --quiet
    pip install -r requirements.txt --quiet
    
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to install dependencies."
        echo ""
        echo "Please check your internet connection and try again."
        exit 1
    fi
    
    echo "[OK] Dependencies installed"
    echo ""
fi

# Start server
echo "[INFO] Starting server..."
echo ""
echo "Server will run in the foreground."
echo "Access it at: http://localhost:5000"
echo ""
echo "Press Ctrl+C to stop the server."
echo ""

source venv/bin/activate
python app.py

