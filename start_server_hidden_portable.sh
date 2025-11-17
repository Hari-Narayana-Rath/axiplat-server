#!/bin/bash
# Age Gate Server - Portable Hidden Launcher (macOS/Linux)
# This script can run from anywhere and will set up everything automatically
# Runs in the background (nohup)

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    # Show error (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e 'display dialog "Python 3 is not installed. Please install Python from https://www.python.org/" buttons {"OK"} default button "OK" with icon stop'
    else
        # Linux - show notification if available
        if command -v notify-send &> /dev/null; then
            notify-send "Age Gate Server Error" "Python 3 is not installed. Please install Python."
        else
            echo "[ERROR] Python 3 is not installed."
        fi
    fi
    exit 1
fi

# Check if we're in a project folder (has app.py)
if [ -f "app.py" ]; then
    PROJECT_DIR="$SCRIPT_DIR"
else
    # Check if project folder is in parent directory
    if [ -f "../app.py" ]; then
        PROJECT_DIR="$(cd .. && pwd)"
        cd "$PROJECT_DIR"
    else
        # Need to clone - show visible window for first-time setup
        REPO_URL="https://github.com/Hari-Narayana-Rath/axiplat.git"
        CLONE_DIR="age_gate_server"
        PROJECT_DIR="$SCRIPT_DIR/$CLONE_DIR"
        
        if [ ! -d "$CLONE_DIR" ]; then
            # Open terminal window for cloning
            if [[ "$OSTYPE" == "darwin"* ]]; then
                osascript -e "tell application \"Terminal\" to do script \"cd '$SCRIPT_DIR' && echo 'Cloning Age Gate Server...' && git clone '$REPO_URL' '$CLONE_DIR' && echo '' && echo 'Setup complete! You can close this window.' && read -p 'Press Enter to continue...'\""
            else
                # Linux - use xterm or gnome-terminal if available
                if command -v gnome-terminal &> /dev/null; then
                    gnome-terminal -- bash -c "cd '$SCRIPT_DIR' && echo 'Cloning Age Gate Server...' && git clone '$REPO_URL' '$CLONE_DIR' && echo '' && echo 'Setup complete! You can close this window.' && read -p 'Press Enter to continue...'"
                elif command -v xterm &> /dev/null; then
                    xterm -e "cd '$SCRIPT_DIR' && echo 'Cloning Age Gate Server...' && git clone '$REPO_URL' '$CLONE_DIR' && echo '' && echo 'Setup complete! You can close this window.' && read -p 'Press Enter to continue...'"
                else
                    # Fallback: run in foreground
                    echo "Cloning Age Gate Server..."
                    git clone "$REPO_URL" "$CLONE_DIR"
                fi
            fi
            
            # Wait for clone to complete
            sleep 3
            count=0
            while [ ! -f "$CLONE_DIR/app.py" ] && [ $count -lt 30 ]; do
                sleep 2
                count=$((count + 1))
            done
            
            if [ ! -f "$CLONE_DIR/app.py" ]; then
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    osascript -e 'display dialog "Setup is taking too long. Please run start_server_portable.sh instead for first-time setup." buttons {"OK"} default button "OK" with icon stop'
                else
                    echo "[ERROR] Setup timeout. Please run start_server_portable.sh instead."
                fi
                exit 1
            fi
        fi
        cd "$PROJECT_DIR"
    fi
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    # Create venv and install (silently)
    python3 -m venv venv > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        exit 1
    fi
    
    source venv/bin/activate
    # Try to upgrade pip, but don't fail if it doesn't work
    python3 -m pip install --upgrade pip --quiet > /dev/null 2>&1 || true
    
    # Install core dependencies first (required for age gate)
    python3 -m pip install Flask==2.2.5 flask-cors==4.0.0 opencv-python==4.8.1.78 mediapipe==0.10.11 numpy==1.26.4 --quiet > /dev/null 2>&1
    # Install optional dependencies (skip if they fail)
    python3 -m pip install scikit-learn==1.3.2 joblib==1.3.2 pandas==2.2.3 --quiet > /dev/null 2>&1 || true
fi

# Run server in background
source venv/bin/activate
nohup python app.py > /dev/null 2>&1 &

echo "Server started in background. PID: $!"
echo "Access it at: http://localhost:5000"
echo "To stop: kill $!"

