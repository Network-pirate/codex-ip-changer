import os
import subprocess
import time
import requests
import ctypes
from stem.control import Controller
from stem import Signal

ROOT = os.path.dirname(os.path.abspath(__file__))
TOR = os.path.join(ROOT, "tor", "tor.exe")
PRIVOXY = os.path.join(ROOT, "privoxy", "privoxy.exe")
PRIVOXY_CFG = os.path.join(ROOT, "privoxy", "config.txt")
TORRC = os.path.join(ROOT, "torrc_dynamic")
CONTROL_PORT = 9051
SOCKS_PORT = 9050
PRIVOXY_PORT = 8118

REG_CMD_ENABLE = [
    'reg', 'add', r'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
    '/v', 'ProxyEnable', '/t', 'REG_DWORD', '/d', '1', '/f'
]
REG_CMD_SET_SERVER = [
    'reg', 'add', r'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
    '/v', 'ProxyServer', '/t', 'REG_SZ', '/d', f'127.0.0.1:{PRIVOXY_PORT}', '/f'
]
REG_CMD_DISABLE = [
    'reg', 'add', r'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
    '/v', 'ProxyEnable', '/t', 'REG_DWORD', '/d', '0', '/f'
]

tor_proc = None
privoxy_proc = None

def set_windows_proxy():
    subprocess.run(REG_CMD_ENABLE, shell=True)
    subprocess.run(REG_CMD_SET_SERVER, shell=True)

def reset_windows_proxy():
    subprocess.run(REG_CMD_DISABLE, shell=True)

def generate_torrc(country_code=None):
    lines = [
        f"SocksPort {SOCKS_PORT}",
        f"ControlPort {CONTROL_PORT}",
        "CookieAuthentication 0"
    ]
    if country_code:
        lines.append(f"ExitNodes {{{country_code}}}")
        lines.append("StrictNodes 1")
    with open(TORRC, "w") as f:
        f.write("\n".join(lines))

def start_services():
    global tor_proc, privoxy_proc
    tor_proc = subprocess.Popen([TOR, "-f", TORRC], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    privoxy_proc = subprocess.Popen([PRIVOXY, PRIVOXY_CFG], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    time.sleep(10)
    set_windows_proxy()

def stop_services():
    global tor_proc, privoxy_proc
    if tor_proc: tor_proc.kill()
    if privoxy_proc: privoxy_proc.kill()
    reset_windows_proxy()

def signal_newnym():
    try:
        with Controller.from_port(port=CONTROL_PORT) as controller:
            controller.authenticate()
            controller.signal(Signal.NEWNYM)
    except Exception as e:
        print(f"[!] Error: {e}")

def get_ip():
    try:
        ip = requests.get("https://api64.ipify.org", proxies={
            "http": f"http://127.0.0.1:{PRIVOXY_PORT}",
            "https": f"http://127.0.0.1:{PRIVOXY_PORT}"
        }, timeout=10).text
        return ip
    except Exception as e:
        return f"[X] Could not fetch IP: {e}"

def random_mode(interval):
    generate_torrc()
    start_services()
    try:
        while True:
            signal_newnym()
            time.sleep(3)
            print(f"[+] New IP: {get_ip()}")
            time.sleep(interval)
    except KeyboardInterrupt:
        print("\n[!] Exiting and cleaning up...")
        stop_services()

def country_mode():
    countries = {
        "US": "United States", "DE": "Germany", "FR": "France", "IN": "India", "RU": "Russia", "CA": "Canada",
        "UK": "United Kingdom", "JP": "Japan", "CN": "China", "TR": "Turkey", "UA": "Ukraine", "AU": "Australia",
        "BR": "Brazil", "IT": "Italy", "KR": "South Korea", "SA": "Saudi Arabia", "SE": "Sweden", "NL": "Netherlands",
        "NO": "Norway", "ZA": "South Africa", "CH": "Switzerland", "MX": "Mexico", "PL": "Poland", "BE": "Belgium",
        "ES": "Spain", "SG": "Singapore", "AR": "Argentina", "BD": "Bangladesh", "PK": "Pakistan", "EG": "Egypt",
        "TH": "Thailand", "ID": "Indonesia", "PH": "Philippines", "VN": "Vietnam", "IR": "Iran", "FI": "Finland",
        "GR": "Greece", "CO": "Colombia", "NZ": "New Zealand", "MY": "Malaysia", "RO": "Romania", "HK": "Hong Kong",
        "IL": "Israel", "HU": "Hungary", "AE": "UAE"
    }

    print("Available Countries:")
    print("────────────────────")
    for code, name in countries.items():
        print(f"{code:<5} => {name}")

    code = input("\nEnter country code from the list above (e.g. US): ").strip().upper()
    interval = int(input("Enter rotation interval (sec): ").strip() or "15")
    generate_torrc(country_code=code)
    start_services()
    try:
        while True:
            signal_newnym()
            time.sleep(3)
            print(f"[+] New IP from {code}: {get_ip()}")
            time.sleep(interval)
    except KeyboardInterrupt:
        print("\n[!] Exiting and cleaning up...")
        stop_services()

def main():
    ctypes.windll.kernel32.SetConsoleTitleW("Codex IP Changer - Windows Edition")
    print("╔═════════════════════════════════════╗")
    print("║         CODEX IP CHANGER (Windows) ║")
    print("║         MADE BY TAWHED             ║")
    print("╠═════════════════════════════════════╣")
    print("║ [1] Random IP Rotation              ║")
    print("║ [2] Country-Based Rotation          ║")
    print("║ [3] Exit                            ║")
    print("╚═════════════════════════════════════╝")
    choice = input("Select option: ").strip()

    if choice == "1":
        interval = int(input("Enter rotation interval (sec): ").strip() or "15")
        random_mode(interval)
    elif choice == "2":
        country_mode()
    else:
        print("Goodbye.")

if __name__ == "__main__":
    main()