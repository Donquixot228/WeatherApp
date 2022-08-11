import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//FixME Используется для сохранения настроек пользователя. НО я предпочитаю использовать SharedPreferences или же SecureStorage для сохранения непосредственно важных данных
class LocalSettingRepository {

  Future<String> readCurrentWeather() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/current_weather.txt');
      String currentWeather = await file.readAsString();
      log("Read current weather from file \n$currentWeather");
      return currentWeather;
    } catch (e) {
      log("Couldn't read current weather from file");
      return "Couldn't read file";
    }
  }

  saveCurrentWeather(String currentWeather) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/current_weather.txt');
    await file.writeAsString(currentWeather);
    log('Saved current weather\n$currentWeather');
  }

  Future<String> readTheme() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/theme.txt');
      String currentTheme = await file.readAsString();
      log("Set theme \"$currentTheme\". Read theme from file");
      return currentTheme;
    } catch (e) {
      log("Couldn't read theme from file");
      return "Couldn't read file";
    }
  }

  saveTheme(String currentTheme) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/theme.txt');
    await file.writeAsString(currentTheme);
    log('Saved theme \"$currentTheme\".');
  }
  saveCitySize(String citySize) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/citySize.txt');
    await file.writeAsString(citySize);
    log('Saved theme \"$citySize\".');
  }
  Future<String> readCitySize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/citySize.txt');
      String citySize = await file.readAsString();
      log("Current city is: \"$citySize\". Read citySize from file");
      return citySize;
    } catch (e) {
      log("Couldn't read city from file");
      return "Couldn't read file";
    }
  }
  Future<String> readCity() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/city.txt');
      String currentCity = await file.readAsString();
      log("Current city is: \"$currentCity\". Read theme from file");
      return currentCity;
    } catch (e) {
      log("Couldn't read city from file");
      return "Couldn't read file";
    }
  }

  saveCity(String currentCity) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/city.txt');
    await file.writeAsString(currentCity);
    log('Saved city: \"$currentCity\".');
  }
}