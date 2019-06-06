tabItem(
  tabName = "select_courses",
  fluidRow(
    box(
      width = 9,
      textOutput("major_name"),
      DTOutput("courses_table")
    )
  )
)
