$(document).ready(function() {
  BusTracker.setDirections();
  BusTracker.setStops();
});

BusTracker = {
  setDirections: function() {
    $('#route_number').change(function(){
      var route_number = $('#route_number').val();
      if (route_number) {
        BusTracker.getDirections(route_number);
        BusTracker.showDiv('.directions');
      } else {
        BusTracker.hideDiv('.directions');
        BusTracker.hideDiv('.stops');
        BusTracker.clearSelectTagFor("#direction");
        BusTracker.populateSelectTag("#directions", null, 'Go Back and Pick a Route'); //is this needed? i don't think so
        BusTracker.hideDiv('.stops');
      }
    });
  },
  getDirections: function(route_number) {
    var url = "bus_tracker/route/" + route_number + "/get_directions";

    $.ajax({
      type: 'GET',
      url: url,
      dataType: "json",
      success: function(data) {
        var directions = data.directions.split(',');
        BusTracker.clearSelectTagFor('#direction');
        BusTracker.populateSelectTag('#direction', null, 'Select One');
        $.each(directions, function(index, option){
          BusTracker.populateSelectTag('#direction', option, option);
        });
      }
    });
  },
  clearSelectTagFor: function(select_tag) {
    $(select_tag).html("");
  },
  populateSelectTag: function(selectTag, value, text){
    $(selectTag).append(
      $(document.createElement("option")).val(value).text(text)
    );
  },
  showDiv: function(divId) {
    $(divId).show();
  },
  hideDiv: function(divId) {
    $(divId).hide();
  },
  setStops: function() {
    $('#direction').change(function(){
      var direction = $('#direction').val();
      var route_number = $('#route_number').val();
      if (direction) {
        BusTracker.getStops(route_number, direction);
        BusTracker.showDiv('.stops');
      } else {
        $('.output').html('');
        BusTracker.hideDiv('.stops');
        BusTracker.clearSelectTagFor('#stop');
        BusTracker.populateSelectTag('#stop', null, 'Go Back and Pick a Direction'); //is this needed? i don't think so
      }
    });
  },
  getStops: function(route_number, direction) {
    var url = "bus_tracker/route/" + route_number + "/direction/" + direction + "/get_stops";
    $.ajax({
      type: 'GET',
      url: url,
      dataType: "json",
      success: function(data) {
        BusTracker.clearSelectTagFor('#stop');
        BusTracker.populateSelectTag('#stop', null, 'Select One');
        $.each(data, function(index, option){
          BusTracker.populateSelectTag('#stop', option.stop_id, option.name);
        });
      }
    });
    $('#stop').change(function(){
      var stop_id = $('#stop').val();
      BusTracker.displayPredictions(route_number, stop_id);
    });
  },
  displayPredictions: function(route_number, stop_id) {
    $('.output').html('');
    BusTracker.showDiv('.output');
    BusTracker.getPredictions(route_number, stop_id);
    $('.output').append(
      $(document.createElement("h2")).text("- - - CTA Bus - - -")
    );
  },
  getPredictions: function(route_number, stop_id){
    var url = "bus_tracker/route/" + route_number + "/stop_id/" + stop_id + "/get_predictions";
    $.ajax({
      type: 'GET',
      url: url,
      dataType: "json",
      success: function(data) {
        $.each(data, function(index, option){
          //call template here to display each prediction(s)
        });
      },
      error: function(){
        // TO DO: display to user that there was en error
      }
    });
  }
};
