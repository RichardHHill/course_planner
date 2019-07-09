#creates 8 semester tables

semesters <- reactiveValues()
delete_mode <- reactiveVal(FALSE)

observeEvent(input$enable_delete_mode, {
  delete_mode(TRUE)
  hide("enable_delete_mode")
  show("disable_delete_mode")
})

observeEvent(input$disable_delete_mode, {
  delete_mode(FALSE)
  hide("disable_delete_mode")
  show("enable_delete_mode")
})

###
# Semester 1
###

semester1_courses <- reactiveVal()
callModule(semester_module, "1", delete_mode = delete_mode, courses = semester1_courses, semester_remove = reactive(input[["1-semester_remove"]]))

###
# Semester 2
###

semester2_out <- reactiveVal()

observe({
  out <- semesters$semester2
  id <- seq_along(out)
  
  table <- tibble(
    "Code" = substr(out, 1, 10),
    "Course" = substr(out, 11, nchar(out))
  )
  
  if (delete_mode() & length(out) > 0) {
    buttons <- paste0('<button class="btn btn-danger btn-sm deselect_btn" data-toggle="tooltip" data-placement="top" title="Remove Course" id = ', id, ' style="margin: 0"><i class="fa fa-minus-circle"></i></button></div>')
    
    buttons <- tibble(
      "Remove" = buttons
    )
    table <- bind_cols(
      buttons,
      table
    )
  }
  
  semester2_out(table)
})


#to get major table to render without courses in every semester
semester2_to_list <- reactiveVal(NULL)
observe(semester2_to_list(semester2_out()$Code))

output$semester2_table <- renderDT({
  #Require the list of courses 
  req(semesters$semester2, nrow(semester2_out()))
  
  out <- semester2_out()
  datatable(
    out,
    rownames = FALSE,
    colnames = rep("", length(out)),
    options = list(
      dom = "t",
      ordering = FALSE
    ),
    escape = -1,
    selection = "none"
  )
})


semester3_out <- reactive({
  req(semesters$semester3)
  out <- semesters$semester3
  
  tibble(
    "Code" = substr(out, 1, 10),
    "Course" = substr(out, 11, nchar(out))
  )
})

semester3_to_list <- reactiveVal(NULL)
observe(semester3_to_list(semester3_out()$Code))

output$semester3_table <- renderDT({
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

output$semester4_table <- renderDT({
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

output$semester5_table <- renderDT({
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

output$semester6_table <- renderDT({
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

output$semester7_table <- renderDT({
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

output$semester8_table <- renderDT({
  out <- semester8_out()
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    )
  )
})
