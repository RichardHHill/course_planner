
schedule_list <- reactive({
  all <- unlist(reactiveValuesToList(semesters))
  substr(all, 1, 10)
})

course_tags <- reactiveVal()

observeEvent(input$get_requirements, {
  disable(id = "pick_major")
  disable(id = "get_requirements")
  
  major <- majors_list[[input$pick_major]]
  
  insertUI(
    selector = paste0("#", "get_requirements"),
    where = "afterEnd",
    div(
      id = "req_00",
      textOutput("major_note")
    )
  )
  
  req_count <- 0
  count <- 1
  
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


major_course_vector <- reactive({
  req(course_tags())

  courses <- c()
  course_tags <- course_tags()
  for (i in seq_along(majors_list[[input$pick_major]])) {
    courses <- c(input[[course_tags[[i]]]], courses)
  }
  
  substr(courses, 1, 10)
})


major_course_table_prep <- reactive({
  req(major_course_vector())
  
  tibble(
    course = major_course_vector()
  )
})

output$major_course_table <- renderDT({
  out <- major_course_table_prep()
  
  datatable(
    out
  )
})

