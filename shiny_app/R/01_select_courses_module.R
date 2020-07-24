
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
              style = "background-color: #dd4b39; border-color: #d73925; color: #fff"
            ),
            actionButton(ns("disable_delete_mode"), "Stop Deleting") %>% hidden
          )
        ),
        br(),
        br(),
        fluidRow(
          semester_module_ui(ns("1")),
          semester_module_ui(ns("3")),
          semester_module_ui(ns("5")),
          semester_module_ui(ns("7"))
        ),
        fluidRow(
          semester_module_ui(ns("2")),
          semester_module_ui(ns("4")),
          semester_module_ui(ns("6")),
          semester_module_ui(ns("8"))
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
  
  #creates 8 semester tables
  callModule(semester_module, "1", id = 1, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["1-semester_remove"]]))
  callModule(semester_module, "2", id = 2, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["2-semester_remove"]]))
  callModule(semester_module, "3", id = 3, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["3-semester_remove"]]))
  callModule(semester_module, "4", id = 4, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["4-semester_remove"]]))
  callModule(semester_module, "5", id = 5, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["5-semester_remove"]]))
  callModule(semester_module, "6", id = 6, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["6-semester_remove"]]))
  callModule(semester_module, "7", id = 7, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["7-semester_remove"]]))
  callModule(semester_module, "8", id = 8, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["8-semester_remove"]]))
  
  
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
      
      in_schedule <- lapply(toupper(course_codes) %in% toupper(schedule_list()), function(x) {
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
