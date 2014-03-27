var map;
var lat = 0;
var lon = 0;
function init() {
	// The overlay layer for our marker, with a simple diamond as symbol
	var overlay = new OpenLayers.Layer.Vector('Overlay', {
		styleMap: new OpenLayers.StyleMap({
			externalGraphic: '/img/marker.png',
			graphicWidth: 20, graphicHeight: 24, graphicYOffset: -24,
			title: '${tooltip}'
		})
	});

	// The location of our marker and popup. We usually think in geographic
	// coordinates ('EPSG:4326'), but the map is projected ('EPSG:3857').
	// OpenLayers.Geometry.Point(lon,lat)
	var myLocation = new OpenLayers.Geometry.Point(lon,lat)
		.transform('EPSG:4326', 'EPSG:3857');

	// We add the marker with a tooltip text to the overlay
	overlay.addFeatures([
		new OpenLayers.Feature.Vector(myLocation, {tooltip: 'OpenLayers'})
	]);


	// Finally we create the map
	map = new OpenLayers.Map({
		div: "map", projection: "EPSG:3857",
		layers: [new OpenLayers.Layer.OSM(), overlay],
		center: myLocation.getBounds().getCenterLonLat(), zoom: 16
	});
}
