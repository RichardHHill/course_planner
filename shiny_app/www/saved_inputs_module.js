
function saved_inputs_module_js(ns) {

  $(document).on("click", "#"+ ns + "saved_inputs_table .delete_btn", function() {
    $(this).tooltip('hide');
    Shiny.setInputValue(ns + "saved_inputs_row_to_delete", this.id, { priority: "event"});
  });
  
  $(document).on("click", "#" + ns + "saved_inputs_table .load_btn", function() {
    $(this).tooltip('hide');
    Shiny.setInputValue(ns + "saved_inputs_row_to_load", this.id, { priority: "event"});
  });
}
  