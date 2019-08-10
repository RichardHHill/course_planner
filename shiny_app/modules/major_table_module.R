major_table_module_ui <- function(id) {
  ns <- NS(id)

  box(
    width = 4,
    title = textOutput(ns("major_name")),
    DTOutput(ns("major_courses_table"))
  )
}

major_table_module <- function(input, output, server, table, name) {
  browser()
  output$major_name <- renderText({
    name()
  })
  
  output$major_courses_table <- renderDT({
    
    datatable(
      table(),
      rownames = FALSE,
      escape = -3,
      options = list(
        dom = "t",
        pageLength = 25
      ),
      selection = "none"
    )
  })
}
