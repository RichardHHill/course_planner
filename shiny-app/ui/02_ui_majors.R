tabItem(
  tabName = "select_majors",
  fluidRow(
    box(
      width = 4,
      pickerInput(
        "pick_major_1",
        "Choose a Major",
        choices = display_majors
      ),
      br(),
      actionButton(
        "get_requirements_1",
        "Get Requirements"
      )
    ),
    box(
      width = 4,
      pickerInput(
        "pick_major_2",
        "Choose a Second Major",
        choices = display_majors
      ),
      br(),
      actionButton(
        "get_requirements_2",
        "Get Requirements"
      )
    )
  )
)