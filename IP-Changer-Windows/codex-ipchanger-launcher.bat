@echo off
title Codex IP Changer - Auto Setup
setlocal EnableDelayedExpansion

echo ---------------------------------------
echo        🛰️ Codex IP Changer Setup
echo ---------------------------------------

:: 1. Check Python
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Python is not installed on this system.
    echo [!] Please install Python from https://www.python.org/downloads/
    pause
    exit /b
)

:: 2. Create virtual environment (if missing)
if not exist venv (
    echo [+] Creating isolated Python environment...
    python -m venv venv
)

:: 3. Activate virtualenv
call venv\Scripts\activate.bat

:: 4. Install Python requirements
echo [+] Installing Python packages...
pip install --quiet --upgrade pip
pip install --quiet requests stem

:: 5. Verify tor.exe and privoxy.exe exist
if not exist tor\tor.exe (
    echo [X] tor.exe missing in /tor/
    pause
    exit /b
)
if not exist privoxy\privoxy.exe (
    echo [X] privoxy.exe missing in /privoxy/
    pause
    exit /b
)

:: 6. Generate privoxy config.txt if missing
if not exist privoxy\config.txt (
    echo [+] Generating config.txt for Privoxy...
    (
        echo listen-address 127.0.0.1:8118
        echo toggle 1
        echo enable-remote-toggle 0
        echo enable-edit-actions 0
        echo enforce-blocks 0
        echo forward-socks5 / 127.0.0.1:9050 .
    ) > privoxy\config.txt
)

:: 7. Launch codex_ip_changer.py
echo.
echo [+] Starting Codex IP Changer...
python codex_ip_changer.py

:: 8. Cleanup
echo [✓] Done. Exiting launcher.
pause
exit /b