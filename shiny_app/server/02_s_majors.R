
schedule_list <- reactive({
  all <- unlist(reactiveValuesToList(semesters))
  substr(all, 1, 10)
})

course_tags <- reactiveVal()

observeEvent(input$get_requirements, {
  disable(id = "pick_major")
  disable(id = "get_requirements")
  
  major <- majors_list[[input$pick_major]]
  
  req_count <- 0
  count <- 1
  
  insertUI(
    selector = paste0("#", "get_requirements"),
    where = "afterEnd",
    div(
      id = "req_00",
      textOutput("major_note")
    )
  )
  
  for (i in seq_along(major)) {
    name <- major[[length(major) - i + 1]][[2]]
    number <- as.numeric(major[[length(major) - i + 1]][[3]])  
    courses <- major[[length(major) - i + 1]][-c(1,2,3)] 
    tag <- paste0("req_", length(major) - count + 1)
    course_tags(c(course_tags(), tag))
    
    if (number == 1) {
      insertUI(
        selector = paste0("#", "get_requirements"),
        where = "afterEnd",
        div(
          id = tag,
          pickerInput(
            tag,
            name,
            choices = paste0(
              courses[!is.na(courses)],
              unlist(lapply(courses[!is.na(courses)], helpers$course_code_to_name))
            ),
            selected = paste0(courses[[1]], helpers$course_code_to_name(courses[[1]]))
          ),
          br()
        )
      )
    } else {
      insertUI(
        selector = paste0("#", "get_requirements"),
        where = "afterEnd",
        div(
          id = tag,
          pickerInput(
            tag,
            name,
            choices = paste0(
              courses[!is.na(courses)],
              unlist(lapply(courses[!is.na(courses)], helpers$course_code_to_name))
            ),
            selected = paste0(
              courses[!is.na(courses)],
              unlist(lapply(courses[!is.na(courses)], helpers$course_code_to_name))
            )[1:number],
            multiple = TRUE,
            options = pickerOptions(
              maxOptions = number
            )
          ),
          br()
        )
      )
    }
    
    req_count <- req_count + number
    count <- count + 1
  }
  
  insertUI(
    selector = paste0("#", "get_requirements"),
    where = "afterEnd",
    div(
      id = "req_0",
      br(),
      actionButton(
        "deselect_major",
        "Deselect Major",
        style="color: #fff; background-color: #dd4b39; border-color: #d73925"
      ),
      br(),
      textOutput("major_is_complete"),
      br()
    )
  )
})


observeEvent(input$deselect_major, {
  removeUI(selector = paste0("#", "req_0"))
  removeUI(selector = paste0("#", "req_00"))
  
  tags_to_remove <- course_tags()
  
  for (i in seq_along(tags_to_remove)) {
    removeUI(selector = paste0("#", tags_to_remove[[i]]))
  }
  
  enable(id = "pick_major")
  enable(id = "get_requirements")
  course_tags(NULL)
})





# # Used to reload major data
# major_names <- reactiveValues()
# major_data <- reactiveVal()
# 
# 
# major_1_return <- callModule(input_major_module, "1", id = 1, parent_session = session, major_names = major_names, major_data = major_data, load_trigger = load_trigger)
# 
# callModule(major_table_module, "1", major_course_vector = major_1_return$courses,
#            name = major_1_return$name, shown = major_1_return$shown, schedule_list = schedule_list)
# 
# major_2_return <- callModule(input_major_module, "2", id = 2, parent_session = session, major_names = major_names, major_data = major_data, load_trigger = load_trigger)
# 
# callModule(major_table_module, "2", major_course_vector = major_2_return$courses,
#            name = major_2_return$name, shown = major_2_return$shown, schedule_list = schedule_list)
# 
# major_3_return <- callModule(input_major_module, "3", id = 3, parent_session = session, major_names = major_names, major_data = major_data, load_trigger = load_trigger)
# 
# callModule(major_table_module, "3", major_course_vector = major_3_return$courses,
#            name = major_3_return$name, shown = major_3_return$shown, schedule_list = schedule_list)
# 
# all_majors <- reactive({
#   list(major_1_return$data(), major_2_return$data(), major_3_return$data())
# })
