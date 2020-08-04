head <- dashboardHeader(
  title = "Course Planner"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "sidebar",
    menuItem(
      text = "Select Courses",
      tabName = "select_courses",
      icon = icon("clipboard-list")
    ),
    menuItem(
      text = "Select Majors",
      tabName = "select_majors",
      icon = icon("graduation-cap")
    ),
    menuItem(
      text = "Saved Inputs",
      tabName = "saved_inputs",
      icon = icon("archive")
    )
  )
)

body <- dashboardBody(
  useShinyjs(),
  useShinyFeedback(),
  tags$script(src = "semester_module.js"),
  tabItems(
    select_courses_module_ui("courses"),
    majors_module_ui("majors"),
    saved_inputs_module_ui("saved")
  )
)

ui <- dashboardPage(
  head,
  sidebar,
  body,
  skin = 'black'
)
