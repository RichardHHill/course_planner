tabItem(
  tabName = "dashboard",
  fluidRow(
    column(
      8,
      fluidRow(
        box(
          width = 12,
          fluidRow(
            column(
              12,
              align = "center",
              h1("Welcome to Course Planner")
            )
          ),
          fluidRow(
            column(
              6,
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
              6,
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
          width = 12,
          fluidRow(
            column(
              12,
              align = "center",
              h1("Course Information")
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
              4,
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
              4,
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
    ),
    column(
      4,
      fluidRow(
        box(
          width = 12,
          fluidRow(
            column(
              12,
              align = "center",
              h1("Saved Schedules")
            )
          ),
          fluidRow(
            column(
              12,
              align = "center",
              h3("View Saved"),
              actionButton(
                "go_to_saved",
                "Saved", 
                width = "200px", 
                style="color: #fff; background-color: #07b710; border-color: #07b710"
              )
            )
          ),
          br(),
          fluidRow(
            column(
              12,
              span(
                p("You can save your inputs in the \"Courses\" tab with a passkey.
                   Use this passkey in the \"Saved Inputs\" tab
                   to see all of your saved schedules. This can be used to view your schedules on any computer,
                   but be aware that anyone can save their schedules to the same passkey, and anyone 
                   else who puts in the passkey will be able to see your schedules"),
                style = "font-size: 20px"
              )
            )
          ),
          br(),
          br()
        )
      )
    )
  )
)