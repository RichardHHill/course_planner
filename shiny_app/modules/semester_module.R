# Module for creating a semester used on the courses tab

semester_module_ui <- function(id) {
  ns <- NS(id)
  
  column(
    width = 3,
    box(
      width = 12,
      fluidRow(
        column(
          6,
          h4(paste0("Semester ", id))
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
  )
}

semester_module <- function(input, output, session, id, delete_mode, semesters, semester_remove) {
  ns <- session$ns
  runjs(paste0("myModuleJS('", ns(""), "');"))
  
  observeEvent(input$add_course, {
    showModal(
      modalDialog(
        title = paste0("Add Course to Semester ", id),
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
                choices = NULL
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
      hold <- course_codes %>%
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
    semester <- paste0("semester", id)
    
    if (type == "Custom") {
      code <- trimws(input$code_to_add)
      course <- trimws(input$name_to_add)
    } else {
      code <- input$course_to_add
      course <- course_code_to_name(code)
    }
    
    semesters[[semester]] <- rbind(
      semesters[[semester]], 
      tibble(
        code = code,
        name = course
      )
    )
  })
  
  semester_out <- reactiveVal()
  
  observe({
    out <- semesters[[paste0("semester", id)]]
    req(out)
    ids <- seq_len(nrow(out))
    
    if (delete_mode() & nrow(out) > 0) {
      buttons <- paste0('<button class="btn btn-danger btn-sm deselect_btn" data-toggle="tooltip" data-placement="top" title="Remove Course" id = ', ids, ' style="margin: 0"><i class="fa fa-minus-circle"></i></button></div>')
      
      buttons <- tibble("Remove" = buttons)
      
      out <- bind_cols(
        buttons,
        out
      )
    }
    
    semester_out(out)
  })
  
  
  output$semester_table <- renderDT({
    req(semesters[[paste0("semester", id)]], nrow(semester_out()) > 0)
    
    out <- semester_out()
    
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
  
  observeEvent(semester_remove(), {
    row <- as.numeric(semester_remove())
    
    semesters[[paste0("semester", id)]] <- semesters[[paste0("semester", id)]][-row,]
    semester_out(semester_out()[-row,])
  })
}
