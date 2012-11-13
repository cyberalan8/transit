$(document).ready(function() {
  BusTracker.initialize();
  BusTracker.setDirections();
  BusTracker.setStops();
});

BusTracker = {
  initialize: function() {
    BusTracker.populateSelectTag('#direction', null, 'Select One');
    BusTracker.disableSelectTag("#direction");
    BusTracker.populateSelectTag('#stop', null, 'Select One');
    BusTracker.disableSelectTag("#stop");
  },
  setDirections: function() {
    $('#route_number').change(function(){
      var route_number = $('#route_number').val();
      if (route_number) {
        BusTracker.getDirections(route_number);
      } else {
        BusTracker.initialize();
        BusTracker.clearSelectTagFor("#direction");
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
  showDiv: function(divId) {
    $(divId).show();
  },
  clearSelectTagFor: function(select_tag) {
    $(select_tag).html("");
  },
  populateSelectTag: function(selectTag, value, text){
    $(selectTag).append(
      $(document.createElement("option")).val(value).text(text)
    );
  },
  disableSelectTag: function(divId) {
    $(divId).attr('disabled', false);
  },
  setStops: function() {
    $('#direction').change(function(){
      var direction = $('#direction').val();
      var route_number = $('#route_number').val();

      if (direction) {
        BusTracker.getStops(route_number, direction);
      } else {
        BusTracker.initialize();
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
      BusTracker.displayPredictions();
    });
  },
  displayPredictions: function() {
    var route_number = $('#route_number').val();
    var stop_id = $('#stop').val();

    if (route_number && stop_id) {
      $('.output').show();
      var url = "bus_tracker/route/" + route_number + "/stop_id/" + stop_id + "/get_predictions";
      $('.output > a').attr("href", url)
    }
  },
};
