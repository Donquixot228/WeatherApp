part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class ChangeTheme extends WeatherEvent {
  bool isDark;

  ChangeTheme(this.isDark);
}

class InitialSetting extends WeatherEvent {}
class GetForecast extends WeatherEvent {}
class GetCurentWeather extends WeatherEvent{}
class GetWeatherByCity extends WeatherEvent{}
class ChangeSearchQuery extends WeatherEvent{
  String searchQuery;
  ChangeSearchQuery(this.searchQuery);
}
