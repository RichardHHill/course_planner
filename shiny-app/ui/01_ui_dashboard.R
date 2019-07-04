tabItem(
  tabName = "dashboard",
  fluidRow(
    box(
      width = 8,
      fluidRow(
        column(
          width = 12,
          align = "center",
          h1("Welcome to Course Planner")
        )
      ),
      fluidRow(
        column(
          width = 6,
          align = "center",
          h3("Choose Majors"),
          actionButton(
            "go_to_majors",
            "Majors", 
            width = "200px", 
            style="color: #fff; background-color: #07b710; border-color: #07b710"
          )
        ),
        column(
          width = 6,
          align = "center",
          h3("or Pick Courses"),
          actionButton(
            "go_to_courses", 
            "Courses", 
            width = "200px", 
            style="color: #fff; background-color: #07b710; border-color: #07b710"
          )
        )
      ),
      br(),
      br()
    )
  ),
  fluidRow(
    box(
      width = 8,
      fluidRow(
        column(
          12,
          align = "center",
          h2("Course Information")
        )
      ),
      fluidRow(
        column(
          width = 4,
          align = "center",
          h3("Courses @ Brown"),
          br(),
          a(
            href = "https://cab.brown.edu",
            img(
              src = "images/brown_logo.png"
            ),
            target = "_blank"
          )
        ),
        column(
          width = 4,
          align = "center",
          h3("The Critical Review"),
          br(),
          a(
            href="https://thecriticalreview.org",
            img(
              src = "images/critical_review.jpg",
              style = "height: 220px; width: 220px"
            ),
            target = "_blank"
          )
        ),
        column(
          width = 4,
          align = "center",
          h3("Concentrations"),
          br(),
          a(
            href="https://bulletin.brown.edu/the-college/concentrations/",
            img(
              src = "images/brown_logo.png",
              style = "height: 220px; width: 220px"
            ),
            target = "_blank"
          )
        )
      ),
      br(),
      br()
    )
  )
)