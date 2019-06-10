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
      actionButton("add_course_by_department", "Add Course by Department"),
      actionButton("add_course_custom", "Add Custom Course"),
      br(),
      br(),
      fluidRow(
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 1",
            textOutput("semester1_text")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 3",
            textOutput("semester3_text")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 5",
            textOutput("semester5_text")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 7",
            textOutput("semester7_text")
          )
        )
      ),
      fluidRow(
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 2",
            textOutput("semester2_text")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 4",
            textOutput("semester4_text")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 6",
            textOutput("semester6_text")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 8",
            textOutput("semester8_text")
          )
        )
      )
    )
  )
)
