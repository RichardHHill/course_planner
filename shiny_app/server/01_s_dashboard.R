
observeEvent(input$go_to_majors, {
  updateTabsetPanel(session, "sidebar", selected = "select_majors")
})

observeEvent(input$go_to_courses, {
  updateTabsetPanel(session, "sidebar", selected = "select_courses")
})

observeEvent(input$go_to_saved, {
  updateTabsetPanel(session, "sidebar", selected = "saved_inputs")
})
