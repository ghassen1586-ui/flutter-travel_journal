class Destination {
  const Destination({
    required this.name,
    required this.tagline,
    required this.lat,
    required this.lng,
  });

  final String name;
  final String tagline;
  final double lat;
  final double lng;
}

const destinations = [
  Destination(name: 'Djerba', tagline: 'Island & beaches', lat: 33.88, lng: 10.86),
  Destination(name: 'Tozeur', tagline: 'Desert oasis', lat: 33.92, lng: 8.13),
  Destination(name: 'Sousse', tagline: 'Medina & coast', lat: 35.83, lng: 10.64),
  Destination(name: 'Tabarka', tagline: 'Coral coast & forests', lat: 36.95, lng: 8.76),
  Destination(name: 'Kairouan', tagline: 'The Great Mosque', lat: 35.68, lng: 10.10),
];