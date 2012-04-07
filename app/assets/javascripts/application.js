// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

function initialize() {
  el = $('#map-canvas')
  if (!el.length)
    return;

  myOptions = {
    center: new google.maps.LatLng(0, 0),
    zoom: 7,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById("map-canvas"),
      myOptions);

  points = el.data('map');

  markers = new Array();
  contents = new Array();
  infowindows = new Array();

  for (i = 0; i < points.length; i++)
  {
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(points[i][0], points[i][1]),
      map: map,
    });

    content = 'points : ' + points[i][2];
    infowindow = new google.maps.InfoWindow({
        content: content
    });
    
    contents.push(content);
    markers.push(marker);
    infowindows.push(infowindow);
  }

  for (i = 0; i < markers.length; i++)
  {
    var anonfunc = (function(newi) {
        return function(e) {
        infowindows[newi].open(map,markers[newi]);
        }
    })(i)
    google.maps.event.addListener(markers[i], 'click', anonfunc);
  }
}

$(document).ready(initialize())