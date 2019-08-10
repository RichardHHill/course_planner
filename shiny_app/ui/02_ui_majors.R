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
        ),
        div(
          id = "chosen_major_courses_box",
          box(
            width = 12,
            title = "Selected Courses",
            div(
              id = "major_chosen",
              column(
                12,
                align = "center",
                h2("Double click a cell to edit"),
                br(),
                textInput("submit_major_name", "Name", width = "33%"),
                actionButton(
                  "submit_major",
                  "Submit Major",
                  style = "color: #fff; background-color: #07b710; border-color: #07b710;"
                )
              )
            ),
            br(),
            DTOutput("major_courses_table")
          )
        ) %>% hidden()
      )
    ),
    box(
      width = 4,
      title = "Custom Major",
      column(
        12,
        align = "center",
        textInput("submit_custom_major_name", "Name", width = "33%"),
        actionButton(
          "submit_custom_major",
          "Submit Major",
          style = "color: #fff; background-color: #07b710; border-color: #07b710;"
        )
      )
    ),
    box(
      width = 4,
      title = "Majors",
      DTOutput("built_majors_table")
    )
  )
)