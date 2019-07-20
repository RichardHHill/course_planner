#creates 8 semester tables

semesters <- reactiveValues()
delete_mode <- reactiveVal(FALSE)

observeEvent(input$enable_delete_mode, {
  delete_mode(TRUE)
  shinyjs::hide("enable_delete_mode")
  shinyjs::show("disable_delete_mode")
})

observeEvent(input$disable_delete_mode, {
  delete_mode(FALSE)
  shinyjs::hide("disable_delete_mode")
  shinyjs::show("enable_delete_mode")
})


callModule(semester_module, "1", id = 1, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["1-semester_remove"]]))
callModule(semester_module, "2", id = 2, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["2-semester_remove"]]))
callModule(semester_module, "3", id = 3, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["3-semester_remove"]]))
callModule(semester_module, "4", id = 4, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["4-semester_remove"]]))
callModule(semester_module, "5", id = 5, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["5-semester_remove"]]))
callModule(semester_module, "6", id = 6, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["6-semester_remove"]]))
callModule(semester_module, "7", id = 7, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["7-semester_remove"]]))
callModule(semester_module, "8", id = 8, delete_mode = delete_mode, semesters = semesters, semester_remove = reactive(input[["8-semester_remove"]]))

