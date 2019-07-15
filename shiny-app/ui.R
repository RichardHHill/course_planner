head <- dashboardHeader(
  title = "Dashboard"
)

sidebar <- dashboardSidebar(
  useShinyjs(),
  sidebarMenu(
    id = "sidebar",
    menuItem(
      text = "Dashboard",
      tabName = "dashboard",
      icon = icon("home")
    ),
    menuItem(
      text = "Select Majors",
      tabName = "select_majors",
      icon = icon("graduation-cap")
    ),
    menuItem(
      text = "Select Courses",
      tabName = "select_courses",
      icon = icon("clipboard-list")
    )
  )
)

body <- dashboardBody(
  shiny::tags$head(
    #tags$link(rel = "shortcut icon", href = "logo.png"),
    tags$script(src = "custom.js"),
    tags$script(src = "myModuleJS.js")
    #tags$link(rel = "stylesheet", href = "styles.css")
  ),
  
  tabItems(
    source("ui/01_ui_dashboard.R", local = TRUE)$value,
    source("ui/02_ui_majors.R", local = TRUE)$value,
    source("ui/03_ui_courses.R", local = TRUE)$value
  )
)

ui <- dashboardPage(
  head,
  sidebar,
  body,
  skin = 'black'
)
