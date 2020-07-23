
import sqlite3
from bs4 import BeautifulSoup
from selenium import webdriver
import chromedriver_binary
import time

# Set Up Database

# conn = sqlite3.connect("shiny_app/course_data.db")
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

department_rows = doc.find(id="crit-dept").find_all("option")

all_departments = {}
for department in department_rows:
    if department["value"]:
        all_departments[department["value"]] = department.text
        # c.execute("INSERT INTO departments VALUES(?,?)",
        # (department["value"], department.text))

search_input = driver.find_element_by_id("crit-keyword")
semester_picker = driver.find_element_by_id("crit-srcdb")
search_button = driver.find_element_by_id("search-button")

for semester in all_semesters:
    for department in all_departments.keys():
        
        search_input.clear()
        search_input.send_keys(department)
        semester_picker.send_keys(semester)
        
        search_button.click()

        # As of the writing of this script, there are 986 combinations
        # A wait time of 5 seconds, which gives the webpage ample
        # time to load, even at its slowest, will cause the script to 
        # take over 82 minutes
        #time.sleep(3)

        doc = BeautifulSoup(driver.page_source, "html.parser")

        rows = doc.find_all("span", {"class": "result__headline"})

        for row in rows:
            code = row.find("span", {"class": "result__code"}).text
            name = row.find("span", {"class": "result__title"}).text

            #if code[:4] == department and "XLIST" not in code:
                # c.execute("INSERT INTO courses VALUES(?,?,?,?)",
                # (code, name, department, semester))
    
#conn.commit()
