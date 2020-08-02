function select_courses_module_js(ns) {  
  $(document).on("click", "#" + ns + "semester_names_table .delete_btn", function() {
    Shiny.setInputValue(ns + "semester_delete", this.id, { priority: "event"});
  });
}
