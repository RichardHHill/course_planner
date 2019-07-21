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

input_major_module <- function(input, output, session, id, parent_session, schedule_list, major_names, major_data, load_trigger) {
  ns <- session$ns
  
  major_output_shown <- reactiveVal(FALSE) #to show and hide the ui table under semesters
  course_tags <- reactiveVal() #stores tags of generated ui
  
  #turn the display name to the referenced data frame
  major_convertor <- reactiveVal()
  
  observe({
    index <- match(input$pick_major, majors_table$display)
    major_convertor(majors_list[[majors_table$major[[index]]]])
  })
  
  major_change_trigger <- reactiveVal(0)
  remove_major_trigger <- reactiveVal(0)
  picker_value <- reactiveVal()
  
  
  observeEvent(load_trigger[[paste0("major_", id)]], {
    req(major_names[[paste0("major_", id)]])
    
    updatePickerInput(session, "pick_major", selected = major_names[[paste0("major_", id)]])
    picker_value(major_names[[paste0("major_", id)]])
    
    index <- match(major_names[[paste0("major_", id)]], majors_table$display)
    
    major_convertor(majors_list[[majors_table$major[[index]]]])
    
    remove_major_trigger(remove_major_trigger() + 1)
    major_change_trigger(major_change_trigger() + 1)
  })
  
  #If this major is not in the saved data
  observeEvent(load_trigger$delete, {
    remove_major_trigger(remove_major_trigger() + 1)
  })
  
  observeEvent(input$get_requirements, {
    major_change_trigger(major_change_trigger() + 1)
  })
  
  name_of_major <- reactiveVal(isolate({input$pick_major}))
  
  observeEvent(input$pick_major, {
    if (name_of_major() != input$pick_major) {
      remove_major_trigger(remove_major_trigger() + 1)
    }
  })
  
  #adds ui for each requirement of the major
  observeEvent(major_change_trigger(), {
    req(major_change_trigger() > 0) #otherwise runs on start
    disable(id = "get_requirements")

    major <- major_convertor()
    
    name_of_major(major[1,2])
    
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
      tag_ <- tag # for filter
      
      if (!is.null(major_data())) {
        major_num <- paste0("major_", id)
        data <- major_data() %>% 
          filter(major_number == major_num) %>% 
          filter(major_name == major[1,2])
      } else {
        data <- tibble(id = character(0))
      }
      
      if (number == 1) {
        if(nrow(data) > 0) {
          major_num <- paste0("major_", id)
          selected <- data %>% 
            filter(tag == tag_) %>% 
            pull(course)
        } else {
          selected <- paste0(courses[[1]], helpers$course_code_to_name(courses[[1]]))
        }
          
        insertUI(
          selector = paste0("#", ns("get_requirements")),
          where = "afterEnd",
          div(
            id = ns(tag),
            pickerInput(
              ns(tag),
              name,
              choices = paste0(
                courses[!is.na(courses)],
                unlist(lapply(courses[!is.na(courses)], helpers$course_code_to_name))
              ),
              selected = selected
            ),
            br()
          )
        )
      } else {
        if(nrow(data) > 0) {
          major_num <- paste0("major_", id)
          selected <- data %>% 
            filter(tag == tag_) %>% 
            pull(course)
        } else {
          selected <- paste0(
            courses[!is.na(courses)],
            unlist(lapply(courses[!is.na(courses)], helpers$course_code_to_name))
          )[1:number]
        }
        
        insertUI(
          selector = paste0("#", ns("get_requirements")),
          where = "afterEnd",
          div(
            id = ns(tag),
            pickerInput(
              ns(tag),
              name,
              choices = paste0(
                courses[!is.na(courses)],
                unlist(lapply(courses[!is.na(courses)], helpers$course_code_to_name))
              ),
              selected = selected,
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
  
  
  observeEvent(remove_major_trigger(), {
    removeUI(selector = paste0("#", ns("req_0")))
    removeUI(selector = paste0("#", ns("req_00")))
    
    tags_to_remove <- course_tags()
    
    for (i in seq_along(tags_to_remove)) {
      removeUI(selector = paste0("#", ns(tags_to_remove[[i]])))
    }
    
    enable(id = "get_requirements")
    major_output_shown(FALSE)
    course_tags(NULL)
  })
  
  major_course_vector <- reactive({
    req(course_tags())
    req(length(course_tags()) == length(major_convertor()))
    
    courses <- c()
    course_tags <- course_tags()
    for (i in seq_along(major_convertor())) {
      courses <- c(input[[course_tags[[i]]]], courses)
    }
    
    substr(courses, 1, 10)
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
  
  major_data_to_save <- reactive({
    out <- list(major = input$pick_major)
    course_tags <- course_tags()
    
    for (i in seq_along(course_tags)) {
      tag <- course_tags[[i]]
      out[[tag]] <- input[[tag]]
    }
    
    out
  })
  
  
  return(
    list(
      courses = major_course_vector,
      name = major_name,
      shown = major_output_shown,
      data = major_data_to_save
    )
  )
}