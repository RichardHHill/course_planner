# Module for creating a major used on the majors tab and the course tab

input_major_module_ui <- function(id) {
  ns <- NS(id)
  
  box(
    width = 4,
    pickerInput(
      ns("pick_major"),
      "Choose a Major",
      choices = majors_table$display,
      selected = majors_table$display[[as.numeric(id)]]
    ),
    br(),
    actionButton(
      ns("get_requirements"),
      "Get Requirements"
    )
  )
}

input_major_module <- function(input, output, session, parent_session, schedule_list
                         #, majors_table, majors_list, schedule_list, helpers
                         ) {
  ns <- session$ns
  
  major_output_shown <- reactiveVal(FALSE) #to show and hide the ui table under semesters
  
  #turn the display name to the referenced data frame
  major_convertor <- reactive({
    index <- match(input$pick_major, majors_table$display)
    majors_list[[majors_table$major[[index]]]]
  })
  
  #stores tags of generated ui
  course_tags <- reactiveVal()
  
  #adds ui for each requirement of the major
  observeEvent(input$get_requirements, {
    disable(id = "pick_major")
    disable(id = "get_requirements")

    major <- major_convertor()
    req_count <- 0
    count <- 1
    tags_to_remove <- vector(mode = "character", length = length(major))
    
    insertUI(
      selector = paste0("#", ns("get_requirements")),
      where = "afterEnd",
      div(
        id = ns("req_00"),
        textOutput(ns("major_note"))
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
          selector = paste0("#", ns("get_requirements")),
          where = "afterEnd",
          div(
            id = ns(tag),
            pickerInput(
              ns(tag),
              name,
              choices = courses[!is.na(courses)]
            ),
            br()
          )
        )
      } else {
        insertUI(
          selector = paste0("#", ns("get_requirements")),
          where = "afterEnd",
          div(
            id = ns(tag),
            pickerInput(
              ns(tag),
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
    
    insertUI(
      selector = paste0("#", ns("get_requirements")),
      where = "afterEnd",
      div(
        id = ns("req_0"),
        br(),
        actionButton(
          ns("deselect_major"),
          "Deselect Major",
          style="color: #fff; background-color: #aa3636; border-color: #aa3636"
        ),
        actionButton(
          ns("major_to_courses"),
          "Go to Courses",
          style="color: #fff; background-color: #07b710; border-color: #07b710"
        ),
        br(),
        textOutput(ns("major_is_complete")),
        br()
      )
    )
  })
  
  
  observeEvent(input$deselect_major, {
    removeUI(selector = paste0("#", ns("req_0")))
    removeUI(selector = paste0("#", ns("req_00")))
    tags_to_remove <- course_tags()
    
    for (i in seq_along(tags_to_remove)) {
      removeUI(selector = paste0("#", ns(tags_to_remove[[i]])))
    }
    
    enable(id = "pick_major")
    enable(id = "get_requirements")
    major_output_shown(FALSE)
    course_tags(NULL)
  })
  
  major_course_vector <- reactive({
    req(course_tags())
    
    courses <- c()
    course_tags <- course_tags()
    for (i in seq_along(major_convertor())) {
      courses <- c(input[[course_tags[[i]]]], courses)
    }
    courses
  })

  
  output$major_note <- renderText({
    as.character(major_convertor()[1,1])
  })
  
  
  major_complete_prep <- reactiveVal()
  
  observe({
    req(major_course_vector(), major_convertor())

    if (length(major_course_vector()) == sum(as.numeric(major_convertor()[3,]))) {
      enable(id = "major_to_courses")
      major_output_shown(TRUE)
      text <- ""
    } else {
      disable(id = "major_to_courses")
      major_output_shown(FALSE)
      text <- "Input more courses"
    }
    
    major_complete_prep(text)
  })
  
  
  output$major_is_complete <- renderText({
    major_complete_prep()
  })
  
  
  #go to courses after picking major
  observeEvent(input$major_to_courses, {
    updateTabsetPanel(parent_session, "sidebar", selected = "select_courses")
  })
  
  major_name <- reactive({
    input$pick_major
  })
  
  
  return(
    list(
      courses = major_course_vector,
      name = major_name,
      shown = major_output_shown
    )
  )
}