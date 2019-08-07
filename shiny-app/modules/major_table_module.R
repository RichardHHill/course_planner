major_table_module_ui <- function(id) {
  ns <- NS(id)
  
  column(
    4,
    div(
      id = ns("major_output"),
      fluidRow(
        box(
          width = 12,
          title = textOutput(ns("major_name")),
          #actionButton(ns("set_inputs"), "Set Inputs"),
          DTOutput(ns("major_courses_table"))
        )
      )
    ) %>% shinyjs::hidden()
  )
}

major_table_module <- function(input, output, server, major_course_vector, name, shown, schedule_list) {
  
  output$major_name <- renderText({
    name()
  })
  
  observeEvent(shown(), {
    if (isTRUE(shown())) {
      shinyjs::show("major_output")
    } else {
      shinyjs::hide("major_output")
    }
  })
  
  major_courses_table_prep <- reactiveVal()
  
  observe({
    req(major_course_vector())
    
    selected_courses <- major_course_vector()
    course_names <- unlist(lapply(selected_courses, helpers$course_code_to_name))
    
    need_approval <- c("FlexCourse", "Capstone  ", "Approved  ", "Equivalent")

    course_names[selected_courses %in% need_approval] <- "To be approved by a Concentration Advisor"
    selected_courses[selected_courses %in% need_approval] <- "Input Code"
    
    
    out <- tibble(
      "Course Code" = selected_courses,
      "Course Name" = course_names
    )
    
    major_courses_table_prep(out)
  })
  
  courses_satisfied_column <- reactive({
    selected_courses <- major_courses_table_prep()[["Course Code"]]
    
    in_schedule <- selected_courses %in% schedule_list()
    in_schedule <- lapply(in_schedule, function(x) {
      if (isTRUE(x)) {
        as.character(icon("check-circle"))
      } else {
        as.character(icon("circle"))
      }
    })

    tibble("Satisfied" = unlist(in_schedule))
  })
  
  output$major_courses_table <- renderDT({
    table <- bind_cols(
      major_courses_table_prep(),
      courses_satisfied_column()
    )
    
    datatable(
      table,
      rownames = FALSE,
      escape = FALSE,
      options = list(
        dom = "t",
        pageLength = 25
      ),
      editable = TRUE,
      selection = "none"
    )
  })
  
  major_courses_proxy <- dataTableProxy("major_courses_table")

  
  observeEvent(input$major_courses_table_cell_edit, {
    hold <- input$major_courses_table_cell_edit
    out <- major_courses_table_prep()
    
    out[hold$row, hold$col + 1] <- hold$value
    
    major_courses_table_prep(out)
  })
  
}
