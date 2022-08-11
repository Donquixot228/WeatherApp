class WeatherModel {
  final int dt;
  final int sunrise;
  final int sunset;
  final double temp;
  final double feelsLike;
  final String pressure;
  final String humidity;
  final String windSpeed;
  final int windDeg;
  final String description;
  final String icon;

  WeatherModel({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.description,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      dt: json['current']['dt'] * 1000,
      sunrise: json['current']['sunrise'] * 1000,
      sunset: json['current']['sunset'] * 1000,
      temp: json['current']['temp'].toDouble(),
      feelsLike: json['current']['feels_like'].toDouble(),
      pressure: json['current']['pressure'].toString(),
      humidity: json['current']['humidity'].toString(),
      windSpeed: json['current']['wind_speed'].toString(),
      windDeg: json['current']['wind_deg'],
      description: json['current']['weather'][0]['description'],
      icon: json['current']['weather'][0]['icon'],
    );
  }

  static WeatherModel empty = WeatherModel(
    dt: 1000,
    sunrise: 1000,
    sunset: 1000,
    temp: 20.0,
    feelsLike: 20.0,
    pressure: 'Good',
    humidity: 'Good',
    windSpeed: '12',
    windDeg: 12,
    description: 'Good',
    icon: '20.0',
  );
}
