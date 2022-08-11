part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class ChangeTheme extends WeatherEvent {}

class InitialSetting extends WeatherEvent {}

class GetForecast extends WeatherEvent {}

class GetCurentWeather extends WeatherEvent {}

class GetWeatherByCity extends WeatherEvent {}
class ChangeCitySize extends WeatherEvent {
  String size;
  ChangeCitySize(this.size);
}
class ChangeSearchQuery extends WeatherEvent {
  String searchQuery;

  ChangeSearchQuery(this.searchQuery);
}
