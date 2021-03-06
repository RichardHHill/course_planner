
majors_module_ui <- function(id) {
  ns <- NS(id)
  
  tabItem(
    tabName = "select_majors",
    fluidRow(
      box(
        width = 12,
        column(
          12,
          align = "center",
          h1("Select Majors")
        )
      )
    ),
    fluidRow(
      column(
        4,
        fluidRow(
          box(
            width = 12,
            title = "Select Major",
            id = ns("select_major_box"),
            circleButton(
              ns("show_info"),
              icon = icon("info"),
              size = "xs"
            ),
            HTML(paste0("
              <h4 id='", ns("build_majors_info"), "' class='shinyjs-hide'>
                These majors are based on data from 
                <a href='https://bulletin.brown.edu/the-college/concentrations/' target='blank_'>here</a>
                in 2019. Only some majors that are less general in their
                requirements are available, but all can be created in \"Customize Major\"
              </h4>
            ")),
            pickerInput(
              ns("pick_major"),
              "",
              choices = setNames(majors_table$major, majors_table$display)
            ),
            br(),
            actionButton(
              ns("get_requirements"),
              "Get Requirements"
            )
          )
        )
      ),
      box(
        width = 4,
        title = "Customize Major",
        column(
          12,
          align = "center",
          textInput(ns("submit_custom_major_name"), "Name", width = "33%"),
          actionButton(
            ns("submit_custom_major"),
            "Submit Major",
            class = "btn-primary",
            style = "color: #fff;"
          ),
          actionButton(
            ns("clear_custom_major"),
            "Clear",
            class = "btn-danger",
            style = "color: #fff;"
          )
        ),
        br(),
        fluidRow(
          column(
            12,
            br(),
            rHandsontableOutput(ns("major_handson_table")),
            "The Code is a course code (up to 10 digits) such as ECON 0110"
          )
        )
      ),
      box(
        width = 4,
        title = "Built Majors",
        DTOutput(ns("built_majors_table"))
      )
    ),
    tags$script(src = "majors_module.js"),
    tags$script(paste0("majors_module_js('", ns(""), "')"))
  )
}

majors_module <- function(input, output, session, built_majors) {
  ns <- session$ns
  
  course_tags <- reactiveVal()
  major_note_prep <- reactiveVal("")
  
  
  output$major_note <- renderText(major_note_prep())
  
  
  observeEvent(input$show_info, toggleElement("build_majors_info", anim = TRUE))
  
  
  observeEvent(input$get_requirements, {
    disable("pick_major")
    disable("get_requirements")
    
    major <- majors_list[[input$pick_major]]
    
    major_note_prep(if (is.na(major[[1, 1]])) "" else major[[1, 1]])
    
    insertUI(
      selector = paste0("#", ns("get_requirements")),
      where = "afterEnd",
      div(
        class = "major_picker_ui",
        textOutput(ns("major_note"))
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
          selector = paste0("#", ns("get_requirements")),
          where = "afterEnd",
          div(
            class = "major_picker_ui",
            pickerInput(
              ns(tag),
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
          selector = paste0("#", ns("get_requirements")),
          where = "afterEnd",
          div(
            class = "major_picker_ui",
            pickerInput(
              ns(tag),
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
      selector = paste0("#", ns("get_requirements")),
      where = "afterEnd",
      div(
        class = "major_picker_ui",
        br(),
        actionButton(
          ns("deselect_major"),
          "Deselect Major",
          class = "btn-danger",
          style = "color: #fff;"
        ),
        actionButton(
          ns("select_major_choices"),
          "Select Choices",
          class = "btn-primary",
          style = "color: #fff;",
          icon = icon("arrow-right")
        ),
        br(),
        textOutput(ns("major_is_complete")),
        br()
      )
    )
  })
  
  
  observeEvent(input$deselect_major, {
    removeUI(selector = ".major_picker_ui", multiple = TRUE)
    
    enable("pick_major")
    enable("get_requirements")
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
  
  custom_table <- reactiveVal(
    tibble(
      code = rep("", 25),
      name = rep("", 25)
    )
  )
  
  custom_table_trigger <- reactiveVal(0)
  
  output$major_handson_table <- renderRHandsontable({
    custom_table_trigger()
    
    rhandsontable(
      data = custom_table(),
      stretchH = "last"
    ) %>% 
      hot_cols(colWidths = 80)
  })
  
  observeEvent(input$built_majors_row_to_edit, {
    id <- unique(built_majors()$major_id)[as.numeric(input$built_majors_row_to_edit)]
    
    out <- built_majors() %>% 
      filter(major_id == id) %>% 
      select(code, name)
    
    out <- rbind(
      out,
      tibble(
        code = rep("", 25 - nrow(out)),
        name = rep("", 25 - nrow(out))
      )
    )
    
    custom_table(out)
    custom_table_trigger(custom_table_trigger() + 1)
  })
  
  observeEvent(input$select_major_choices, {
    req(major_course_vector())
    
    course_codes <- major_course_vector()
    course_names <- course_codes_to_name(course_codes)
    
    out <- tibble(
      code = course_codes,
      name = course_names
    )
    
    out <- rbind(
      out,
      tibble(
        code = rep("", 25 - nrow(out)),
        name = rep("", 25 - nrow(out))
      )
    )
    
    custom_table(out)
    custom_table_trigger(custom_table_trigger() + 1)
  })
  
  observeEvent(input$clear_custom_major, {
    custom_table(
      tibble(
        code = rep("", 25),
        name = rep("", 25)
      )
    )
    custom_table_trigger(custom_table_trigger() + 1)
  })
  
  observeEvent(input$submit_major, {
    dat <- major_courses_table_prep()
    
    dat$major_name <- input$submit_major_name
    
    id <- digest::digest(dat)
    
    if (!(id %in% built_majors()$major_id)) {
      dat$major_id <- id
      
      built_majors(
        rbind(
          built_majors(),
          dat
        )
      )
    }
  })
  
  observeEvent(input$submit_custom_major, {
    dat <- hot_to_r(input$major_handson_table) %>% 
      mutate(
        code = trimws(code),
        name = trimws(name)
      ) %>% 
      filter(code != "" | name != "")
    
    req(nrow(dat) > 0)
    
    dat$major_name <- input$submit_custom_major_name
    id <- digest::digest(dat)
    
    if (!(id %in% built_majors()$major_id)) {
      dat$major_id <- id
      
      built_majors(
        rbind(
          built_majors(),
          dat
        )
      )
    }
  })
  
  built_majors_table_prep <- reactive({
    out <- built_majors() %>% 
      select(major_name, major_id) %>% 
      distinct
    
    if (nrow(out) > 0) {
      rows <- 1:nrow(out)
      
      buttons <- paste0(
        '<div class="btn-group width_75" role="group" aria-label="Basic example">
        <button class="btn btn-primary btn-sm edit_btn" data-toggle="tooltip" data-placement="top" title="Reload Major" id = ', rows, ' style="margin: 0"><i class="fa fa-arrow-left"></i></button>
        <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete Major" id = ', rows, ' style="margin: 0"><i class="fa fa-trash-o"></i></button></div>'
      )
      
      out$button <- buttons
    } else {
      out$button <- character(0)
    }
    
    out
  })
  
  output$built_majors_table <- renderDT({
    out <- built_majors_table_prep() %>% 
      select(button, major_name)
    
    datatable(
      out,
      rownames = FALSE,
      escape = -1,
      colnames = c("", "Major Name"),
      selection = "none",
      options = list(
        dom = "t",
        pageLength = nrow(out),
        columnDefs = list(
          list(width = "75px", orderable = FALSE, targets = 0)
        )
      )
    )
  })
  
  observeEvent(input$built_majors_row_to_delete, {
    id <- unique(built_majors()$major_id)[as.numeric(input$built_majors_row_to_delete)]
    
    built_majors(
      built_majors() %>% 
        filter(major_id != id)
    )
  })
}