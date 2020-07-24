$(document).on('shiny:connected', function() {
  // event handler to display a toast message
  Shiny.addCustomMessageHandler(
    "show_toast",
    function(message) {
      toastr[message.type](
        message.title,
        message.message
      )
    }
  )
});


