tabItem(
  tabName = "dashboard",
  fluidRow(
    box(
      width = 10,
      column(
        width = 12,
        h1("Welcome to Course Planner, the most efficient way to waste time!")
      )
    ),
    br(),
    box(
      width = 10,
      column(
        width = 12,
        h2("Start picking majors or just go ahead and input courses"),
        br(),
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
    )
  )
)