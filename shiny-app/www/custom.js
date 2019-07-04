$(document).on("click", "#semester1_text .deselect_btn", function() {
  Shiny.setInputValue("semester_1_remove", this.id, { priority: "event"});
  $(this).tooltip('hide');
});
