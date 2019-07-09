#creates 8 semester tables

semesters <- reactiveValues()
delete_mode <- reactiveVal(FALSE)

observeEvent(input$enable_delete_mode, {
  delete_mode(TRUE)
  hide("enable_delete_mode")
  show("disable_delete_mode")
})

observeEvent(input$disable_delete_mode, {
  delete_mode(FALSE)
  hide("disable_delete_mode")
  show("enable_delete_mode")
})


semester1_courses <- reactiveVal()
callModule(semester_module, "1", delete_mode = delete_mode, courses = semester1_courses, semester_remove = reactive(input[["1-semester_remove"]]))

semester2_courses <- reactiveVal()
callModule(semester_module, "2", delete_mode = delete_mode, courses = semester2_courses, semester_remove = reactive(input[["2-semester_remove"]]))

semester3_courses <- reactiveVal()
callModule(semester_module, "3", delete_mode = delete_mode, courses = semester3_courses, semester_remove = reactive(input[["3-semester_remove"]]))

semester4_courses <- reactiveVal()
callModule(semester_module, "4", delete_mode = delete_mode, courses = semester4_courses, semester_remove = reactive(input[["4-semester_remove"]]))

semester5_courses <- reactiveVal()
callModule(semester_module, "5", delete_mode = delete_mode, courses = semester5_courses, semester_remove = reactive(input[["5-semester_remove"]]))

semester6_courses <- reactiveVal()
callModule(semester_module, "6", delete_mode = delete_mode, courses = semester6_courses, semester_remove = reactive(input[["6-semester_remove"]]))

semester7_courses <- reactiveVal()
callModule(semester_module, "7", delete_mode = delete_mode, courses = semester7_courses, semester_remove = reactive(input[["7-semester_remove"]]))

semester8_courses <- reactiveVal()
callModule(semester_module, "8", delete_mode = delete_mode, courses = semester8_courses, semester_remove = reactive(input[["8-semester_remove"]]))

