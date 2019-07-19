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
  
  ;(function() {
    var id_to_delete = null
  
    $(document).on("click", "#saved_inputs_table .delete_btn", function() {
    
    
      $(this).tooltip('hide');
      $(this).prop('disabled', true);
      //disable load button as well
      $("#saved_inputs_table .load_btn#" + this.id).prop('disabled', true);
      id_to_delete = this.id
      Shiny.setInputValue("input_sets_row_to_delete", this.id, { priority: "event"});
    });
  
    $(document).on("click", "#input_set_delete_cancel_button", function() {
      console.log("Cancel clicked");
      $("#saved_inputs_table .load_btn#" + id_to_delete).prop('disabled', false);
      $("#saved_inputs_table .delete_btn#" + id_to_delete).prop('disabled', false);
    })
  
    
  })()
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
