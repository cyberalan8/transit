$(document).ready(function() {
  BusTracker.initialize();
  BusTracker.setDirections();
  BusTracker.setStops();
  BusTracker.predictionWatcher();
});

BusTracker = {
  initialize: function() {
    BusTracker.populateSelectTag('#direction', null, 'Select One');
    BusTracker.populateSelectTag('#stop', null, 'Select One');
    BusTracker.disablePredictionLink();
  },
  setDirections: function() {
    $('#route_number').change(function(){
      var route_number = $('#route_number').val();
      if (route_number) {
        BusTracker.getDirections(route_number);
      } else {
        BusTracker.resetDropdown('#direction');
      }
      BusTracker.resetDropdown('#stop');
      BusTracker.disablePredictionLink();
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
        BusTracker.resetDropdown('#direction');
        $.each(directions, function(index, option){
          BusTracker.populateSelectTag('#direction', option, option);
        });
      }
    });
  },
  setStops: function() {
    $('#direction').change(function(){
      var direction = $('#direction').val();
      var route_number = $('#route_number').val();

      if (direction) {
        BusTracker.getStops(route_number, direction);
      } else {
        BusTracker.resetDropdown('#stop');
      }
      BusTracker.disablePredictionLink();
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
  },
  predictionWatcher: function() {
    $('#stop').change(function(){
      var stop = $('#stop').val();
      if (stop) {
        BusTracker.generatePredictionLink();
      } else {
        BusTracker.disablePredictionLink();
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
  generatePredictionLink: function() {
    var route_number = $('#route_number').val();
    var stop_id = $('#stop').val();

    if (route_number && stop_id) {
      var url = "bus_tracker/route/" + route_number + "/stop_id/" + stop_id + "/get_predictions";
      $('#find_my_bus').attr("href", url);
      BusTracker.enablePredictionLink();
    }
  },
  resetDropdown: function(selector) {
    BusTracker.clearSelectTagFor(selector);
    BusTracker.populateSelectTag(selector, null, 'Select One');
  },
  enablePredictionLink: function() {
    $('#find_my_bus').removeClass('disabled');
  },
  disablePredictionLink: function() {
    $('#find_my_bus').removeAttr("href");
    $('#find_my_bus').addClass('disabled');
  }
};
