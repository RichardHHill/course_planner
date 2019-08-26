

semester_courses_df <- reactive({
  names <- names(reactiveValuesToList(semesters))
  
  out <- tibble(
    semester = character(0),
    code = character(0),
    name = character(0)
  )
  
  for (i in seq_along(names)) {
    out <- rbind(
      out,
      tibble(
        semester = names[[i]],
        code = semesters[[names[[i]]]]$code,
        name = semesters[[names[[i]]]]$name
      )
    )
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
          textInput("saved_name", "Name"),
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
  
  dat <- list(passkey = input$passkey, name = input$saved_name)
  semester_courses <- semester_courses_df()
  majors <- built_majors()
  
  progress <- Progress$new(session, min = 0, max = 3)
  progress$inc(amount = 1, message = "Saving Inputs", detail = "initializing...")
  tryCatch({
    DBI::dbWithTransaction(conn, {
      
      tychobratools::add_row(conn, "input_ids", dat)
      
      get_query <- "SELECT id from input_ids WHERE passkey=?passkey ORDER BY time_created DESC LIMIT 1"
      
      get_query <- DBI::sqlInterpolate(conn, get_query, .dots = dat["passkey"])
      
      input_set_id <- as.integer(DBI::dbGetQuery(
        conn,
        get_query
      ))
      
      progress$inc(amount = 1, message = "Saving Inputs", detail = "Semester Courses")
      
      if (nrow(semester_courses) > 0) {
        semester_courses$id <- input_set_id 
        
        DBI::dbWriteTable(
          conn,
          name = "semester_courses",
          value = semester_courses,
          append = TRUE
        )
      }
      
      progress$inc(amount = 1, message = "Saving Inputs", detail = "Majors")
      
      if (nrow(majors) > 0) {
        majors$id <- input_set_id
      
        DBI::dbWriteTable(
          conn,
          name = "majors",
          value = majors,
          append = TRUE
        )
      }
    })
    
    saved_inputs_table_trigger(saved_inputs_table_trigger() + 1)
    
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
    print(error)
  })
  
  progress$close()
})
