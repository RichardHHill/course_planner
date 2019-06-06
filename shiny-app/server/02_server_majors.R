#turn the display name to the referenced data frame
major_convertor <- reactive({
  index <- match(input$pick_major, majors_table$display)
  majors_list[[majors_table$major[[index]]]]
})

#stores tags of generated ui
courses_for_major_1 <- reactiveValues()

#adds ui for each requirement of the major
observeEvent(input$get_requirements, {
  disable(id = "pick_major")
  disable(id = "get_requirements")
  
  major = major_convertor()
  req_count = 0
  count = 1
  tags_to_remove = c()
  
  insertUI(
    selector = "#get_requirements",
    where = "afterEnd",
    tags$div(
      id = "req_0",
      actionButton(
        "select_different_major",
        "Select Different Major",
        style="color: #fff; background-color: #aa3636; border-color: #aa3636"
      ),
      actionButton(
        "majors_to_courses",
        "Go to Courses",
        style="color: #fff; background-color: #07b710; border-color: #07b710"
      ),
      br(),
      textOutput("major_is_complete")
    )
  )
  
  for (i in seq_along(major)) {
    name = major[[length(major) - i + 1]][[1]]
    number = as.numeric(major[[length(major) - i + 1]][[2]])  #had to do gymnastics because the ui was appearing
    courses = major[[length(major) - i + 1]][-c(1,2)]  #in the reverse order
    tag = paste0("req_", length(major) - count + 1)
    tags_to_remove = c(tags_to_remove, tag)
    courses_for_major_1[[letters[[i]]]] <- tag
    
    if (number == 1) {
      insertUI(
        selector = "#get_requirements",
        where = "afterEnd",
        tags$div(
          id = tag,
          pickerInput(
            tag,
            name,
            choices = courses[!is.na(courses)]
          ),
          br()
        )
      )
    } else {
      insertUI(
        selector = "#get_requirements",
        where = "afterEnd",
        tags$div(
          id = tag,
          pickerInput(
            tag,
            name,
            choices = courses[!is.na(courses)],
            multiple = TRUE,
            options = pickerOptions(
              maxOptions = number
            )
          ),
          br()
        )
      )
    }
    
    req_count = req_count + number
    count = count + 1
  }
  
  #removeUI(selector = "#get_requirements")
  observeEvent(input$select_different_major, {
    removeUI(selector = "#req_0")

    for (i in seq_along(tags_to_remove)) {
      removeUI(selector = paste0("#", tags_to_remove[[i]]))
    }
    
    enable(id = "pick_major")
    enable(id = "get_requirements")
  })
})


output$major_is_complete <- renderText({
  if (length(course_vector()) == sum(as.numeric(major_convertor()[2,]))) {
    enable(id = "majors_to_courses")
    text <- ""
  } else {
    disable(id = "majors_to_courses")
    text <- "Input more courses"
  }
  text
})


#go to courses after picking major
observeEvent(input$majors_to_courses, {
  updateTabsetPanel(session, "sidebar", selected = "select_courses")
})
