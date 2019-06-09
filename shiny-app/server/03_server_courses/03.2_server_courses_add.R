observeEvent(input$add_course_by_department, {
  showModal(
    modalDialog(
      fluidRow(
        column(
          width = 6,
          pickerInput(
            "department_to_add",
            "Department",
            choices = c(
              "MATH", "ECON"
            ),
            multiple = TRUE,
            options = pickerOptions(
              maxOptions = 1
            )
          )
        ),
        column(
          width = 6,
          div(
            id = "column_for_course_picker"
          )
        )
      ),
      title = "Add Course",
      size = "m",
      footer = list(
        modalButton("Cancel")
      )
    )
  )
  
  observeEvent(input$department_to_add, {
    insertUI(
      selector = "#column_for_course_picker",
      where = "afterEnd",
      pickerInput(
        "course_to_add",
        "Course",
        choices = "Math 0050"
      )
    )
  })
})

observeEvent(input$add_course_custom, {
  showModal(
    modalDialog(
      fluidRow(
        column(
          width = 6,
          textInput("custom_course_to_add_code", "Course Code", placeholder = "ECON 0110"),
          textInput("custom_course_to_add_name", "Course Name", placeholder = "Principles of Economics")
        )
      ),
      title = "Add Course",
      size = "m",
      footer = list(
        modalButton("Cancel")
      )
    )
  )
}, ignoreInit = TRUE)

