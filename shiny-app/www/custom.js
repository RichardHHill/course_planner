$(document).on("click", "#semester1_table .deselect_btn", function() {
  Shiny.setInputValue("semester_1_remove", this.id, { priority: "event"});
  $(this).tooltip('hide');
});

$(document).on("click", "#semester2_table .deselect_btn", function() {
  Shiny.setInputValue("semester_2_remove", this.id, { priority: "event"});
  $(this).tooltip('hide');
});
