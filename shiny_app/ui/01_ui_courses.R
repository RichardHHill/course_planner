tabItem(
  tabName = "select_courses",
  fluidRow(
    box(
      width = 12,
      fluidRow(
        column(
          12,
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
    uiOutput("major_tables_ui")
  )
)
