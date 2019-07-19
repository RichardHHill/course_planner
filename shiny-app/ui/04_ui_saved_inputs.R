tabItem(
  tabName = "saved_inputs",
  fluidRow(
    box(
      width = 12,
      fluidRow(
        column(
          2,
          textInput("saved_passkey", "Passkey", value = "password1")
        )
      ),
      br(),
      br(),
      br(),
      DTOutput("saved_inputs_table")
    )
  )
)