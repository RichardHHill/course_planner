tabItem(
  tabName = "select_majors",
  fluidRow(
    box(
      width = 12,
      column(
        12,
        align = "center",
        h1("Compare Majors")
      )
    )
  ),
  fluidRow(
    input_major_module_ui(id = "1"),
    input_major_module_ui(id = "2"),
    input_major_module_ui(id = "3")
  )
)