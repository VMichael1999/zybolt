/// Estilo de Google Maps en tonos beige y arena, como el mapa del prototipo.
const String kTrackMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#EFE9D7"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#6C6252"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#EFE9D7"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"visibility":"off"}]},
  {"featureType":"poi","stylers":[{"visibility":"off"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"visibility":"on"},{"color":"#E3E6C9"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#E7BCA4"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#D7A68C"}]},
  {"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#E6D6BE"}]},
  {"featureType":"road.local","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#D9E3E0"}]}
]
''';
