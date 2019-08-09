function myModuleJS(ns) {  
  $(document).on("click", "#" + ns + "semester_table .deselect_btn", function() {
    console.log(this.id);
    console.log(ns + "semester_remove");
    Shiny.setInputValue(ns + "semester_remove", this.id, { priority: "event"});
    $(this).tooltip('hide');
  });
}
