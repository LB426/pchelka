$(document).ready(function(){

  $( "#add_point" ).click(function(){
	point_counter = point_counter + 1 ;
	var bp = 
	  '<p>' +
	  'lon: <input type="text" name="points[' + point_counter + '][lon]" value="" />&nbsp' +
	  'lat: <input type="text" name="points[' + point_counter + '][lat]" value="" />' +
	  '</p>' ;
	$("#points").append(bp);
	return false;
  });

})
