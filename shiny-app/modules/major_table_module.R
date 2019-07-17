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
  
  major_courses_table_prep <- reactive({
    req(major_course_vector())
    selected_courses <- major_course_vector()
    course_names <- unlist(lapply(selected_courses, helpers$course_code_to_name))
    
    in_schedule <- selected_courses %in% schedule_list()
    in_schedule <- lapply(in_schedule, function(x) {
      if (isTRUE(x)) {
        as.character(icon("check-circle"))
      } else {
        as.character(icon("circle"))
      }
    })
    
    need_approval <- c("Flex Course", "Capstone")
    
    course_names[selected_courses %in% need_approval] <- "To be approved by a Concentration Advisor"
    in_schedule[selected_courses %in% need_approval] <- ""

    tibble(
      "Course Code" = selected_courses,
      "Course Name" = course_names,
      "Satisfied" = in_schedule
    )
  })
  
  output$major_courses_table <- renderDT({
    table <- major_courses_table_prep()
    datatable(
      table,
      rownames = FALSE,
      escape = FALSE,
      options = list(
        dom = "t",
        pageLength = 25
      )
    )
  })
  
}
