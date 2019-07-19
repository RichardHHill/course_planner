
observeEvent(input$saved_inputs_row_to_delete, {
  id <- as.numeric(input$saved_inputs_row_to_delete)
  
  showModal(
    modalDialog(
      title = "Delete Schedule",
      size = "s",
      footer = list(
        actionButton(
          "saved_inputs_delete_button",
          "Delete",
          style="color: #fff; background-color: #dd4b39; border-color: #d73925"
        ),
        actionButton(
          "saved_inputs_delete_cancel_button",
          "Cancel",
          style="color: #444; background-color: #f4f4f4; border-color: #ddd"
        )
      ),
      h3(paste0("Are you sure you want to delete schedule #", id, "?"))
    )
  )
})

observeEvent(input$saved_inputs_delete_cancel_button, {
  removeModal()
})

observeEvent(input$saved_inputs_delete_button, {
  removeModal()
  row <- as.numeric(input$saved_inputs_row_to_delete)
  
  id_to_delete <- saved_inputs_table_prep()[row, ] %>% 
    pull(id)
  
  progress <- Progress$new(session, min = 0, max = 3)
  
  tryCatch({
    DBI::dbWithTransaction(conn, {
      progress$inc(amount = 1, message = "Deleting Data", detail = "Input Id")
      delete_by(conn, "input_ids", by = list(id = id_to_delete))
      
      progress$inc(amount = 1, message = "Deleting Data", detail = "Semester Courses")
      delete_by(conn, "semester_courses", by = list(id = id_to_delete))
      
      progress$inc(amount = 1, message = "Deleting Data", detail = "Majors")
      delete_by(conn, "majors", by = list(id = id_to_delete))
    })
    
    saved_inputs_table_trigger(saved_inputs_table_trigger() + 1)
    progress$close()
    session$sendCustomMessage(
      "show_toast",
      message = list(
        type = "success",
        title = "Schedule Deleted",
        message = NULL
      )
    )
  }, error = function(error) {
    
    session$sendCustomMessage(
      "show_toast",
      message = list(
        type = "error",
        title = "Error Deleting Schedule",
        message = NULL
      )
    )
    
    print("error deleting input set")
    print(error)
  })
})
