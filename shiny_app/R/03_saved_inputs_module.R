
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
                textInput(ns("passkey"), "Passkey", value = "demo")
              ),
              column(
                2,
                textInput(ns("name_to_save"), "Name")
              ),
              column(
                1,
                actionButton(
                  ns("save_all"),
                  "Save",
                  class = "btn-primary",
                  style = "color: #fff; margin-top: 25px;",
                  width = "100%"
                )
              ),
              column(
                1,
                id = ns("update_saved_col"),
                actionButton(
                  ns("update_saved"),
                  "Update",
                  class = "btn-primary",
                  style = "color: #fff; margin-top: 25px;",
                  width = "100%"
                )
              ) %>% hidden(),
              column(
                1,
                circleButton(
                  ns("show_info"),
                  icon = icon("info"),
                  size = "xs",
                  style = "margin-top: 35px;"
                )
              )
            ),
            fluidRow(
              column(
                6,
                h4(
                  id = ns("info_text"),
                  "This app does not include authentication; schedules are saved to a passkey. Anyone who enters this
                  passkey will see all its saved schedules."
                ) %>% hidden()
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

saved_inputs_module <- function(input, output, session, built_majors, semester_names, semester_courses) {
  ns <- session$ns
  
  observeEvent(input$show_info, toggleElement("info_text", anim = TRUE))
  
  # observe({
  #   if (nchar(input$passkey) <= 6) {
  #     showFeedbackDanger("passkey", "Passkey must be at least 6 characters")
  #     disable("save_all")
  #     disable("update_saved")
  #   } else {
  #     hideFeedback("passkey")
  #     enable("save_all")
  #     enable("update_saved")
  #   }
  # })
  
  observe({
    hold <- loaded_metadata()
    
    if (is.null(hold)) {
      hideElement("update_saved_col") 
    } else {
      if (input$passkey == hold$passkey) {
        showElement("update_saved_col")
      } else {
        hideElement("update_saved_col")
      }
    }
  })
  
  
  loaded_metadata <- reactiveVal()
  
  observeEvent(input$save_all, {
    new_uid <- UUIDgenerate()
    dat <- list(uid = new_uid, passkey = input$passkey, name = input$name_to_save)
    loaded_metadata(dat)
    
    semester_names <- semester_names()
    semester_courses <- semester_courses()
    majors <- built_majors()
    
    progress <- Progress$new(session, min = 0, max = 3)
    progress$inc(amount = 1, message = "Saving", detail = "initializing...")
    tryCatch({
      DBI::dbWithTransaction(conn, {
        
        
        tychobratools::add_row(conn, "input_ids", dat)
        
        progress$inc(amount = 1, message = "Saving", detail = "Semester Courses")
        
        if (nrow(semester_names) > 0) {
          semester_names$schedule_uid <- new_uid
          
          DBI::dbWriteTable(
            conn,
            name = "semester_names",
            value = semester_names,
            append = TRUE
          )
        }
        
        if (nrow(semester_courses) > 0) {
          semester_courses$schedule$uid <- new_uid
          
          DBI::dbWriteTable(
            conn,
            name = "semester_courses",
            value = semester_courses,
            append = TRUE
          )
        }
        
        progress$inc(amount = 1, message = "Saving", detail = "Majors")
        
        if (nrow(majors) > 0) {
          majors$schedule_uid <- new_uid
          
          DBI::dbWriteTable(
            conn,
            name = "majors",
            value = majors,
            append = TRUE
          )
        }
      })
      
      saved_inputs_table_trigger(saved_inputs_table_trigger() + 1)
      
      showToast("success", "Schedule Successfully Saved")
      
    }, error = function(error) {
      
      showToast("error", "Error Saving Schedule")
      print(error)
    })
    
    progress$close()
  })
  
  
  observeEvent(input$update_saved, {
    hold <- loaded_metadata()
    req(hold)
    dat <- hold[c("name", "passkey")]
    
    semester_names <- semester_names()
    semester_courses <- semester_courses()
    majors <- built_majors()
    
    progress <- Progress$new(session, min = 0, max = 3)
    progress$inc(amount = 1, message = "Updating", detail = "initializing...")
    tryCatch({
      DBI::dbWithTransaction(conn, {
        
        tychobratools::update_by(conn, "input_ids", by = list(uid = hold$uid), .dat = dat)
        
        # Also want to update the date modified; this one does not need protection
        # against SQL injection
        dbExecute(
          conn, 
          "UPDATE input_ids SET time_modified=NOW() WHERE uid=$1",
          params = list(hold$uid)
        )
        
        progress$inc(amount = 1, message = "Updating", detail = "Semester Courses")
        
        tychobratools::delete_by(conn, "semester_names", by = list(schedule_uid = hold$uid))
        
        if (nrow(semester_names) > 0) {
          semester_names$schedule_uid <- hold$uid
          
          DBI::dbWriteTable(
            conn,
            name = "semester_names",
            value = semester_names,
            append = TRUE
          )
        }
        
        tychobratools::delete_by(conn, "semester_courses", by = list(schedule_uid = hold$uid))
        
        if (nrow(semester_courses) > 0) {
          semester_courses$schedule_uid <- hold$uid
          
          DBI::dbWriteTable(
            conn,
            name = "semester_courses",
            value = semester_courses,
            append = TRUE
          )
        }
        
        progress$inc(amount = 1, message = "Updating", detail = "Majors")
        
        tychobratools::delete_by(conn, "majors", by = list(schedule_uid = hold$uid))
        
        if (nrow(majors) > 0) {
          majors$schedule_uid <- hold$uid
          
          DBI::dbWriteTable(
            conn,
            name = "majors",
            value = majors,
            append = TRUE
          )
        }
      })
      
      saved_inputs_table_trigger(saved_inputs_table_trigger() + 1)
      
      showToast("success", "Schedule Successfully Saved")
      
    }, error = function(error) {
      
      showToast("error", "Error Saving Schedule")
      print(error)
    })
    
    progress$close()
  })
  
  saved_inputs_table_trigger <- reactiveVal(0)
  
  saved_inputs_table_prep <- reactive({
    saved_inputs_table_trigger()
    passkey <- input$passkey
    
    out <- conn %>% 
      tbl("input_ids") %>% 
      filter(.data$passkey == .env$passkey) %>% 
      arrange(desc(time_modified)) %>% 
      collect() %>% 
      mutate(time_created = as.Date(time_created), time_modified = as.Date(time_modified))
    
    if (nrow(out) > 0) {
      ids <- out$uid
      
      buttons <- paste0(
        '<div class="btn-group width_75" role="group" aria-label="Basic example">
        <button class="btn btn-primary btn-sm load_btn" data-toggle="tooltip" data-placement="top" title="Load Schedule" id = ', ids, ' style="margin: 0"><i class="fa fa-upload"></i></button>
        <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete Schedule" id = ', ids, ' style="margin: 0"><i class="fa fa-trash-o"></i></button></div>'
      )
      
      out$button <- buttons
    } else {
      out$button <- character(0)
    }
    
    out
  })
  
  
  output$saved_inputs_table <- renderDT({
    out <- saved_inputs_table_prep() %>% 
      select(button, name, time_created, time_modified)
    
    datatable(
      out,
      rownames = FALSE,
      colnames = c("", "Name", "Created", "Updated"),
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
    hold_uid <- input$saved_inputs_row_to_delete
    
    hold_name <- saved_inputs_table_prep() %>% 
      filter(uid == hold_uid) %>% 
      pull(name)
    
    showModal(
      modalDialog(
        title = "Delete Schedule",
        size = "s",
        footer = list(
          actionButton(
            ns("saved_inputs_delete_button"),
            "Delete",
            class = "btn-danger",
            style = "color: #fff;"
          ),
          actionButton(
            ns("saved_inputs_delete_cancel_button"),
            "Cancel",
            style = "color: #444; background-color: #f4f4f4; border-color: #ddd"
          )
        ),
        h3(paste0("Are you sure you want to delete ", hold_name, "?"))
      )
    )
  })
  
  observeEvent(input$saved_inputs_delete_cancel_button, {
    removeModal()
  })
  
  observeEvent(input$saved_inputs_delete_button, {
    removeModal()

    uid_to_delete <- input$saved_inputs_row_to_delete
    
    progress <- Progress$new(session, min = 0, max = 2)
    progress$inc(amount = 1, message = "Deleting Data", detail = "Input Id")
    
    tryCatch({
      delete_by(conn, "input_ids", by = list(uid = uid_to_delete))
      
      if (isTRUE(loaded_metadata()$uid == uid_to_delete)) loaded_metadata(NULL)
      
      saved_inputs_table_trigger(saved_inputs_table_trigger() + 1)
      
      showToast("success", "Schedule Deleted")
    }, error = function(error) {
      
      showToast("error", "Error Deleting Schedule")
      
      print("error deleting input set")
      print(error)
    })
    
    progess$inc(amount = 1)
    progress$close()
  })
  
  
  load_trigger <- reactiveValues()
  
  observeEvent(input$saved_inputs_row_to_load, {
    progress <- Progress$new(session, min = 0, max = 2)
    
    uid_to_load <- input$saved_inputs_row_to_load
    
    progress$inc(amount = 1, message = "Loading Courses")
    
    conn %>% 
      tbl("semester_names") %>% 
      filter(schedule_uid == uid_to_load) %>% 
      select(-schedule_uid) %>% 
      collect() %>% 
      semester_names()
    
    conn %>%
      tbl("semester_courses") %>% 
      filter(schedule_uid == uid_to_load) %>% 
      select(-schedule_uid) %>% 
      collect() %>% 
      semester_courses()
    
    progress$inc(amount = 1, message = "Loading Majors")
    
    conn %>% 
      tbl("majors") %>% 
      filter(schedule_uid == uid_to_load) %>% 
      select(-schedule_uid) %>% 
      collect() %>% 
      built_majors()
    
    dat <- conn %>% 
      tbl("input_ids") %>% 
      filter(uid == uid_to_load) %>% 
      select(passkey, name) %>% 
      collect()
    
    loaded_metadata(list(uid = uid_to_load, passkey = dat$passkey, name = dat$name))
    
    updateTextInput(
      session,
      "name_to_save",
      value = dat$name
    )
    
    progress$close()
  })
  
}