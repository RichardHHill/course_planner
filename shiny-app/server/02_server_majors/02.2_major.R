#turn the display name to the referenced data frame
major_convertor_2 <- reactive({
  index <- match(input$pick_major_2, majors_table$display)
  majors_list[[majors_table$major[[index]]]]
})

#stores tags of generated ui
courses_for_major_2 <- reactiveVal()

#adds ui for each requirement of the major
observeEvent(input$get_requirements_2, {
  disable(id = "pick_major_2")
  disable(id = "get_requirements_2")
  
  major <- major_convertor_2()
  req_count <- 0
  count <- 1
  tags_to_remove <- vector(mode = "character", length = length(major))
  
  insertUI(
    selector = "#get_requirements_2",
    where = "afterEnd",
    tags$div(
      id = "req_2_0",
      actionButton(
        "deselect_major_2",
        "Deselect Major",
        style="color: #fff; background-color: #aa3636; border-color: #aa3636"
      ),
      actionButton(
        "major_2_to_courses",
        "Go to Courses",
        style="color: #fff; background-color: #07b710; border-color: #07b710"
      ),
      br(),
      textOutput("major_2_is_complete")
    )
  )
  
  for (i in seq_along(major)) {
    name <- major[[length(major) - i + 1]][[2]]
    number <- as.numeric(major[[length(major) - i + 1]][[3]])  #had to do gymnastics because the ui
    courses <- major[[length(major) - i + 1]][-c(1,2,3)]  #was appearing in the reverse order
    tag <- paste0("req_2_", length(major) - count + 1)
    tags_to_remove[[i]] <- tag
    courses_for_major_2(c(courses_for_major_2(), tag))
    
    if (number == 1) {
      insertUI(
        selector = "#get_requirements_2",
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
        selector = "#get_requirements_2",
        where = "afterEnd",
        tags$div(
          id = tag,
          pickerInput(
            tag,
            name,
            choices = courses[!is.na(courses)],
            selected = courses[1:number],
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
  
  observeEvent(input$deselect_major_2, {
    removeUI(selector = "#req_2_0")
    
    for (i in seq_along(tags_to_remove)) {
      removeUI(selector = paste0("#", tags_to_remove[[i]]))
    }
    
    enable(id = "pick_major_2")
    enable(id = "get_requirements_2")
    hide("major_2_output")
  })
})


output$major_2_is_complete <- renderText({
  if (length(major_2_course_vector()) == sum(as.numeric(major_convertor_2()[3,]))) {
    enable(id = "major_2_to_courses")
    show("major_2_output")
    text <- ""
  } else {
    disable(id = "major_2_to_courses")
    hide("major_2_output")
    text <- "Input more courses"
  }
  text
})


#go to courses after picking major
observeEvent(input$major_2_to_courses, {
  updateTabsetPanel(session, "sidebar", selected = "select_courses")
})

