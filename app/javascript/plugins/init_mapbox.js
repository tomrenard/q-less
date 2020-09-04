import mapboxgl from 'mapbox-gl';
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';

const buildMap = (mapElement) => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/dark-v10'
  });
};

const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => {
    const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);
    new mapboxgl.Marker()
      .setLngLat([ marker.lng, marker.lat ])
      .setPopup(popup)
      .addTo(map);
  });
};

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 30, offset: [0,-80] }); //decentrer with half screen puis recentrer when fullscreen
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  if (mapElement) {
    const map = buildMap(mapElement);
    const markers = JSON.parse(mapElement.dataset.markers);
    addMarkersToMap(map, markers);
    fitMapToMarkers(map, markers);
    map.addControl(
      new mapboxgl.GeolocateControl({
        positionOptions: {
        enableHighAccuracy: true
        },
        trackUserLocation: true
      })
    )
    const direction = new MapboxDirections({
        accessToken: mapboxgl.accessToken
      })

    const btnDirection = document.querySelector('#itinary');

    btnDirection.addEventListener('click', (event) => {
      if (btnDirection.dataset.direction === "absent") {
        btnDirection.dataset.direction = "present"
        map.addControl(
          direction,
          'top-left'
        )
      } else {
        btnDirection.dataset.direction = "absent"
        map.removeControl(direction)
      }
    })

  }
};

export { initMapbox };
