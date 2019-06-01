#turn the display name to the referenced data frame
major_convertor <- reactive({
  index <- match(input$pick_major, majors_table$display)
  majors_list[[majors_table$major[[index]]]]
})

observeEvent(input$get_requirements, {
  major = major_convertor()
  req_count = 0
  count = 1
  reqs = sum(as.numeric(major[1,]))
  tags_to_remove = c()
  
  insertUI(
    selector = "#get_requirements",
    where = "afterEnd",
    tags$div(
      id = "req_0",
      actionButton(
        "remove",
        "Remove"
      )
    )
  )
  
  for (i in seq_along(major)) {
    name = major[[length(major) - i + 1]][[1]]
    number = as.numeric(major[[length(major) - i + 1]][[2]])  #had to do gymnastics because the ui was appearing
    courses = major[[length(major) - i + 1]][-c(1,2)]  #in the reverse order
    tag = paste0("req_", count)
    tags_to_remove = c(tags_to_remove, tag)
    
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
          id = "req_1",
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
  observeEvent(input$remove, {
    removeUI(selector = "#req_0")
    for (i in seq_along(tags_to_remove)) {
      removeUI(selector = paste0("#", tags_to_remove[[i]]))
    }
    
  })
})
