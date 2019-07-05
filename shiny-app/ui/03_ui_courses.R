tabItem(
  tabName = "select_courses",
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
            DTOutput("semester1_table")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 3",
            DTOutput("semester3_table")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 5",
            DTOutput("semester5_table")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 7",
            DTOutput("semester7_table")
          )
        )
      ),
      fluidRow(
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 2",
            DTOutput("semester2_table")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 4",
            DTOutput("semester4_table")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 6",
            DTOutput("semester6_table")
          )
        ),
        column(
          width = 3,
          box(
            width = 12,
            title = "Semester 8",
            DTOutput("semester8_table")
          )
        )
      )
    )
  ),
  fluidRow(
    column(
      4,
      div(
        id = "major_1_output",
        fluidRow(
          box(
            width = 12,
            title = textOutput("major_1_name"),
            DTOutput("major_1_courses_table")
          )
        )
      ) %>% hidden()
    ),
    column(
      4,
      div(
        id = "major_2_output",
        fluidRow(
          box(
            width = 12,
            title = textOutput("major_2_name"),
            DTOutput("major_2_courses_table")
          )
        )
      ) %>% hidden()
    ),
    column(
      4,
      div(
        id = "major_3_output",
        fluidRow(
          box(
            width = 12,
            title = textOutput("major_3_name"),
            DTOutput("major_3_courses_table")
          )
        )
      ) %>% hidden()
    )
  )
)
