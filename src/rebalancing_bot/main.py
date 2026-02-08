import os
import platform
# from dotenv import load_dotenv

def main():
    # load_dotenv()
    print("UPDATED BOT STARTUP MESSAGE")
    print("========================================")
    print("🚀 BOT STARTUP SUCCESSFUL")
    print(f"📍 ARCHITECTURE: {platform.machine()}")
    print(f"🏠 SYSTEM: {platform.system()} {platform.release()}")
    print(f"📦 MODE: {os.getenv('ENV', 'development')}")
    print("========================================")
    print("Hello World! The rebalancing bot is ready.")
    print("****************************************")
    print(f"HELLO WORLD FROM {platform.node()}!")
    print(f"Running on: {platform.machine()} ({platform.system()})")
    print(f"App Version: 0.1.0")
    print("****************************************")

if __name__ == "__main__":
    main()