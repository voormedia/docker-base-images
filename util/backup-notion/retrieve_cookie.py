from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import json
import os

USERNAME = os.getenv('NOTION_USERNAME')
PASSWORD = os.getenv('NOTION_PASSWORD')

def get_notion_token():
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")

    options.binary_location = "/usr/bin/chromium-browser"

    driver_service = Service("/usr/bin/chromedriver")

    with webdriver.Chrome(service=driver_service, options=options) as driver:
        driver.get("https://www.notion.so/login")
        time.sleep(2)
        
        print("Logging in...")
        time.sleep(10)
        driver.find_element(By.ID, "notion-email-input-2").send_keys(USERNAME + Keys.RETURN)
        driver.save_screenshot('/tmp/screenshot-email.png')
        time.sleep(10)
        driver.find_element(By.ID, "notion-password-input-1").send_keys(PASSWORD + Keys.RETURN)
        driver.save_screenshot('/tmp/screenshot-password.png')
        time.sleep(10)
        driver.find_element(By.XPATH, '//div[text()="Continue with password"]]').click()
        time.sleep(1)
        print("Logged in")
        # Retrieve the token_v2 cookie
        cookies = driver.get_cookies()
        token_v2 = next((cookie['value'] for cookie in cookies if cookie['name'] == 'token_v2'), None)

    with open("/srv/token.json", "w") as f:
        json.dump({"token_v2": token_v2}, f)
        print("Token saved to /srv/token.json")

    return token_v2

if __name__ == "__main__":
    get_notion_token()
