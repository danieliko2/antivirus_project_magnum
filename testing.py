import selenium
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import csv


# browser = webdriver.Firefox(executable_path="/home/john/Desktop/antivirus project/drivers/geckodriver")
# wait = WebDriverWait(browser, 3)
# visible = EC.visibility_of_element_located

# def testPage(page):
#     browser.get(page)
#     wait.until(visible((By.ID, "video-title")))
#     browser.find_element_by_id("video-title").click()
#     browser.minimize_window()
#     time.sleep(7)
#     browser.quit()

def get_ips():
    with open("data/data.csv", "r") as f:
        csvRead = csv.reader(f)
        rows = list(csvRead)
        print(rows)

get_ips()