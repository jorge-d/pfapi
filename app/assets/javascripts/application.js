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
  points = el.data('map');

  var tmp = 0;
  var latitude = -999;
  var longitude = -999;
  for (var i = 0; i < points.length; i++)
    if (points[i][2] > tmp)
    {
      latitude = points[i][1];
      longitude = points[i][2];
      tmp = points[i][3];
    }

  myOptions = {
    center: new google.maps.LatLng(latitude, longitude),
    zoom: 9,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById("map-canvas"),
      myOptions);


  markers = new Array();
  contents = new Array();
  infowindows = new Array();

  for (i = 0; i < points.length; i++)
  {
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(points[i][1], points[i][2]),
      map: map,
    });

    content = "<div class='informations'><h3 style='text-align: center;'><a href='" + window.location.origin + "/zones/" + points[i][0] +
              "' /> Zone #" + points[i][0] + " (" + points[i][1] + ", " + points[i][1] + ")</a></h3>" +
              "<p><ul style='font-style: italic'>";
    if (points[i].length > 4)
    {
      user = points[i][4];
      game = points[i][5];
      content += '<li>Best score is ' + points[i][3];
      content += '<li>The author of this score is <a href=' + window.location.origin + '/users/' + user[0] + '>' + user[1] + '</a>';
      content += '<li>The game in which it has done is <a href=' + window.location.origin + '/games/' + game[0] + '>' + game[1] + '</a>';
    }
    else
    {
      content += '<li>No body has scored yet in this zone';
      content += '<li>Subscribe and play a game that uses our API';
    }
    content += "</ul></p></div>";

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