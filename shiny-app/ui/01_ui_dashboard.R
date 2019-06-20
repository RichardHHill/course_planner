tabItem(
  tabName = "dashboard",
  fluidRow(
    box(
      width = 10,
      column(
        width = 12,
        h1("Welcome to Course Planner")
      )
    ),
    br(),
    box(
      width = 10,
      fluidRow(
        column(
          width = 12,
          h2("Start picking majors or just go ahead and input courses"),
          br()
        )
      ),
      fluidRow(
        column(
          width = 12,
          actionButton(
            "go_to_majors",
            "Majors", 
            width = "200px", 
            style="color: #fff; background-color: #07b710; border-color: #07b710"
          ),
          actionButton(
            "go_to_courses", 
            "Courses", 
            width = "200px", 
            style="color: #fff; background-color: #07b710; border-color: #07b710"
          )
        )
      ),
      br(),
      fluidRow(
        column(
          width = 4,
          h3("Courses @ Brown"),
          br(),
          img(
            src = "images/brown_logo.png"
          )
        ),
        column(
          width = 4,
          h3("The Critical Review"),
          br(),
          img(
            src = "images/critical_review.jpg"
          )
        )
      )
    )
  )
)