
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
    
    if (department %in% names(department_list)) {
      department_table <- department_list[[department]]
      
      index <- match(substr(code, 1, 10), department_table$course_code)
      
      if (is.na(index)) out <- "" else out <- department_table$course_name[[index]]
    } else {
      out <- ""
    }
    
    out
  }
  
  return(list(
    "course_code_to_name" = course_code_to_name
  ))
  
})()