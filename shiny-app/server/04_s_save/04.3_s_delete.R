
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
