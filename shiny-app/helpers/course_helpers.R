
(function() {
  #' course_code_to_name
  #' 
  #' @param code The 10-character course code
  #' 
  #' @return The equivalent name
  #' 
  #' @examples
  #' 
  course_code_to_name <- function(code) {
    department <- substr(code, 1, 5)
    department <- gsub(" ", "", department)

    department_table <- department_list[[department]]
    
    index <- match(substr(code, 1, 10), department_table$course_code)
    
    out <- department_table$course_name[[index]]

    if (is.null(out)) {
      out <- ""
    }
    
    out
  }
  
  return(list(
    "course_code_to_name" = course_code_to_name
  ))
  
})()