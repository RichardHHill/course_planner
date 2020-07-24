
function saved_inputs_module_js(ns) {
  
  var id_to_delete = null

  $(document).on("click", "#"+ ns + "saved_inputs_table .delete_btn", function() {
  
    $(this).tooltip('hide');
    $(this).prop('disabled', true);
    //disable load button as well
    $("#" + ns + "saved_inputs_table .load_btn#" + this.id).prop('disabled', true);
    id_to_delete = this.id
    Shiny.setInputValue(ns + "saved_inputs_row_to_delete", this.id, { priority: "event"});
  });

  $(document).on("click", "#" + ns + "saved_inputs_delete_cancel_button", function() {
    $("#" + ns + "saved_inputs_table .load_btn#" + id_to_delete).prop('disabled', false);
    $("#" + ns + "saved_inputs_table .delete_btn#" + id_to_delete).prop('disabled', false);
  });
  
  $(document).on("click", "#" + ns + "saved_inputs_table .load_btn", function() {
    $(this).tooltip('hide');
    Shiny.setInputValue(ns + "saved_inputs_row_to_load", this.id, { priority: "event"});
  });
}
  