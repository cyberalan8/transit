$(document).ready(function() {
  BusTracker.setDirections();
  BusTracker.setStops();

  setInterval(BusTracker.displayPredictions, 30000);
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
        BusTracker.hideDiv('.output');
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
        BusTracker.hideDiv('.output');
        BusTracker.hideDiv('.stops');
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
        $('.output').html('');
        BusTracker.getStops(route_number, direction);
        BusTracker.showDiv('.stops');
      } else {
        BusTracker.hideDiv('.output');
        BusTracker.hideDiv('.stops');
        BusTracker.clearSelectTagFor('#stop');
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
      $('.output').html('');
      BusTracker.showDiv('.output');
      $('.output').append(
        $(document.createElement("h2")).text("- - - CTA Bus Status - - -")
      );
      BusTracker.getPredictions(route_number, stop_id);
    }
  },
  getPredictions: function(route_number, stop_id){
    if (route_number && stop_id) {
      var url = "bus_tracker/route/" + route_number + "/stop_id/" + stop_id + "/get_predictions";

      $.ajax({
        type: 'GET',
        url: url,
        dataType: "json",
        success: function(data) {
          if ( data[0] ) {
            $.each(data, function(index, option){
              var timeRemaining = BusTracker.timeUntilArrival(option.predicted_time);

              var prediction = {route: route_number, destination: option.destination,
                vehicle_id: option.vehicle_id,
                time_remaining: timeRemaining};

               var template = BusTracker.getTemplate(timeRemaining);
               var html = Mustache.to_html(template, prediction);

               BusTracker.showDiv('.output')
               $('.output').append(html);
            });
          } else {
            $('.output').html('');
            $('.output').append("<h3>Sorry, no bus are coming... </h3>");
          }
        }
      });
    }
  },
  getTemplate: function(time){
    var template = '';
    if ( time > 1 ) {
      template = "<h3>#{{route}} to {{destination}}<br>{{time_remaining}} Minutes away<br>Bus #{{vehicle_id}}</h3>";
    } else if ( time > 0 ){
      template = "<h3>#{{route}} to {{destination}} is Due<br>Bus #{{vehicle_id}}</h3>";
    }
    return template += "<h2>- - - - - - - - - - - - - - - - - - -</h2>";
  },
  timeUntilArrival: function(time) {
    var url = "bus_tracker/time_until_arrival/" + time;

    var timeUntilArrival = $.ajax({
      type: 'GET',
      url: url,
      async: false
    }).responseText;

    return timeUntilArrival;
  }
};
