
function majors_module_js(ns) {
  $(document).on("click", "#" + ns + "built_majors_table .edit_btn", function() {
    $(this).tooltip('hide');
    Shiny.setInputValue(ns + "built_majors_row_to_edit", this.id, { priority: "event"});
  });
  
  $(document).on("click", "#" + ns + "built_majors_table .delete_btn", function() {
    $(this).tooltip('hide');
    Shiny.setInputValue(ns + "built_majors_row_to_delete", this.id, { priority: "event"});
  });
}