
saved_inputs_table_prep <- reactive({
  out <- conn %>% 
    tbl("input_ids") %>% 
    collect() %>% 
    filter(passkey == input$saved_passkey) %>% 
    arrange(desc(time_created)) %>% 
    select(id, name)
  
  rows <- seq_len(nrow(out))
  
  buttons <- paste0(
    '<div class="btn-group width_75" role="group" aria-label="Basic example">
        <button class="btn btn-primary btn-sm load_btn" data-toggle="tooltip" data-placement="top" title="Load Schedule" id = ', rows, ' style="margin: 0"><i class="fa fa-upload"></i></button>
        <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete Schedule" id = ', rows, ' style="margin: 0"><i class="fa fa-trash-o"></i></button></div>'
  )
  
  out$button <- buttons
  
  out %>% 
    select(button, id, name)
})


output$saved_inputs_table <- renderDT({
  out <- saved_inputs_table_prep()
  
  datatable(
    out,
    rownames = FALSE,
    escape = -1,
    selection = "none"
  )
})
