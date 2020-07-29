
select_courses_module_ui <- function(id) {
  ns <- NS(id)
  
  tabItem(
    tabName = "select_courses",
    fluidRow(
      box(
        width = 12,
        fluidRow(
          column(
            12,
            align = "right",
            actionButton(
              ns("enable_delete_mode"),
              "Delete Courses",
              class = "btn-danger",
              style = "color: #fff"
            ),
            actionButton(ns("disable_delete_mode"), "Stop Deleting") %>% hidden
          )
        ),
        br(),
        br(),
        fluidRow(
          semester_module_ui(ns("1"), "Semester 1"),
          semester_module_ui(ns("3"), "Semester 2"),
          semester_module_ui(ns("5"), "Semester 3"),
          semester_module_ui(ns("7"), "Semester 4")
        ),
        fluidRow(
          semester_module_ui(ns("2"), "Semester 5"),
          semester_module_ui(ns("4"), "Semester 6"),
          semester_module_ui(ns("6"), "Semester 7"),
          semester_module_ui(ns("8"), "Semester 8")
        )
      )
    ),
    fluidRow(
      uiOutput(ns("major_tables_ui"))
    )
  )
}

select_courses_module <- function(input, output, session, semesters, built_majors) {
  
  
  delete_mode <- reactiveVal(FALSE)
  
  observeEvent(input$enable_delete_mode, {
    delete_mode(TRUE)
    hideElement("enable_delete_mode")
    showElement("disable_delete_mode")
  })
  
  observeEvent(input$disable_delete_mode, {
    delete_mode(FALSE)
    hideElement("disable_delete_mode")
    showElement("enable_delete_mode")
  })
  
  # Create 8 semester tables
  lapply(1:8, function(i) callModule(semester_module, i, delete_mode, semesters, paste("Semester", i)))
  
  
  tables_list <- reactive({
    req(built_majors())
    built_majors <- built_majors()
    
    major_ids <- unique(built_majors$major_id)
    
    names <- built_majors %>% 
      select(major_name, major_id) %>% 
      distinct %>% 
      pull(major_name)
    
    
    out <- lapply(major_ids, function(id) {
      major <- built_majors %>% 
        filter(major_id == id)
      
      course_codes <- major$code
      
      schedule_list <- unlist(lapply(reactiveValuesToList(semesters), function(df) df$code))
      
      in_schedule <- lapply(toupper(course_codes) %in% toupper(schedule_list), function(x) {
        if (isTRUE(x)) {
          as.character(icon("check-circle"))
        } else {
          as.character(icon("circle"))
        }
      })
      
      tibble(
        code = course_codes,
        name = major$name,
        in_schedule = unlist(in_schedule)
      )
    })
    
    names(out) <- names
    out
  })
  
  
  output$major_tables_ui <- renderUI({
    tables <- tables_list()
    
    if (length(tables) == 0) {
      box(
        width = 12,
        fluidRow(
          column(
            12,
            align = "center",
            h2("Built Majors Will Show Up Here")
          )
        )
      )
    } else {
      lapply(seq_along(tables), function(x) {
        
        box(
          width = 4,
          title = names(tables)[[x]],
          datatable(
            tables[[x]],
            width = "100%",
            rownames = FALSE,
            colnames = c("Code", "Name", ""),
            options = list(
              dom = "t",
              pageLength = 25,
              scrollY = "400px"
            ),
            escape = -3,
            selection = "none"
          )
        )
      })
    }
  })
}
