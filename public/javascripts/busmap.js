var pictureSource;   // picture source for iPhone
var useragent; // string determining what our user agent is  
var media;
var currentMapDiv;
var currentBus = {};
var map;

function getFleet() {
  $.mobile.pageLoading();
  $.ajax({
   url: fleetUrl,
   dataType: 'jsonp',
   success: function(data) {
     $.mobile.pageLoading(true);
     var tmpl = $('#listTemplate').text();
     data = data['assetlist'];
     $('#fleetList').html(Mustache.to_html(tmpl, data)).listview('refresh');
   }
 });
}

function showUser() {
  if (navigator.geolocation) {
    var timeoutVal = 10 * 1000 * 1000;
    navigator.geolocation.getCurrentPosition(showPositionOnMap, errorMessage,{ enableHighAccuracy: true, timeout: timeoutVal, maximumAge: 0});
  }
  else {
    console.log("Geolocation is not supported by this browser");
  }

}

function showPositionOnMap(position) {
  var userPoint = new GeoJSON({
    type: "Point",
    coordinates: [position.coords.longitude, position.coords.latitude]
  }, {
    icon: "/images/user-location.png"
  });
  userPoint.setMap(map);
}

function showBusOnMap(feature) {
  currentBus.feature = feature;
  
  var busStyle = {
    icon: "/images/point.png",
    shadow: "/images/shadow.png"
  };

  if (currentBus.gPoint) currentBus.gPoint.setMap(null);
  currentBus.gPoint = new GeoJSON(feature, busStyle);
  currentBus.gPoint.setMap(map);    
        
  google.maps.event.addListener(currentBus.gPoint, 'click', function() {
    var url = "/busses/" + feature.properties.fleet;
    $('.ui-content', currentMapDiv).append('<a class="dialog" href="' + url + '?details=true" data-rel="dialog" data-transition="flip"></a>');
    $('.dialog').click().remove();
  });
  
  showPath(currentBus.feature.properties.fleet, function(path) {
	  if (path.coordinates) {
  	  if (currentBus.path) currentBus.path.setMap(null);
  	  currentBus.path = new GeoJSON(path);
  	  currentBus.path.setMap(map);
    }
  });
}

function errorMessage(error) {
  var errors = { 
    1: 'Permission denied',
    2: 'Position unavailable',
    3: 'Request timeout'
  };
  console.log("Error: " + errors[error.code]);
}

function showPath(bus, callback) {
  $.getJSON('/busses/' + bus + '/path.json', function(path) {
    callback(path);
  })
}

function showMap(feature, div) {
  currentMapDiv = div;
  var mapDiv = $(div).find('#map_canvas')[0];
  var firstPoint = feature.geometry.coordinates;
  var latlng = new google.maps.LatLng(firstPoint[1], firstPoint[0]);
  var address;        
  var myOptions = {
    center: latlng,
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(mapDiv, myOptions);
  
  showBusOnMap(feature);
};