tabItem(
  tabName = "select_courses",
  fluidRow(
    box(
      width = 12,
      fluidRow(
        column(
          6,
          actionButton("add_course_by_department", "Add Course by Department"),
          actionButton("add_course_custom", "Add Custom Course")
        ),
        column(
          6,
          align = "right",
          actionButton(
            "enable_delete_mode",
            "Delete Courses",
            style = "background-color: #dd4b39; border-color: #d73925; color: #fff"
          ),
          actionButton("disable_delete_mode", "Stop Deleting") %>% hidden
        )
      ),
      br(),
      br(),
      fluidRow(
        semester_module_ui(id = "1"),
        semester_module_ui(id = "3"),
        semester_module_ui(id = "5"),
        semester_module_ui(id = "7")
      ),
      fluidRow(
        semester_module_ui(id = "2"),
        semester_module_ui(id = "4"),
        semester_module_ui(id = "6"),
        semester_module_ui(id = "8")
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
            actionButton("set_inputs_1", "Set Inputs"),
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
