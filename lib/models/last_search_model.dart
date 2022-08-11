class History {
  final int id;
  final double lat;
  final double lon;

  final String name;
  final String temp;
  final String description;
  final String icon;

  History({
    this.id=0,
    required this.lat,
    required this.lon,
    required  this.name,
    required this.temp,
    required this.description,
    required this.icon,
  });

  History.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        lat = map['lat'],
        lon = map['lon'],
        name = map['name'],
        temp = map['temp'],
        description = map['description'],
        icon = map['icon'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'lat': lat,
        'lon': lon,
        'name': name,
        'temp': temp,
        'description': description,
        'icon': icon,
      };
}
