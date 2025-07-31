@echo off
title CODEX IP CHANGER (Windows Version)
color 0A
setlocal EnableDelayedExpansion

:: Setup folders
set TEMP_DIR=%~dp0tor_data
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: Kill old Tor/Privoxy
taskkill /f /im tor.exe >nul 2>&1
taskkill /f /im privoxy.exe >nul 2>&1

:: Reset proxy settings (cleanup from previous run)
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>&1

:: Banner
cls
echo =====================================================
echo            COD-X IP CHANGER (Windows Edition)
echo                 Made by Tawhed [Network-Pirate]
echo =====================================================
echo [1] Random IP Rotation
echo [2] Country-Based IP Rotation
echo [3] Exit
set /p opt=Choose Option: 

if "%opt%"=="1" goto random
if "%opt%"=="2" goto country
if "%opt%"=="3" goto exit
goto end

:random
echo.
set /p interval=Enter rotation interval (in seconds): 
if "%interval%"=="" set interval=20

echo SocksPort 9050> "%TEMP_DIR%\torrc"
echo ControlPort 9051>> "%TEMP_DIR%\torrc"

start /min tor.exe -f "%TEMP_DIR%\torrc"
timeout /t 10 >nul

:: Start Privoxy
if not exist "%TEMP_DIR%\privoxy.conf" (
    echo listen-address 127.0.0.1:8118> "%TEMP_DIR%\privoxy.conf"
    echo forward-socks5 / 127.0.0.1:9050 .>> "%TEMP_DIR%\privoxy.conf"
)
start /min privoxy.exe "%TEMP_DIR%\privoxy.conf"
timeout /t 5 >nul

:: Set Windows system-wide proxy
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d 127.0.0.1:8118 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f

:rotate_random
curl --proxy http://127.0.0.1:8118 https://api64.ipify.org
echo.
echo Rotating IP...
(echo authenticate "")> temp.cmd & (echo signal newnym)>> temp.cmd & (echo quit)>> temp.cmd
nc.exe 127.0.0.1 9051 < temp.cmd >nul
del temp.cmd
timeout /t %interval% >nul
goto rotate_random

:country
cls
echo.
echo ===========================
echo   Available Countries
echo ===========================
echo US  - United States         DE  - Germany
echo FR  - France                IN  - India
echo RU  - Russia                CA  - Canada
echo UK  - United Kingdom        JP  - Japan
echo CN  - China                 TR  - Turkey
echo UA  - Ukraine               AU  - Australia
echo BR  - Brazil                IT  - Italy
echo KR  - South Korea           SA  - Saudi Arabia
echo SE  - Sweden                NL  - Netherlands
echo NO  - Norway                ZA  - South Africa
echo CH  - Switzerland           MX  - Mexico
echo PL  - Poland                BE  - Belgium
echo ES  - Spain                 SG  - Singapore
echo AR  - Argentina             BD  - Bangladesh
echo PK  - Pakistan              EG  - Egypt
echo TH  - Thailand              ID  - Indonesia
echo PH  - Philippines           VN  - Vietnam
echo IR  - Iran                  FI  - Finland
echo GR  - Greece                CO  - Colombia
echo NZ  - New Zealand           MY  - Malaysia
echo RO  - Romania               HK  - Hong Kong
echo IL  - Israel                HU  - Hungary
echo AE  - UAE
echo.

set /p ccode=Enter country code (e.g., US): 
if not defined ccode set ccode=US

:: Kill old Tor
taskkill /f /im tor.exe >nul 2>&1
echo Starting new Tor exit node for %ccode%...
timeout /t 3 >nul

echo SocksPort 9050> "%TEMP_DIR%\torrc"
echo ControlPort 9051>> "%TEMP_DIR%\torrc"
echo ExitNodes {%ccode%}>> "%TEMP_DIR%\torrc"
echo StrictNodes 1>> "%TEMP_DIR%\torrc"

start /min tor.exe -f "%TEMP_DIR%\torrc"
timeout /t 10 >nul

:: Start Privoxy again
if not exist "%TEMP_DIR%\privoxy.conf" (
    echo listen-address 127.0.0.1:8118> "%TEMP_DIR%\privoxy.conf"
    echo forward-socks5 / 127.0.0.1:9050 .>> "%TEMP_DIR%\privoxy.conf"
)
start /min privoxy.exe "%TEMP_DIR%\privoxy.conf"
timeout /t 5 >nul

:: Set Proxy
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d 127.0.0.1:8118 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f

:rotate_country
curl --proxy http://127.0.0.1:8118 https://api64.ipify.org
echo.
echo Rotating IP for country: %ccode%...
(echo authenticate "")> temp.cmd & (echo signal newnym)>> temp.cmd & (echo quit)>> temp.cmd
nc.exe 127.0.0.1 9051 < temp.cmd >nul
del temp.cmd
timeout /t 10 >nul
goto rotate_country

:exit
:: Restore default proxy settings
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>&1
echo Proxy settings restored to default. Goodbye!
timeout /t 2 >nul
exit