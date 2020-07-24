
import sqlite3
from bs4 import BeautifulSoup
from selenium import webdriver
import chromedriver_binary
import time
import re

# Set Up Database

# conn = sqlite3.connect("shiny_app/data/course_data_new.db")
# c = conn.cursor()

# c.execute("DROP TABLE IF EXISTS departments;")
# c.execute("DROP TABLE IF EXISTS courses;")

# c.execute('''CREATE TABLE departments(
#     code TEXT PRIMARY KEY,
#     name TEXT);''')

# c.execute('''CREATE TABLE courses(
#     course_code TEXT,
#     name TEXT,
#     department TEXT,
#     semester TEXT);''')


# Web Scrape
URL = "https://cab.brown.edu"

driver = webdriver.Chrome()
driver.get(URL)

# Get Departments and Semesters
doc = BeautifulSoup(driver.page_source, "html.parser")

semester_rows = doc.find(id="crit-srcdb").find_all("option")

all_semesters = []
for semester in semester_rows:
    all_semesters.append(semester.text)

department_rows = doc.find(id="crit-subject").find_all("option")

all_departments = {}
for department in department_rows:
    if department["value"]:
        description = re.sub(r" ?\([^)]+\)", "", department.text)
        all_departments[department["value"]] = description

        # c.execute("INSERT INTO departments VALUES(?,?)",
        # (department["value"], description))

search_input = driver.find_element_by_id("crit-keyword")
semester_picker = driver.find_element_by_id("crit-srcdb")
search_button = driver.find_element_by_id("search-button")

for semester in all_semesters:
    for department in all_departments.keys():
        
        search_input.clear()
        search_input.send_keys(department)
        semester_picker.send_keys(semester)
        
        search_button.click()

        # As of the writing of this script, there are about 1600 combinations
        # A wait time of 3 seconds, which gives the webpage ample
        # time to load, even at its slowest, will cause the script to 
        # take over 80 minutes
        #time.sleep(3)

        doc = BeautifulSoup(driver.page_source, "html.parser")

        rows = doc.find_all("span", {"class": "result__headline"})

        for row in rows:
            code = row.find("span", {"class": "result__code"}).text
            name = row.find("span", {"class": "result__title"}).text

            if code[:4] == department and "XLIST" not in code:
                # c.execute("INSERT INTO courses VALUES(?,?,?,?)",
                # (code, name, department, semester))
                print(code)
    
#conn.commit()
print("done")
