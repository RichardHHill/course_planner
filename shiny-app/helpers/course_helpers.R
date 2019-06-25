
(function() {
  #' course_code_to_name
  #' 
  #' @param code The 9-character course code
  #' 
  #' @return The equivalent name
  #' 
  #' @examples
  #' 
  course_code_to_name <- function(code) {
    department <- substr(code, 1, 4)
    
    department_table <- department_list[[department]]
    
    index <- match(code, department_table$course_code)
    
    department_table$course_name[[index]]
  }
  
  return(list(
    "course_code_to_name" = course_code_to_name
  ))
  
})()