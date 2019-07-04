observeEvent(input$add_course_by_department, {
  showModal(
    modalDialog(
      fluidRow(
        column(
          width = 6,
          pickerInput(
            "pick_semester",
            "Pick Semester",
            choices = c(
              "Semester 1" = "semester1", "Semester 2" = "semester2",
              "Semester 3" = "semester3", "Semester 4" = "semester4",
              "Semester 5" = "semester5", "Semester 6" = "semester6",
              "Semester 7" = "semester7", "Semester 8" = "semester8"
            )
          ),
          pickerInput(
            "department_to_add",
            "Department",
            choices = c(
              "MATH", "ECON", "APMA", "PHYS", "CSCI"
            )
          )
        ),
        column(
          width = 6,
          pickerInput(
            "course_to_add",
            "Course",
            choices = paste(
              department_list[["MATH"]][[1]],
              department_list[["MATH"]][[2]]
            )
          )
        )
      ),
      title = "Add Course",
      size = "m",
      footer = list(
        actionButton("submit_course_department", "Add Course"),
        modalButton("Cancel")
      )
    )
  )
  
  observeEvent(input$department_to_add, {
    department <- input$department_to_add
    updatePickerInput(
      session,
      "course_to_add", 
      "Course",
      choices = paste(
        department_list[[department]][[1]],
        department_list[[department]][[2]]
      )
    )
  })
  
})

observeEvent(input$submit_course_department, {
  removeModal()
  req(input$course_to_add)
  course = input$course_to_add
  string = input$pick_semester
  semesters[[string]] <- c(semesters[[string]], course)
})

observeEvent(input$add_course_custom, {
  showModal(
    modalDialog(
      fluidRow(
        column(
          width = 6,
          pickerInput(
            "pick_semester_custom",
            "Pick Semester",
            choices = c(
              "Semester 1" = "semester1", "Semester 2" = "semester2",
              "Semester 3" = "semester3", "Semester 4" = "semester4",
              "Semester 5" = "semester5", "Semester 6" = "semester6",
              "Semester 7" = "semester7", "Semester 8" = "semester8"
            )
          )
        ),
        column(
          width = 6,
          textInput("custom_course_to_add_code", "Course Code", placeholder = "ECON 0110"),
          textInput("custom_course_to_add_name", "Course Name", placeholder = "Principles of Economics")
        )
      ),
      title = "Add Course",
      size = "m",
      footer = list(
        actionButton("submit_course_custom", "Add Course"),
        modalButton("Cancel")
      )
    )
  )
})



observeEvent(input$submit_course_custom, {
  code <- input$custom_course_to_add_code

  if (nchar(code) > 9) {
    code <- substr(code,1,9)
  } else if (nchar(code) < 9) {
    code <- paste0(code, strrep(" ", 9 - nchar(code)))
  }
  
  removeModal()
  course = paste(code, input$custom_course_to_add_name)
  string = input$pick_semester_custom
  semesters[[string]] <- c(semesters[[string]], course)
})

