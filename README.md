‎# 🛡️ CODEX IP CHANGER
‎
‎A powerful, dual-platform IP changer for **Termux (Android)**, **Kali/Linux (Desktop)**, and **Windows**.  
‎Rotate your IP address automatically or by country using the Tor network — with just one click.
‎
‎> ⚠️ For **educational use only**. Built by **Tawhed** with ❤️ in Termux, Kali & Windows.
‎
‎---
‎
‎## 📦 Supported Platforms
‎
‎| Platform        | Script / File            | Proxy Config         |
‎|------------------|---------------------------|------------------------|
‎| Termux (Android) | `ipchanger-termux.sh`     | ✅ Manual Wi-Fi Proxy |
‎| Kali/Linux       | `ipchanger-kali.sh`       | ✅ Manual browser configuration |
‎| Windows          | `codex-ipchanger-launcher.bat`| ✅ Auto Config + Restore |
‎
‎---
‎
‎## ⚙️ Features
‎
‎- 🔄 Auto IP rotation via Tor
‎- 🌍 Country-based IP selection
‎- ⚙️ Automatic requirement installation
‎- 🧼 Clean hacker-style output (green IP ✅)
‎- ☑️ No proxy config needed (Linux + Windows)
‎- 🪟 Windows version restores settings after exit
‎- ✅ Fully tested on Termux, Kali, and Windows
‎- 🐧 Based on Tor + Privoxy combo
‎
‎---
‎
‎## 🚀 Installation for Linux +termux
‎
‎```bash
‎apt update && apt upgrade -y
‎apt install tor -y
‎apt install privoxy -y
‎apt install curl -y
‎netcat git -y
‎git clone https://github.com/Network-pirate/codex-ip-changer.git
‎cd codex-ip-changer
‎chmod +x (according to your device)
‎```
‎
‎---
‎
‎### ▶️ For Kali/Linux:
‎```bash
‎./ipchanger-kali.sh
‎```
‎✅ Automatically installs: `tor`, `privoxy`, `curl`  
‎
‎## for browser network configuration ( Firefox recommended but if you have any browser give proxy support you can use them )
‎
‎✅ Open Firefox Network Settings
‎
‎1. In Firefox, click the ☰ (menu) button in the top-right.
‎
‎
‎2. Select Settings (or Preferences on some versions).
‎
‎
‎3. Scroll down to Network Settings.
‎
‎
‎4. Click Settings… (button next to it).
‎
‎5. Select Manual proxy configuration.
‎
‎6. Set:
‎HTTP Proxy: 127.0.0.1
‎Port: 8118
‎
‎7. Check Use this proxy server for all protocols.
‎
‎Leave No Proxy for: empty.
‎
‎ 
‎8. Click OK.
‎
‎( your proxy set successfully now you are IP will be changing . remember one thing after stop your tool from terminal of the proxy settings from Firefox if you don't do that you will lost internet connection in your browser )
‎
‎✅ Ctrl+C to stop the toll
‎
‎---
‎
‎### 📱 For Termux (Android):
‎```bash
‎./ipchanger-termux.sh
‎```
‎⚠️ After running, **go to Wi-Fi settings** and manually set:  
‎- Proxy: `127.0.0.1`  
‎- Port: `8118`
‎
‎---
‎
‎### 🪟 For Windows:
‎```bat
‎codex-ipchanger-WINDOWS.exe
‎```
‎✅ click on code and download zip file
‎✅ Runs from terminal or double-click run as administrator "codex-ipchanger-WINDOWS.exe"
‎✅ It will present some option to you 
‎
‎      ✅1. INSTALL Tor ( to install configuration )
‎
‎      ✅2. Run tor ( to run the tor )
‎         
‎    ✅3. Stop Tor ( for stop the tor )
‎      
‎      ✅4. connect tor with Windows ( for connect all the configuration with windows )
‎
‎      ✅5. Disconnect Tor from Windows ( for disconnect everything from Windows )
‎
‎      ✅6. IP changer timer ( to select the time duration minimum 15s but you can use 10s ) 
‎
‎        ✅7. Start changing IP ( for start changing the IP to stay anonymous )
‎ 
‎        ✅8. Exit ( for exit the tool )
‎
‎## HOW TO START THE WINDOWS TOOL
‎
‎1. start option 1 ( IF YOU DOING FIRST TIME )
‎
‎2. then use the second option to run the tor ( remember when you select option 2 it will create a new window don't cut that window minimize it because it is necessary for running the tool )
‎
‎3. after that use option 4 to connect the tool with your computer 
‎
‎4. afte that use option 7 to start the IP changing process 
‎
‎congratulation your IP is change successfully 
‎
‎##FOR STOP THE TOOL IN WINDOWS 
‎
‎1. Use the stop command and the disconnect command ( remember if you don't stop and use disconnect command you will lost your internet connection )
‎
‎---
‎
‎## 📸 Preview Output
‎
‎```bash
‎🌐 New IP: 185.220.101.45 ✅
‎[Proxy]: 127.0.0.1:8118 🛰️
‎```
‎
‎---
‎
‎## 🔌 Stop / Exit
‎
‎Press `CTRL + C` to stop the script at any time.  
‎✅ Linux & Windows will automatically revert proxy settings to default.  
‎⚠️ On Termux, you must disable proxy manually from Wi-Fi settings.
‎
‎---
‎
‎## 🛡️ Disclaimer
‎
‎This tool is provided for **educational** and **cybersecurity learning** purposes only.  
‎Misuse of this tool and code is not the author’s responsibility.
‎
‎---
‎
‎## 👤 Author
‎
‎- GitHub: [Network-pirate](https://github.com/Network-pirate)
‎- Coder: **Tawhed**
‎- Projects: `Codex IP Changer`, `CC-KILLER`, more coming soon!
