$(document).on('shiny:connected', function() {
  // event handler to display a toast message
  Shiny.addCustomMessageHandler(
    "show_toast",
    function(message) {
      toastr[message.type](
        message.title,
        message.message
      )
    }
  )
});



// use on charge or on mouse out instead of click
// maybe .on("") 
/*$(document).on("click", "#set_inputs_1", function() {
  console.log($('#major_1_courses_table > div > table').DataTable().cell(12,1).nodes().to$().find('input').val());
})*/

//$(document).on("input", "#course_name_12", function(event) {
  //console.log("ran")
  //event.target.value
  //console.log(event); maybe find by class and then index by value
  //console.log($('#major_1_courses_table > div > table').DataTable().cell(12,1).nodes().to$().find('input').val());
//})
