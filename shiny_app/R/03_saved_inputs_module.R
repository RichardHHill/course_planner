
saved_inputs_module_ui <- function(id) {
  ns <- NS(id)
  
  tabItem(
    tabName = "saved_inputs",
    fluidRow(
      box(
        width = 12,
        if (is.null(conn)) {
          h3(
            "Failed to connect to database. If you are running this app locally, it is because each IP address must
            be whitelisted to access this app's database."
          )
        } else {
          tagList(
            fluidRow(
              column(
                2,
                textInput(ns("saved_passkey"), "Passkey")
              )
            ),
            br(),
            br(),
            br(),
            DTOutput(ns("saved_inputs_table")) %>% withSpinner(type = 8)
          )
        }
      )
    ),
    tags$script(src = "saved_inputs_module.js"),
    tags$script(paste0("saved_inputs_module_js('", ns(""), "')"))
  )
}

saved_inputs_module <- function(input, output, session, semesters, built_majors, save_all_inputs) {
  ns <- session$ns
  
  semester_courses_df <- reactive({
    names <- names(reactiveValuesToList(semesters))
    
    out <- tibble(
      semester = character(0),
      code = character(0),
      name = character(0)
    )
    
    for (i in seq_along(names)) {
      out <- rbind(
        out,
        tibble(
          semester = names[[i]],
          code = semesters[[names[[i]]]]$code,
          name = semesters[[names[[i]]]]$name
        )
      )
    }
    
    out
  })
  
  
  observeEvent(save_all_inputs(), {
    showModal(
      modalDialog(
        title = "Save Courses and Majors",
        size = "s",
        footer = list(
          actionButton(
            ns("confirm_save_all"),
            "Save All",
            style = "background-color: #46c410; color: #fff",
            icon = icon("plus")
          ),
          modalButton("Cancel")
        ),
        fluidRow(
          column(
            12,
            textInput(ns("saved_name"), "Name"),
            textInput(ns("passkey"), "Passkey")
          )
        ),
        fluidRow(
          column(
            12,
            "This passkey will be used to track all of your saved tables. Make sure it's unique; anyone
            who types it in will be able to see your info!"
          )
          )
        )
      )
  })
  
  
  observeEvent(input$confirm_save_all, {
    removeModal()
    
    dat <- list(passkey = input$passkey, name = input$saved_name)
    semester_courses <- semester_courses_df()
    majors <- built_majors()
    
    progress <- Progress$new(session, min = 0, max = 3)
    progress$inc(amount = 1, message = "Saving Inputs", detail = "initializing...")
    tryCatch({
      DBI::dbWithTransaction(conn, {
        
        tychobratools::add_row(conn, "input_ids", dat)
        
        get_query <- "SELECT id from input_ids WHERE passkey=?passkey ORDER BY time_created DESC LIMIT 1"
        
        get_query <- DBI::sqlInterpolate(conn, get_query, .dots = dat["passkey"])
        
        input_set_id <- as.integer(DBI::dbGetQuery(
          conn,
          get_query
        ))
        
        progress$inc(amount = 1, message = "Saving Inputs", detail = "Semester Courses")
        
        if (nrow(semester_courses) > 0) {
          semester_courses$id <- input_set_id 
          
          DBI::dbWriteTable(
            conn,
            name = "semester_courses",
            value = semester_courses,
            append = TRUE
          )
        }
        
        progress$inc(amount = 1, message = "Saving Inputs", detail = "Majors")
        
        if (nrow(majors) > 0) {
          majors$id <- input_set_id
          
          DBI::dbWriteTable(
            conn,
            name = "majors",
            value = majors,
            append = TRUE
          )
        }
      })
      
      saved_inputs_table_trigger(saved_inputs_table_trigger() + 1)
      
      session$sendCustomMessage(
        "show_toast",
        message = list(
          type = "success",
          title = "Inputs Successfully Saved!",
          message = NULL
        )
      )
      
    }, error = function(error) {
      
      session$sendCustomMessage(
        "show_toast",
        message = list(
          type = "error",
          title = "Error Saving Inputs",
          message = NULL
        )
      )
      print(error)
    })
    
    progress$close()
  })
  
  saved_inputs_table_trigger <- reactiveVal(0)
  
  saved_inputs_table_prep <- reactive({
    saved_inputs_table_trigger()
    
    out <- conn %>% 
      tbl("input_ids") %>% 
      collect %>% 
      filter(passkey == input$saved_passkey) %>% 
      arrange(desc(time_created)) %>% 
      select(id, name)
    
    if (nrow(out) > 0) {
      rows <- seq_len(nrow(out))
      
      buttons <- paste0(
        '<div class="btn-group width_75" role="group" aria-label="Basic example">
        <button class="btn btn-primary btn-sm load_btn" data-toggle="tooltip" data-placement="top" title="Load Schedule" id = ', rows, ' style="margin: 0"><i class="fa fa-upload"></i></button>
        <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete Schedule" id = ', rows, ' style="margin: 0"><i class="fa fa-trash-o"></i></button></div>'
      )
      
      out$button <- buttons
    } else {
      out$button <- character(0)
    }
    
    out %>% 
      select(button, id, name)
  })
  
  
  output$saved_inputs_table <- renderDT({
    out <- saved_inputs_table_prep()
    
    datatable(
      out,
      rownames = FALSE,
      colnames = c("", "Id", "Name"),
      escape = -1,
      selection = "none",
      options = list(
        columnDefs = list(
          list(width = "10%", targets = 0),
          list(width = "45%", targets = c(1,2), className = "dt-center")
        )
      )
    )
  })
  
  
  observeEvent(input$saved_inputs_row_to_delete, {
    id <- as.numeric(input$saved_inputs_row_to_delete)
    
    showModal(
      modalDialog(
        title = "Delete Schedule",
        size = "s",
        footer = list(
          actionButton(
            ns("saved_inputs_delete_button"),
            "Delete",
            style="color: #fff; background-color: #dd4b39; border-color: #d73925"
          ),
          actionButton(
            ns("saved_inputs_delete_cancel_button"),
            "Cancel",
            style="color: #444; background-color: #f4f4f4; border-color: #ddd"
          )
        ),
        h3(paste0("Are you sure you want to delete schedule #", id, "?"))
      )
    )
  })
  
  observeEvent(input$saved_inputs_delete_cancel_button, {
    removeModal()
  })
  
  observeEvent(input$saved_inputs_delete_button, {
    removeModal()
    row <- as.numeric(input$saved_inputs_row_to_delete)
    
    id_to_delete <- saved_inputs_table_prep()[row, ]$id
    
    progress <- Progress$new(session, min = 0, max = 3)
    
    tryCatch({
      DBI::dbWithTransaction(conn, {
        progress$inc(amount = 1, message = "Deleting Data", detail = "Input Id")
        delete_by(conn, "input_ids", by = list(id = id_to_delete))
        
        progress$inc(amount = 1, message = "Deleting Data", detail = "Semester Courses")
        delete_by(conn, "semester_courses", by = list(id = id_to_delete))
        
        progress$inc(amount = 1, message = "Deleting Data", detail = "Majors")
        delete_by(conn, "majors", by = list(id = id_to_delete))
      })
      
      saved_inputs_table_trigger(saved_inputs_table_trigger() + 1)
      
      session$sendCustomMessage(
        "show_toast",
        message = list(
          type = "success",
          title = "Schedule Deleted",
          message = NULL
        )
      )
    }, error = function(error) {
      
      session$sendCustomMessage(
        "show_toast",
        message = list(
          type = "error",
          title = "Error Deleting Schedule",
          message = NULL
        )
      )
      
      print("error deleting input set")
      print(error)
    })
    
    progress$close()
  })
  
  
  load_trigger <- reactiveValues()
  
  observeEvent(input$saved_inputs_row_to_load, {
    progress <- Progress$new(session, min = 0, max = 2)
    
    row <- as.numeric(input$saved_inputs_row_to_load)
    
    id_to_load <- saved_inputs_table_prep()[row, ]$id
    
    progress$inc(amount = 1, message = "Loading Courses")
    
    semesters_df <- conn %>%
      tbl("semester_courses") %>% 
      collect %>% 
      filter(id == id_to_load)
    
    for (semester_name in unique(semesters_df$semester)) {
      courses <- semesters_df %>% 
        filter(semester == semester_name) %>% 
        select(code, name)
      
      semesters[[semester_name]] <- courses
    }
    
    
    progress$inc(amount = 1, message = "Loading Majors")
    
    majors_df <- conn %>% 
      tbl("majors") %>% 
      collect %>% 
      filter(id == id_to_load) %>% 
      select(-id)
    
    built_majors(majors_df)
    
    
    progress$close()
  })
  
}