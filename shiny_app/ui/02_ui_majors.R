tabItem(
  tabName = "select_majors",
  fluidRow(
    box(
      width = 12,
      column(
        12,
        align = "center",
        h1("Select Majors")
      )
    )
  ),
  fluidRow(
    box(
      width = 4,
      title = "Choose a Major",
      pickerInput(
        "pick_major",
        "",
        choices = setNames(majors_table$major, majors_table$display)
      ),
      br(),
      actionButton(
        "get_requirements",
        "Get Requirements"
      )
    ),
    box(
      width = 4,
      title = "Selected Courses",
      DTOutput("major_course_table")
    ),
    box(
      width = 4,
      title = "Majors",
      fluidRow(column(12,h3("To Do: Show, delete, reload")))
    )
  )
  # fluidRow(
  #   input_major_module_ui(id = "1"),
  #   input_major_module_ui(id = "2"),
  #   input_major_module_ui(id = "3")
  # )
)