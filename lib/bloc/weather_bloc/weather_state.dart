part of 'weather_bloc.dart';

enum WeatherStatus {
  loading,
  error,
  initial,
}

class WeatherState {
  final bool isDark;
  final String errorMessage;
  final String cityName;
  final double lon;
  final String searchQuery;
  final double lat;
  final List listHourly;
  final List listDaily;
  final WeatherStatus status;
  final WeatherModel weatherModel;

  WeatherState({
    required this.isDark,
    required this.searchQuery,
    required this.cityName,
    required this.lon,
    required this.errorMessage,
    required this.lat,
    required this.listDaily,
    required this.listHourly,
    required this.status,
    required this.weatherModel,
  });

  factory WeatherState.initial() {
    return WeatherState(
      isDark: false,
      errorMessage: '',
      searchQuery: '',
      cityName: 'Лондон, GB',
      lat: 51.51,
      lon: -0.13,
      listDaily: [],
      listHourly: [],
      weatherModel: WeatherModel.empty,
      status: WeatherStatus.initial,
    );
  }

  WeatherState copyWith({
    bool? isDark,
    String? cityName,
    double? lon,
    double? lat,
    String? searchQuery,
    List? listDaily,
    List? listHourly,
    String? errorMessage,
    WeatherModel? weatherModel,
    WeatherStatus? status,
  }) {
    return WeatherState(
      isDark: isDark ?? this.isDark,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      weatherModel: weatherModel ?? this.weatherModel,
      cityName: cityName ?? this.cityName,
      lon: lon ?? this.lon,
      lat: lat ?? this.lat,
      listHourly: listHourly ?? this.listHourly,
      listDaily: listDaily ?? this.listDaily,
    );
  }
}
