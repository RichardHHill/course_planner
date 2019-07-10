$(document).on("click", "#semester1_table .deselect_btn", function() {
  Shiny.setInputValue("semester_1_remove", this.id, { priority: "event"});
  $(this).tooltip('hide');
});

$(document).on("click", "#semester2_table .deselect_btn", function() {
  Shiny.setInputValue("semester_2_remove", this.id, { priority: "event"});
  $(this).tooltip('hide');
});


// use on charge or on mouse out instead of click
// maybe .on("") 
/*$(document).on("click", "#set_inputs_1", function() {
  console.log($('#major_1_courses_table > div > table').DataTable().cell(12,1).nodes().to$().find('input').val());
})*/

$(document).on("input", "#course_name_12", function(event) {
  console.log("ran")
  //event.target.value
  //console.log(event); maybe find by class and then index by value
  //console.log($('#major_1_courses_table > div > table').DataTable().cell(12,1).nodes().to$().find('input').val());
})
