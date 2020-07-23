
schedule_list <- reactive({
  unlist(lapply(reactiveValuesToList(semesters), function(df) df$code))
})

course_tags <- reactiveVal()

major_note_prep <- reactiveVal("")

output$major_note <- renderText(major_note_prep())

observeEvent(input$get_requirements, {
  disable(id = "pick_major")
  disable(id = "get_requirements")
  
  major <- majors_list[[input$pick_major]]
  
  major_note_prep(if (is.na(major[[1, 1]])) "" else major[[1, 1]])
  
  insertUI(
    selector = "#get_requirements",
    where = "afterEnd",
    div(
      class = "major_picker_ui",
      textOutput("major_note")
    )
  )
  
  for (i in rev(seq_along(major))) {
    name <- major[[2, i]]
    number <- as.numeric(major[[3, i]])  
    
    courses <- major[[i]][-c(1,2,3)] 
    course_choices <- courses[!is.na(courses)]
    
    tag <- paste0("req_", i)
    course_tags(c(course_tags(), tag))
    
    if (number == 1) {
      insertUI(
        selector = "#get_requirements",
        where = "afterEnd",
        div(
          class = "major_picker_ui",
          pickerInput(
            tag,
            name,
            choices = course_choices,
            choicesOpt = list(subtext = course_codes_to_name(course_choices)),
            options = pickerOptions(
              showSubtext = TRUE
            )
          ),
          br()
        )
      )
    } else {
      insertUI(
        selector = "#get_requirements",
        where = "afterEnd",
        div(
          class = "major_picker_ui",
          pickerInput(
            tag,
            name,
            choices = course_choices,
            choicesOpt = list(subtext = course_codes_to_name(course_choices)),
            selected = course_choices[1:number],
            multiple = TRUE,
            options = pickerOptions(
              maxOptions = number
            )
          ),
          br()
        )
      )
    }
  }
  
  insertUI(
    selector = "#get_requirements",
    where = "afterEnd",
    div(
      class = "major_picker_ui",
      br(),
      actionButton(
        "deselect_major",
        "Deselect Major",
        style = "color: #fff; background-color: #dd4b39; border-color: #d73925"
      ),
      actionButton(
        "select_major_choices",
        "Select Choices",
        style = "color: #fff; background-color: #07b710; border-color: #07b710;",
        icon = icon("arrow-right")
      ),
      br(),
      textOutput("major_is_complete"),
      br()
    )
  )
})


observeEvent(input$deselect_major, {
  removeUI(selector = ".major_picker_ui", multiple = TRUE)

  enable(id = "pick_major")
  enable(id = "get_requirements")
  hideElement("chosen_major_courses_box")
  course_tags(NULL)
})

major_course_vector <- reactive({
  req(course_tags())

  courses <- c()
  course_tags <- course_tags()
  for (i in seq_along(majors_list[[input$pick_major]])) {
    courses <- c(input[[course_tags[[i]]]], courses)
  }
  
  courses
})
