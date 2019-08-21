tabItem(
  tabName = "select_majors",
  fluidRow(
    box(
      width = 12,
      column(
        12,
        align = "center",
        h1("Select Majors")
      )
    )
  ),
  fluidRow(
    column(
      4,
      fluidRow(
        box(
          width = 12,
          title = "Select Major",
          id = "select_major_box",
          collapsible = TRUE,
          pickerInput(
            "pick_major",
            "",
            choices = setNames(majors_table$major, majors_table$display)
          ),
          br(),
          actionButton(
            "get_requirements",
            "Get Requirements"
          )
        )
      )
    ),
    box(
      width = 4,
      title = "Customize Major",
      column(
        12,
        align = "center",
        textInput("submit_custom_major_name", "Name", width = "33%"),
        actionButton(
          "submit_custom_major",
          "Submit Major",
          style = "color: #fff; background-color: #07b710; border-color: #07b710;"
        )
      ),
      br(),
      fluidRow(
        column(
          12,
          br(),
          rHandsontableOutput("major_handson_table"),
          "The Code is a course code (up to 10 digits) such as ECON 0110"
        )
      )
    ),
    box(
      width = 4,
      title = "Built Majors",
      DTOutput("built_majors_table")
    )
  )
)