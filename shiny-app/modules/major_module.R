# Module for creating a major used on the majors tab and the course tab

major_module_ui <- function(id) {
  ns <- NS(id)
  
  box(
    width = 4,
    pickerInput(
      ns("pick_major"),
      "Choose a Major",
      choices = majors_table$display
    ),
    br(),
    actionButton(
      ns("get_requirements"),
      "Get Requirements"
    )
  )
}

major_model <- function(input, output, session) {
  #turn the display name to the referenced data frame
  major_convertor_1 <- reactive({
    index <- match(input$pick_major_1, majors_table$display)
    majors_list[[majors_table$major[[index]]]]
  })
  
  #stores tags of generated ui
  courses_for_major_1 <- reactiveVal()
  
  #adds ui for each requirement of the major
  observeEvent(input$get_requirements_1, {
    disable(id = "pick_major_1")
    disable(id = "get_requirements_1")
    
    major <- major_convertor_1()
    req_count <- 0
    count <- 1
    tags_to_remove <- vector(mode = "character", length = length(major))
    
    insertUI(
      selector = "#get_requirements_1",
      where = "afterEnd",
      div(
        id = "req_1_00",
        textOutput("major_1_note")
      )
    )
    
    for (i in seq_along(major)) {
      name <- major[[length(major) - i + 1]][[2]]
      number <- as.numeric(major[[length(major) - i + 1]][[3]])  #had to do gymnastics because the ui
      courses <- major[[length(major) - i + 1]][-c(1,2,3)]  #was appearing in the reverse order
      tag <- paste0("req_1_", length(major) - count + 1)
      courses_for_major_1(c(courses_for_major_1(), tag))
      
      if (number == 1) {
        insertUI(
          selector = "#get_requirements_1",
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
          selector = "#get_requirements_1",
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
    
    insertUI(
      selector = "#get_requirements_1",
      where = "afterEnd",
      tags$div(
        id = "req_1_0",
        br(),
        actionButton(
          "deselect_major_1",
          "Deselect Major",
          style="color: #fff; background-color: #aa3636; border-color: #aa3636"
        ),
        actionButton(
          "major_1_to_courses",
          "Go to Courses",
          style="color: #fff; background-color: #07b710; border-color: #07b710"
        ),
        br(),
        textOutput("major_1_is_complete"),
        br()
      )
    )
  })
  
  
  observeEvent(input$deselect_major_1, {
    removeUI(selector = "#req_1_0")
    removeUI(selector = "#req_1_00")
    tags_to_remove <- courses_for_major_1()
    
    for (i in seq_along(tags_to_remove)) {
      removeUI(selector = paste0("#", tags_to_remove[[i]]))
    }
    
    enable(id = "pick_major_1")
    enable(id = "get_requirements_1")
    hide("major_1_output")
    courses_for_major_1(NULL)
  })
  
  
  output$major_1_note <- renderText({
    as.character(major_convertor_1()[1,1])
  })
  
  
  major_1_complete_prep <- reactiveVal()
  
  observe({
    req(major_1_course_vector(), major_convertor_1())
    if (length(major_1_course_vector()) == sum(as.numeric(major_convertor_1()[3,]))) {
      enable(id = "major_1_to_courses")
      show("major_1_output")
      text <- ""
    } else {
      disable(id = "major_1_to_courses")
      hide("major_1_output")
      text <- "Input more courses"
    }
    
    major_1_complete_prep(text)
  })
  
  
  output$major_1_is_complete <- renderText({
    major_1_complete_prep()
  })
  
  
  #go to courses after picking major
  observeEvent(input$major_1_to_courses, {
    updateTabsetPanel(session, "sidebar", selected = "select_courses")
  })
  
}