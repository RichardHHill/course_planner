
saved_inputs_table_prep <- reactive({
  conn %>% 
    tbl("input_ids") %>% 
    collect() %>% 
    filter(passkey == input$saved_passkey) %>% 
    arrange(desc(time_created)) %>% 
    select(id, name)
})


output$saved_inputs_table <- renderDT({
  out <- saved_inputs_table_prep()
  
  datatable(
    out,
    rownames = FALSE
  )
})
