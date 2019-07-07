$(document).on("click", "#semester1_table .deselect_btn", function() {
  Shiny.setInputValue("semester_1_remove", this.id, { priority: "event"});
  $(this).tooltip('hide');
});

$(document).on("click", "#semester2_table .deselect_btn", function() {
  Shiny.setInputValue("semester_2_remove", this.id, { priority: "event"});
  $(this).tooltip('hide');
});



$(document).on("click", "#set_inputs_1", function() {
  console.log("Hi");
  console.log($('#major_1_courses_table > div > table').DataTable().column().data());
  //.cell(12,1).nodes().to$().find('input').val());
})
