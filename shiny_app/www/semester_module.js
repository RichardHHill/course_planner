function semester_module_js(ns) {  
  $(document).on("click", "#" + ns + "semester_table .deselect_btn", function() {
    Shiny.setInputValue(ns + "semester_remove", this.id, { priority: "event"});
    $(this).tooltip('hide');
  });
}
