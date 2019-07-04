#creates 8 semester tables

semesters <- reactiveValues()

semester1_out <- reactiveVal(NULL)

semester1_out <- reactive({
  req(semesters$semester1)
  out <- semesters$semester1
  id <- seq_along(out)
  
  buttons <- paste0('<button class="btn btn-danger btn-sm deselect_btn" data-toggle="tooltip" data-placement="top" title="Remove Course" id = ', id, ' style="margin: 0"><i class="fa fa-minus-circle"></i></button></div>')
  
  table <- tibble(
    "ID" = id,
    "Remove" = buttons,
    "Code" = substr(out, 1, 9),
    "Course" = substr(out, 10, nchar(out))
  )
  
  #semester1_out(table)
})

#to get major table to render without courses in every semester
semester1_to_list <- reactiveVal(NULL)
observe(semester1_to_list(semester1_out()$Code))

output$semester1_text <- renderDT({
  out <- semester1_out()[, 2:4]
  datatable(
    out,
    rownames = FALSE,
    options = list(
      dom = "t"
    ),
    escape = -1,
    selection = "none"
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
    ),
    escape = -1,
    selection = "none"
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
