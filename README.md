# Age Gate Server Launchers

Portable launcher scripts that automatically set up and run the Age Gate server. These scripts can be placed anywhere and will handle everything automatically.

## 🚀 Quick Start

### Windows

1. **Download** `start_server_portable.bat` (or `start_server_hidden_portable.bat` for hidden mode)
2. **Double-click** the file
3. Wait for setup to complete (first run only, ~2-5 minutes)
4. Server will start automatically at `http://localhost:5000`

### macOS/Linux

1. **Download** `start_server_portable.sh` (or `start_server_hidden_portable.sh` for background mode)
2. **Make it executable**: `chmod +x start_server_portable.sh`
3. **Run it**: `./start_server_portable.sh`
4. Wait for setup to complete (first run only, ~2-5 minutes)
5. Server will start automatically at `http://localhost:5000`

## 📋 Available Launchers

### Windows

- **`start_server_portable.bat`** - Standard launcher with visible window
  - Shows progress and status messages
  - Good for first-time setup
  - Can be minimized

- **`start_server_hidden_portable.bat`** - Hidden background launcher
  - Runs completely hidden (no window)
  - Perfect for auto-start on boot
  - Shows setup window only if needed

### macOS/Linux

- **`start_server_portable.sh`** - Standard launcher
  - Shows progress in terminal
  - Good for first-time setup
  - Runs in foreground

- **`start_server_hidden_portable.sh`** - Background launcher
  - Runs in background using `nohup`
  - Perfect for auto-start
  - Shows setup window only if needed

## ✨ Features

- **Fully Portable** - Run from anywhere (desktop, downloads, USB drive, etc.)
- **Auto-Setup** - Automatically clones the project if needed
- **Smart Detection** - Finds project folder if launcher is placed inside it
- **Dependency Management** - Creates virtual environment and installs all dependencies
- **One-Click Start** - Just double-click and it works!

## 📦 Requirements

### First-Time Setup
- **Python 3.7+** installed and in PATH
- **Git** installed (only needed for first-time clone)
- **Internet connection** (only for first-time clone and dependency installation)

### Subsequent Runs
- Only Python needed (everything else is cached)

## 🔧 How It Works

1. **Checks Python** - Verifies Python is installed
2. **Finds Project** - Looks for project folder in current or parent directory
3. **Clones if Needed** - Automatically clones from GitHub if project not found
4. **Creates Environment** - Sets up Python virtual environment
5. **Installs Dependencies** - Installs all required packages
6. **Starts Server** - Launches the Flask server

## 🎯 Use Cases

### For End Users
- Download the launcher file
- Place it anywhere convenient
- Double-click to start server
- No technical knowledge required!

### For Developers
- Place launcher in project root for quick start
- Use hidden version for background development
- Auto-setup ensures consistent environment

## 🔄 First Run vs Subsequent Runs

**First Run (2-5 minutes):**
- Clones repository (if needed)
- Creates virtual environment
- Installs all dependencies
- Starts server

**Subsequent Runs (instant):**
- Uses existing setup
- Starts server immediately

## 🛠️ Troubleshooting

### "Python is not installed"
- Install Python from https://www.python.org/
- **Windows**: Check "Add Python to PATH" during installation
- **macOS**: `brew install python3`
- **Linux**: Use your package manager (`apt`, `dnp`, `yum`, etc.)

### "Git is not installed"
- Only needed for first-time clone
- Install Git from https://git-scm.com/
- Or manually place the launcher in the project folder

### "Failed to clone repository"
- Check internet connection
- Verify GitHub is accessible
- Try running the launcher from within the project folder instead

### Server won't start
- Check if port 5000 is already in use
- Make sure all dependencies installed correctly
- Check Python version (3.7+ required)

## 📝 Notes

- The launcher creates a folder `age_gate_server` in the same directory if cloning
- Virtual environment is created in the project folder as `venv`
- All setup is automatic - no manual configuration needed
- Server runs on `http://localhost:5000` by default

## 🔗 Related

- Main Project: https://github.com/Hari-Narayana-Rath/axiplat
- Browser Extension: See main project README

## 📄 License

Same as main project license.

