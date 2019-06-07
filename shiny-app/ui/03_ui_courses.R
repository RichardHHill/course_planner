tabItem(
  tabName = "select_courses",
  div(
    id = "major_output",
    fluidRow(
      box(
        width = 9,
        h2(textOutput("major_name")),
        br(),
        br(),
        DTOutput("courses_table")
      )
    )
  ) %>% hidden()
)
