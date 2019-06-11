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
        actionButton("submit_course_department", "Add Course"),
        modalButton("Cancel")
      )
    )
  )
  
  observeEvent(input$department_to_add, {
    removeUI(selector = "#course_to_add")
    
    department <- input$department_to_add
    insertUI(
      selector = "#column_for_course_picker",
      where = "afterEnd",
      div(
        id = "course_to_add",
        pickerInput(
          "course_to_add",
          "Course",
          choices = paste(department_list[[department]][[1]], department_list[[department]][[2]])
        )
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
            "pick_semester",
            "Pick Semester",
            choices = c(
              "Semester 1", "Semester 2", "Semester 3", "Semester 4",
              "Semester 5", "Semester 6", "Semester 7", "Semester 8"
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


semesters <- reactiveValues()

semester1_out <- reactive({
  req(semesters$semester1)
  out <- semesters$semester1
    tibble(
      "Code" = substr(out, 1, 9),
      "Course" = substr(out, 10, nchar(out))
    )
})

output$semester1_text <- renderDT({
  out <- semester1_out()
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})

output$semester2_text <- renderDT({
  req(semesters$semester2)
  out <- semesters$semester2
  datatable(
    tibble(
      "Code" = substr(out, 1, 9),
      "Course" = substr(out, 10, nchar(out))
    ),
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})

output$semester3_text <- renderDT({
  req(semesters$semester3)
  out <- semesters$semester3
  datatable(
    tibble(
      "Code" = substr(out, 1, 9),
      "Course" = substr(out, 10, nchar(out))
    ),
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})

output$semester4_text <- renderDT({
  req(semesters$semester4)
  out <- semesters$semester4
  datatable(
    tibble(
      "Code" = substr(out, 1, 9),
      "Course" = substr(out, 10, nchar(out))
    ),
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})

output$semester5_text <- renderDT({
  req(semesters$semester5)
  out <- semesters$semester5
  datatable(
    tibble(
      "Code" = substr(out, 1, 9),
      "Course" = substr(out, 10, nchar(out))
    ),
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})

output$semester6_text <- renderDT({
  req(semesters$semester6)
  out <- semesters$semester6
  datatable(
    tibble(
      "Code" = substr(out, 1, 9),
      "Course" = substr(out, 10, nchar(out))
    ),
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})

output$semester7_text <- renderDT({
  req(semesters$semester7)
  out <- semesters$semester7
  datatable(
    tibble(
      "Code" = substr(out, 1, 9),
      "Course" = substr(out, 10, nchar(out))
    ),
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})

output$semester8_text <- renderDT({
  req(semesters$semester8)
  out <- semesters$semester8
  datatable(
    tibble(
      "Code" = substr(out, 1, 9),
      "Course" = substr(out, 10, nchar(out))
    ),
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})

