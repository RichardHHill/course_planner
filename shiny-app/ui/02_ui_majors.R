tabItem(
  tabName = "select_majors",
  fluidRow(
    box(
      width = 4,
      pickerInput(
        "pick_major",
        "Choose a Major",
        choices = c(
          "Math AB",
          "Econ AB"
        )
      ),
      br(),
      actionButton(
        "get_requirements_1",
        "Get Requirements"
      )
    )
  )
)