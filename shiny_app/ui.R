head <- dashboardHeader(
  title = "Course Planner"
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
