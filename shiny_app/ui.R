head <- dashboardHeader(
  title = "Dashboard"
)

sidebar <- dashboardSidebar(
  fluidRow(
    column(
      12,
      align = "center",
      actionButton(
        "save_all_inputs",
        "Save Inputs",
        style = "background-color: #07b710; color: #fff; border-color: #07b710",
        icon = icon("plus"),
        width = "90%"
      )
    )
  ),
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
  shiny::tags$head(
    tags$script(src = "custom.js"),
    tags$script(src = "myModuleJS.js"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"),
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css")
  ),
  useShinyjs(),
  extendShinyjs(script = "www/shinyjs.js"),
  tabItems(
    source("ui/01_ui_courses.R", local = TRUE)$value,
    source("ui/02_ui_majors.R", local = TRUE)$value,
    source("ui/03_ui_saved_inputs.R", local = TRUE)$value
  )
)

ui <- dashboardPage(
  head,
  sidebar,
  body,
  skin = 'black'
)
