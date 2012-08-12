// Loads all Bootstrap javascripts
//= require bootstrap

$(function() {
  $('.date-field').datepicker({ dateFormat: "yy-mm-dd" });
  $('.datetime-field').datetimepicker({ dateFormat: "yy-mm-dd", timeFormat: "hh:mm tt" })
});
