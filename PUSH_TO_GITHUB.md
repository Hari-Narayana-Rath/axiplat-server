# How to Push Launcher Files to GitHub

Follow these steps to upload the launcher files to your GitHub repository:

## Option 1: Using GitHub Web Interface (Easiest)

1. Go to https://github.com/Hari-Narayana-Rath/axiplat-server
2. Click "Add file" → "Upload files"
3. Drag and drop all files from the `launcher_files` folder:
   - `start_server_portable.bat`
   - `start_server_hidden_portable.bat`
   - `start_server_portable.sh`
   - `start_server_hidden_portable.sh`
   - `README.md`
4. Click "Commit changes"
5. Done! Files are now available for download

## Option 2: Using Git Command Line

```bash
# Navigate to launcher_files directory
cd launcher_files

# Initialize git (if not already done)
git init

# Add remote repository
git remote add origin https://github.com/Hari-Narayana-Rath/axiplat-server.git

# Add all files
git add .

# Commit
git commit -m "Add portable launcher files for all OS"

# Push to GitHub
git branch -M main
git push -u origin main
```

## Option 3: Using GitHub Desktop

1. Open GitHub Desktop
2. File → Add Local Repository
3. Select the `launcher_files` folder
4. Publish repository to GitHub
5. Select `axiplat-server` as the repository name

## After Uploading

Once files are on GitHub, users can:
1. Go to https://github.com/Hari-Narayana-Rath/axiplat-server
2. Click on any file (e.g., `start_server_portable.bat`)
3. Click "Raw" button
4. Right-click → "Save As" to download

Or use the extension's "Start Server" button which now redirects to this repo!

