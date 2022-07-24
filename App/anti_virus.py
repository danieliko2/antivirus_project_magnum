import csv
import selenium
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


browser = webdriver.Firefox(executable_path="./drivers/geckodriver")
wait = WebDriverWait(browser, 3)
visible = EC.visibility_of_element_located

# def testPage(page):
#     browser.get(page)
#     wait.until(visible((By.ID, "video-title")))
#     browser.find_element_by_id("video-title").click()
#     browser.minimize_window()
#     time.sleep(7)
#     browser.quit()

# testPage("http://www.google.com")

def print_me(me):
    print(me)

print("")

def add_ip(ipData):
    with open("data/data.csv", "a") as f:
        write = csv.writer(f)
        write.writerow(ipData)
