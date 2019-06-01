head <- dashboardHeader(
  title = "Dashboard"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "sidebar",
    menuItem(
      text = "Dashboard",
      tabName = "dashboard",
      icon = icon("clipboard-list")
    ),
    menuItem(
      text = "Select Majors",
      tabName = "select_majors",
      icon = icon("graduation-cap")
    )
  )
)

body <- dashboardBody(
  tabItems(
    source("ui/01_ui_dashboard.R", local = TRUE)$value,
    source("ui/02_ui_majors.R", local = TRUE)$value
  )
)

ui <- dashboardPage(
  head,
  sidebar,
  body,
  skin = 'black'
)
