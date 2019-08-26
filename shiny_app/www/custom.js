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
  
  ;(function() {
    var id_to_delete = null
  
    $(document).on("click", "#saved_inputs_table .delete_btn", function() {
    
    
      $(this).tooltip('hide');
      $(this).prop('disabled', true);
      //disable load button as well
      $("#saved_inputs_table .load_btn#" + this.id).prop('disabled', true);
      id_to_delete = this.id
      Shiny.setInputValue("saved_inputs_row_to_delete", this.id, { priority: "event"});
    });
  
    $(document).on("click", "#saved_inputs_delete_cancel_button", function() {
      $("#saved_inputs_table .load_btn#" + id_to_delete).prop('disabled', false);
      $("#saved_inputs_table .delete_btn#" + id_to_delete).prop('disabled', false);
    })
  })();
  
  $(document).on("click", "#saved_inputs_table .load_btn", function() {
    $(this).tooltip('hide');
    Shiny.setInputValue("saved_inputs_row_to_load", this.id, { priority: "event"});
  });
  
  $(document).on("click", "#built_majors_table .edit_btn", function() {
    $(this).tooltip('hide');
    Shiny.setInputValue("built_majors_row_to_edit", this.id, { priority: "event"});
  });
  
  $(document).on("click", "#built_majors_table .delete_btn", function() {
    $(this).tooltip('hide');
    Shiny.setInputValue("built_majors_row_to_delete", this.id, { priority: "event"});
  });
});


