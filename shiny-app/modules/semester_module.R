# Module for creating a semester used on the courses tab

semester_module_ui <- function(id) {
  ns <- NS(id)
  
  column(
    width = 3,
    box(
      width = 12,
      title = "Semester",
      DTOutput(ns("semester_table"))
    )
  )
}

semester_module <- function(input, output, session, delete_mode) {
  courses <- reactiveVal()
  semester_out <- reactiveVal()
  
  observe({
    out <- courses()
    ids <- seq_along(out)
    
    table <- tibble(
      "Code" = substr(out, 1, 10),
      "Course" = substr(out, 11, nchar(out))
    )
    
    if (delete_mode() & length(out) > 0) {
      buttons <- paste0('<button class="btn btn-danger btn-sm deselect_btn" data-toggle="tooltip" data-placement="top" title="Remove Course" id = ', ids, ' style="margin: 0"><i class="fa fa-minus-circle"></i></button></div>')
      
      buttons <- tibble(
        "Remove" = buttons
      )
      table <- bind_cols(
        buttons,
        table
      )
    }
    
    semester_out(table)
  })
  
  
  #to get major table to render without courses in every semester
  semester_to_list <- reactiveVal(NULL)
  observe(semester_to_list(semester_out()$Code))
  
  output$semester_table <- renderDT({
    #Require the list of courses 
    req(courses, nrow(semester_out()))
    
    out <- semester_out()
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
}
