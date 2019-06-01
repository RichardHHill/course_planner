
observeEvent(input$go_to_majors, {
  updateTabsetPanel(session, "sidebar", selected = "select_majors")
})
