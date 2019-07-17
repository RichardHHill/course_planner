tabItem(
  tabName = "select_courses",
  fluidRow(
    column(
      12,
      actionButton(
        "save_all_inputs",
        "Save Inputs",
        style = "background-color: #46c410; color: #fff",
        icon = icon("plus")
      )
    )
  ),
  br(),
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
    major_table_module_ui("1"),
    major_table_module_ui("2"),
    major_table_module_ui("3")
  )
)
