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
              "MATH", "ECON", "APMA", "PHYS"
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
  removeUI(selector = "#course_to_add")
  removeModal()
  removeUI(selector = "#course_to_add")
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

#to get major table to render without courses in every semester
semester1_to_list <- reactiveVal(NULL)
observe(semester1_to_list(semester1_out()$Code))

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


semester2_out <- reactive({
  req(semesters$semester2)
  out <- semesters$semester2
  
  tibble(
    "Code" = substr(out, 1, 9),
    "Course" = substr(out, 10, nchar(out))
  )
})

semester2_to_list <- reactiveVal(NULL)
observe(semester2_to_list(semester2_out()$Code))

output$semester2_text <- renderDT({
  out <- semester2_out()
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})


semester3_out <- reactive({
  req(semesters$semester3)
  out <- semesters$semester3
  
  tibble(
    "Code" = substr(out, 1, 9),
    "Course" = substr(out, 10, nchar(out))
  )
})

semester3_to_list <- reactiveVal(NULL)
observe(semester3_to_list(semester3_out()$Code))

output$semester3_text <- renderDT({
  out <- semester3_out()
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})


semester4_out <- reactive({
  req(semesters$semester4)
  out <- semesters$semester4
  
  tibble(
    "Code" = substr(out, 1, 9),
    "Course" = substr(out, 10, nchar(out))
  )
})

semester4_to_list <- reactiveVal(NULL)
observe(semester4_to_list(semester4_out()$Code))

output$semester4_text <- renderDT({
  out <- semester4_out()
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})


semester5_out <- reactive({
  req(semesters$semester5)
  out <- semesters$semester5
  
  tibble(
    "Code" = substr(out, 1, 9),
    "Course" = substr(out, 10, nchar(out))
  )
})

semester5_to_list <- reactiveVal(NULL)
observe(semester5_to_list(semester5_out()$Code))

output$semester5_text <- renderDT({
  out <- semester5_out()
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})


semester6_out <- reactive({
  req(semesters$semester6)
  out <- semesters$semester6
  
  tibble(
    "Code" = substr(out, 1, 9),
    "Course" = substr(out, 10, nchar(out))
  )
})

semester6_to_list <- reactiveVal(NULL)
observe(semester6_to_list(semester6_out()$Code))

output$semester6_text <- renderDT({
  out <- semester6_out()
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})


semester7_out <- reactive({
  req(semesters$semester7)
  out <- semesters$semester7
  
  tibble(
    "Code" = substr(out, 1, 9),
    "Course" = substr(out, 10, nchar(out))
  )
})

semester7_to_list <- reactiveVal(NULL)
observe(semester7_to_list(semester7_out()$Code))

output$semester7_text <- renderDT({
  out <- semester7_out()
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})


semester8_out <- reactive({
  req(semesters$semester8)
  out <- semesters$semester8
  
  tibble(
    "Code" = substr(out, 1, 9),
    "Course" = substr(out, 10, nchar(out))
  )
})

semester8_to_list <- reactiveVal(NULL)
observe(semester8_to_list(semester8_out()$Code))

output$semester8_text <- renderDT({
  out <- semester8_out()
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})

