
select_courses_module_ui <- function(id) {
  ns <- NS(id)
  
  tabItem(
    tabName = "select_courses",
    fluidRow(
      box(
        width = 12,
        fluidRow(
          column(
            6,
            actionButton(
              ns("edit_semesters"),
              "Edit Semesters",
              class = "btn-primary",
              style = "color: #fff;"
            )
          ),
          column(
            6,
            align = "right",
            actionButton(
              ns("enable_delete_mode"),
              "Delete Courses",
              class = "btn-danger",
              style = "color: #fff;"
            ),
            actionButton(ns("disable_delete_mode"), "Stop Deleting") %>% hidden
          )
        ),
        br(),
        br(),
        uiOutput(ns("semesters_ui"))
      )
    ),
    fluidRow(
      uiOutput(ns("major_tables_ui"))
    ),
    tags$script(src = "select_courses_module.js"),
    tags$script(paste0("select_courses_module_js('", ns(""), "')"))
  )
}

select_courses_module <- function(input, output, session, built_majors, semester_names, semester_courses) {
  ns <- session$ns
  
  delete_mode <- reactiveVal(FALSE)
  
  observeEvent(input$enable_delete_mode, {
    delete_mode(TRUE)
    hideElement("enable_delete_mode")
    showElement("disable_delete_mode")
  })
  
  observeEvent(input$disable_delete_mode, {
    delete_mode(FALSE)
    hideElement("disable_delete_mode")
    showElement("enable_delete_mode")
  })
  
  # Modal with datatable to add, edit, and delete semesters
  observeEvent(input$edit_semesters, {
    showModal(
      modalDialog(
        actionButton(
          ns("add_semester"),
          "",
          icon = icon("plus"),
          class = "btn-primary",
          style = "color: #fff;"
        ),
        DTOutput(ns("semester_names_table")),
        title = "Edit Semesters",
        footer = list(
          actionButton(
            ns("cancel_edit_semesters"),
            "Cancel"
          ),
          actionButton(
            ns("submit_edit_semesters"),
            "Submit",
            class = "btn-primary",
            style = "color: #fff;"
          )
        ),
        size = "m"
      )
    )
  })
  
  # Hold semester names for edit until table is submitted
  semester_names_hold <- reactiveVal()
  
  observeEvent(semester_names(), semester_names_hold(semester_names()))
  
  
  semester_names_table_prep <- reactiveVal()
  
  observe({
    out <- semester_names_hold()
    
    if (nrow(out) > 0) {
      ids <- out$semester_uid
      
      buttons <- paste0(
        '<button class="btn btn-danger btn-sm delete_btn" id = ', 
        ids, 
        ' style="margin: 0; width: 35px;"><i class="fa fa-trash-o"></i></button>'
      )
      
      out <- bind_cols(tibble(buttons = buttons), out)
    }
    
    out <- out %>% 
      select(-semester_uid)
    
    if (is.null(semester_names_table_prep())) {
      semester_names_table_prep(out)
    } else {
      replaceData(semester_names_table_proxy, out, rownames = FALSE)
    }
  })
  
  output$semester_names_table <- renderDT({
    out <- semester_names_table_prep()
    
    datatable(
      out,
      editable = list(target = "cell", disable = list(columns = 0)),
      rownames = FALSE,
      colnames = "Double Click to Edit",
      selection = "none",
      escape = -1,
      options = list(
        dom = "tp",
        ordering = FALSE,
        columnDefs = list(
          list(width = "50px", targets = 0)
        )
      )
    )
  })
  
  outputOptions(output, "semester_names_table", suspendWhenHidden = FALSE)
  semester_names_table_proxy <- dataTableProxy("semester_names_table")
  
  
  observeEvent(input$add_semester, {
    semester_names_hold() %>% 
      tibble::add_row(semester_uid = UUIDgenerate(), semester_name = "") %>% 
      semester_names_hold()
  })
  
  # Update Edited Cell Names
  observeEvent(input$semester_names_table_cell_edit, {
    change <- input$semester_names_table_cell_edit
    
    if (change$col == 1) { 
      hold <- semester_names_hold()
      hold[change$row, 2] <- change$value
    
      semester_names_hold(hold)
    }
  })
  
  observeEvent(input$semester_delete, {
    semester_names_hold() %>% 
      filter(semester_uid != input$semester_delete) %>% 
      semester_names_hold()
  })
  
  # Update semester names to our held values
  observeEvent(input$submit_edit_semesters, {
    removeModal()
    semester_names(semester_names_hold())
  })
  
  # Cancelling, reset held values
  observeEvent(input$cancel_edit_semesters, {
    removeModal()
    semester_names_hold(semester_names())
  })
  
  observeEvent(semester_names(), ignoreInit = TRUE, {
    # Remove all rows from deleted semesters
    semester_courses() %>% 
      filter(semester_uid %in% semester_names()$semester_uid) %>% 
      semester_courses()
  })
  
  
  # Keep track so we don't call the module server code multiple times on one uid
  semester_modules_created <- reactiveVal({
    tibble(uid = character(0), ui = list())
  })
  
  # Call a module for each semester
  output$semesters_ui <- renderUI({
    hold_names <- semester_names()
    existing <- isolate(semester_modules_created())
    
    layers <- ceiling(nrow(hold_names) / 4)
    
    out <- lapply(seq_len(layers), function(layer) {
      idx <- 1:4 + 4 * (layer - 1)
      idx <- idx[idx <= nrow(hold_names)]
      hold <- hold_names[idx, ]
      
      row <- lapply(seq_len(nrow(hold)), function(i)  {
        if (hold[[i,1]] %in% existing$uid) {
          ui <- existing %>% 
            filter(uid == hold[[i,1]]) %>% 
            pull(ui)
          
          ui <- ui[[1]]
        } else {
          
          callModule(
            semester_module, 
            hold[[i,1]],
            semester_uid = hold[[i,1]],
            delete_mode = delete_mode,
            semester_courses = semester_courses,
            semester_names = semester_names
          )
          
          ui <- semester_module_ui(ns(hold[[i,1]]))
          
          existing <<- existing %>% 
            tibble::add_row(uid = hold[[i,1]], ui = list(ui))
        }
        
        ui
      })
      
      fluidRow(tagList(row))
    })
   
    semester_modules_created(existing)
    
    tagList(out)
  })
  
  
  tables_list <- reactive({
    req(built_majors())
    built_majors <- built_majors()
    
    major_ids <- unique(built_majors$major_id)
    
    names <- built_majors %>% 
      select(major_name, major_id) %>% 
      distinct %>% 
      pull(major_name)
    
    
    out <- lapply(major_ids, function(id) {
      major <- built_majors %>% 
        filter(major_id == id)
      
      course_codes <- major$code
      
      schedule_list <- semester_courses()$course_code
      
      in_schedule <- lapply(toupper(course_codes) %in% toupper(schedule_list), function(x) {
        if (isTRUE(x)) {
          as.character(icon("check-circle"))
        } else {
          as.character(icon("circle"))
        }
      })
      
      tibble(
        code = course_codes,
        name = major$name,
        in_schedule = unlist(in_schedule)
      )
    })
    
    names(out) <- names
    out
  })
  
  
  output$major_tables_ui <- renderUI({
    tables <- tables_list()
    
    if (length(tables) == 0) {
      box(
        width = 12,
        fluidRow(
          column(
            12,
            align = "center",
            h2("Built Majors Will Show Up Here")
          )
        )
      )
    } else {
      lapply(seq_along(tables), function(x) {
        
        box(
          width = 4,
          title = names(tables)[[x]],
          datatable(
            tables[[x]],
            width = "100%",
            rownames = FALSE,
            colnames = c("Code", "Name", ""),
            options = list(
              dom = "t",
              pageLength = 25,
              scrollY = "400px"
            ),
            escape = -3,
            selection = "none"
          )
        )
      })
    }
  })
}
