# Module for creating a semester used on the courses tab

semester_module_ui <- function(id, name) {
  ns <- NS(id)
  
  tagList(
    column(
      width = 3,
      box(
        width = 12,
        fluidRow(
          column(
            6,
            h4(name)
          ),
          column(
            6,
            align = "right",
            actionButton(
              ns("add_course"),
              " ",
              icon = icon("plus")
            )
          )
        ),
        DTOutput(ns("semester_table"))
      )
    ),
    tags$script(src = "semester_module.js"),
    tags$script(paste0("semester_module_js('", ns(""), "')"))
  )
}

semester_module <- function(input, output, session, semester_uid, delete_mode, semester_courses, name) {
  ns <- session$ns

  observeEvent(input$add_course, {
    showModal(
      modalDialog(
        title = paste0("Add Course to ", name),
        size = "m",
        footer = list(
          actionButton(ns("submit_course"), "Add Course"),
          modalButton("Cancel")
        ),
        fluidRow(
          column(
            12,
            align = "center",
            radioButtons(
              ns("pick_or_custom"),
              " ",
              choices = c("Select Course", "Custom"),
              inline = TRUE
            )
          )
        ),
        conditionalPanel(
          "input.pick_or_custom === 'Select Course'",
          ns = ns,
          fluidRow(
            column(
              6,
              pickerInput(
                ns("department_to_add"),
                "Department",
                choices = all_departments$code,
                choicesOpt = list(subtext = all_departments$name),
                options = pickerOptions(
                  showSubtext = TRUE
                )
              )
            ),
            column(
              6,
              pickerInput(
                ns("course_to_add"),
                "Course",
                choices = NULL,
                options = pickerOptions(
                  showSubtext = TRUE
                )
              )
            )
          )
        ),
        conditionalPanel(
          "input.pick_or_custom == 'Custom'",
          ns = ns,
          fluidRow(
            column(
              6,
              textInput(
                ns("code_to_add"),
                "Course Code",
                placeholder = "ECON 0110"
              )
            ),
            column(
              6,
              textInput(
                ns("name_to_add"),
                "Course Name",
                placeholder = "Principles of Econ"
              )
            )
          )
        )
      )
    )
    
    observeEvent(input$department_to_add, {
      hold <- all_courses %>%
        filter(department == input$department_to_add)
      
      updatePickerInput(
        session,
        "course_to_add", 
        "Course",
        choices = hold$course_code,
        choicesOpt = list(subtext = hold$name)
      )
    })
  })
  
  observeEvent(input$submit_course, {
    removeModal()
    
    type <- input$pick_or_custom
    semester <- ns("semester")
    
    if (type == "Custom") {
      code <- trimws(input$code_to_add)
      course <- trimws(input$name_to_add)
    } else {
      code <- input$course_to_add
      course <- course_codes_to_name(code)
    }
    
    semester_courses() %>% 
      tibble::add_row(semester_uid = semester_uid, course_code = code, course_name = course) %>% 
      semester_courses()
  })
  
  semester_out <- reactiveVal(tibble("Remove" = character(0)))
  
  observe({
    out <- semester_courses() %>% 
      filter(.data$semester_uid == .env$semester_uid)
    
    if (delete_mode() & nrow(out) > 0) {
      ids <- seq_len(nrow(out))
      buttons <- paste0('<button class="btn btn-danger btn-sm deselect_btn" data-toggle="tooltip" data-placement="top" title="Remove Course" id = ', ids, ' style="margin: 0"><i class="fa fa-minus-circle"></i></button></div>')
      
      buttons <- tibble("Remove" = buttons)
      
      out <- bind_cols(
        buttons,
        out
      )
    }
    
    semester_out(out)
  })
  
  observe({
    if (nrow(semester_out()) == 0) {
      hideElement("semester_table")
    } else {
      showElement("semester_table")
    }
  })
  
  output$semester_table <- renderDT({
    out <- semester_out() %>% 
      select(-semester_uid)
    req(nrow(out) > 0)
    
    datatable(
      out,
      rownames = FALSE,
      colnames = rep("", length(out)),
      options = list(
        dom = "t",
        ordering = FALSE
      ),
      escape = -1,
      selection = "none"
    )
  })
  
  observeEvent(input$semester_remove, {
    row <- as.numeric(input$semester_remove)
    
    out <- semester_courses() %>% 
      filter(.data$semester_uid == .env$semester_uid)
    
    out <- out[-row,]
    
    semester_courses() %>% 
      filter(.data$semester_uid != .env$semester_uid) %>% 
      bind_rows(out) %>% 
      semester_courses()
  })
}
