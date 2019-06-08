tabItem(
  tabName = "select_courses",
  div(
    id = "major_output",
    fluidRow(
      box(
        width = 6,
        title = textOutput("major_name"),
        DTOutput("courses_table")
      )
    )
  ) %>% hidden(),
  fluidRow(
    box(
      width = 12,
      actionButton("add_course", "Add Course"),
      br(),
      br(),
      fluidRow(
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 1"
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 3"
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 5"
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 7"
          )
        )
      ),
      fluidRow(
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 2"
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 4"
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 6"
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 8"
          )
        )
      )
    )
  )
)
