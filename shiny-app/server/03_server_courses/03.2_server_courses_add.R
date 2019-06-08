observeEvent(input$add_course, {
  showModal(
    modalDialog(
      fluidRow(
        pickerInput(
          "course_to_add",
          "Department",
          choices = c(
            "MATH", "ECON"
          )
        ),
        textInput("course_to_add_code", "Course Code"),
        textInput("course_to_add_name", "Course Name")
      ),
      title = "Add Course",
      size = "m",
      footer = list(
        modalButton("Cancel")
      )
    )
  )
})
