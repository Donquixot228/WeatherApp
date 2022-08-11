import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/repositories/local_database/local_store.dart';

import '../../models/last_search_model.dart';
import '../../repositories/local_database/db_last_search.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final LocalSettingRepository _localSettingRepository;
  final MastersDatabaseProvider _mastersDatabaseProvider;

  WeatherBloc({
    required LocalSettingRepository localSettingRepository,
    required MastersDatabaseProvider mastersDatabaseProvider,
  })  : _localSettingRepository = localSettingRepository,
        _mastersDatabaseProvider = mastersDatabaseProvider,
        super(WeatherState.initial()) {
    on<ChangeTheme>((event, emit) {
      emit(state.copyWith(isDark: !state.isDark));
    });
    on<ChangeCitySize>((event, emit) {
      emit(state.copyWith(citySize: event.size));
    });
    on<ChangeSearchQuery>((event, emit) async {
      emit(state.copyWith(searchQuery: event.searchQuery));
    });
    on<GetForecast>((event, emit) async {
      String forecast = await _localSettingRepository.readCurrentWeather();
      String citySize = await _localSettingRepository.readCitySize();
      String cityName = await _localSettingRepository.readCity();

      emit(state.copyWith(
        citySize: citySize,
        cityName: cityName,
        listHourly: json.decode(forecast)['hourly'],
        listDaily: json.decode(forecast)['daily'],
      ));
    });
    on<GetCurentWeather>((event, emit) async {
      emit(state.copyWith(status: WeatherStatus.loading));
      String currentWeather =
          await _localSettingRepository.readCurrentWeather();
      if (currentWeather != "Couldn't read file") {
        add(GetForecast());
        emit(state.copyWith(
            weatherModel: WeatherModel.fromJson(json.decode(currentWeather))));
      } else {
        Uri url = Uri.parse(
            "http://api.openweathermap.org/data/2.5/onecall?lat=${state.lat}&lon=${state.lon}&exclude=minutely&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru");
        var response =
            await http.get(url, headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          // If the server did return a 200 OK response, then parse the JSON.
          _localSettingRepository.saveCurrentWeather(response.body);

          List hourly = json.decode(response.body)['hourly'];
          List daily = json.decode(response.body)['daily'];
          emit(
            state.copyWith(
              listHourly: hourly,
              listDaily: daily,
              weatherModel: WeatherModel.fromJson(
                json.decode(response.body),
              ),
            ),
          );
        } else {
          // If the server did not return a 200 OK response, then throw an exception.
          throw Exception('Failed to load Current Weather');
        }
      }
      emit(state.copyWith(status: WeatherStatus.initial));
    });
    on<GetWeatherByCity>((event, emit) async {
      log(state.searchQuery);
      Uri url = Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?q=${state.searchQuery}&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru");
      var responseCity =
          await http.get(url, headers: {"Accept": "application/json"});
      if (responseCity.statusCode == 200) {
        log(responseCity.body);
        // If the server did return a 200 OK response, then parse the JSON.
        emit(state.copyWith(
          lon: json.decode(responseCity.body)['coord']['lon'],
          lat: json.decode(responseCity.body)['coord']['lat'],
        ));
        Uri url = Uri.parse(
            "http://api.openweathermap.org/data/2.5/onecall?lat=${state.lat}&lon=${state.lon}&exclude=minutely&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru");
        var response =
            await http.get(url, headers: {"Accept": "application/json"});
        Uri urlMonth1 = Uri.parse(
            'https://history.openweathermap.org/data/2.5/aggregated/month?month=1&${state.lat}&lon=${state.lon}&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru');
        var responseMonth1 =
            await http.get(urlMonth1, headers: {"Accept": "application/json"});
        log(json.decode(responseMonth1.body)['result']['temp']['median']);
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response, then parse the JSON.
          _localSettingRepository.saveCurrentWeather(response.body);
          _localSettingRepository.saveCitySize(state.citySize);
          _localSettingRepository
              .saveCity(json.decode(responseCity.body)['name']);
          List hourly = json.decode(response.body)['hourly'];
          List daily = json.decode(response.body)['daily'];
          emit(
            state.copyWith(
              cityName: json.decode(responseCity.body)['name'],
              listHourly: hourly,
              citySize: state.citySize,
              listDaily: daily,
              weatherModel: WeatherModel.fromJson(
                json.decode(response.body),
              ),
            ),
          );
        } else {
          // If the server did not return a 200 OK response, then throw an exception.
          throw Exception('Failed to load Current Weather');
        }
        // Add to history
        _mastersDatabaseProvider.addItemToDatabaseHistory(
          History(
            lat: state.lat,
            lon: state.lon,
            name: state.searchQuery,
            temp: json.decode(response.body)['main']['temp'].round().toString(),
            description: json.decode(response.body)['weather'][0]
                ['description'],
            icon: json.decode(response.body)['weather'][0]['icon'],
          ),
        );
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        throw Exception('Failed to load Current Weather');
      }
    });
    on<InitialSetting>((event, emit) async {
      // Проверяем нашу сохраненную тему
      String theme = await _localSettingRepository.readTheme();
      if (theme != "Couldn't read file") {
        if (theme == "dark") {
          emit(state.copyWith(isDark: true));
        } else {
          emit(state.copyWith(isDark: false));
        }
      } else {
        emit(state.copyWith(isDark: false));
        _localSettingRepository.saveTheme("light");
      }
      // Проверяем наш сохраненный город. Также можно будет поключить проверку геопозиции, чтобы не вручную проверять
      String city = await _localSettingRepository.readCity();
      String citySize = await _localSettingRepository.readCitySize();
      if (city != "Couldn't read file") {
        emit(state.copyWith(cityName: city));
        emit(
          state.copyWith(
              citySize:
                  citySize == "Couldn't read file" ? "Большой" : citySize),
        );
      } else {
        emit(state.copyWith(cityName: "Лондон, GB"));
        _localSettingRepository.saveCity("Лондон, GB");
        _localSettingRepository.saveCitySize("Большой");
      }
      add(GetCurentWeather());
    });
  }
}
