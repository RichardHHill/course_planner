

semester_courses_df <- reactive({
  names <- names(reactiveValuesToList(semesters))
  
  out <- tibble(
    semester = character(0),
    course = character(0)
  )
  
  for (i in seq_along(names)) {
    out <- rbind(
      out,
      tibble(
        semester = names[[i]],
        course = semesters[[names[[i]]]]
      )
    )
  }
  
  out
})


major_inputs_df <- reactive({
  majors <- all_majors()
  
  out <- tibble(
    major_number = character(0),
    major_name = character(0),
    tag = character(0),
    course = character(0)
  )
  
  for (i in seq_along(majors)) {
    if (length(majors[[i]]) > 1) {
      course_list <- majors[[i]]
      courses <- list()
      
      for (j in seq_along(course_list)) {
        tag <- names(course_list)[[j]]
        tag_courses <- course_list[[j]]
        names(tag_courses) <- rep(tag, length(tag_courses))
        courses <- c(courses, tag_courses)
      }
      
      out <- bind_rows(
        out,
        tibble(
          major_number = paste0("major_", i),
          major_name = majors[[i]]$major,
          tag = names(courses),
          course = unlist(courses)
        )
      )
    }
  }
  
  out
})


observeEvent(input$save_all_inputs, {
  showModal(
    modalDialog(
      title = "Save Courses and Majors",
      size = "s",
      footer = list(
        actionButton(
          "confirm_save_all",
          "Save All",
          style = "background-color: #46c410; color: #fff",
          icon = icon("plus")
        ),
        modalButton("Cancel")
      ),
      fluidRow(
        column(
          12,
          textInput("passkey", "Passkey")
        )
      ),
      fluidRow(
        column(
          12,
          "This passkey will be used to track all of your saved tables. Make sure it's unique; anyone
           who types it in will be able to see your info!"
        )
      )
    )
  )
})


observeEvent(input$confirm_save_all, {
  removeModal()
  key <- list(passkey = input$passkey)
  semester_courses <- semester_courses_df()
  majors <- major_inputs_df()
  
  tryCatch({
    DBI::dbWithTransaction(conn, {
      tychobratools::add_row(conn, input_ids, key)
      
      get_query <- "SELECT id from input_ids WHERE passkey=?passkey ORDER BY time_created DESC LIMIT 1"
      
      get_query <- DBI::sqlInterpolate(conn, get_query, .dots = key)
      
      input_set_id <- as.integer(DBI::dbGetQuery(
        conn,
        get_query
      ))
      
      
      semester_courses <- cbind(
        tibble(id = rep(input_set_id, nrow(semester_courses))),
        semester_courses
      )
      
      DBI::dbWriteTable(
        conn,
        name = "semester_courses",
        value = semester_courses,
        append = TRUE
      )
      
      majors <- cbind(
        tibble(id = rep(input_set_id, nrow(majors))),
        majors
      )
      
      DBI::dbWriteTable(
        conn,
        name = "majors",
        value = majors,
        append = TRUE
      )
    })
    
    session$sendCustomMessage(
      "show_toast",
      message = list(
        type = "success",
        title = "Inputs Successfully Saved!",
        message = NULL
      )
    )
    
  }, error = function(error) {
    
    session$sendCustomMessage(
      "show_toast",
      message = list(
        type = "error",
        title = "Error Saving Inputs",
        message = NULL
      )
    )
    progress$close()
    print(error)
  })
  
  
  
})





