import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather/bloc/weather_bloc/weather_bloc.dart';
import 'package:weather/resources/app_colors.dart';

class DetailView extends StatelessWidget {
  final bool darkMode;
  final int windDeg;
  final String windSpeed;
  final double feelsLike;
  final String humidity;
  final String pressure;
  final List listHourly;
  final List listDaily;

  DetailView({
    required this.darkMode,
    required this.windDeg,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.listHourly,
    required this.listDaily,
  });

  DateTime _parseTime(listForecast) {
    return DateTime.fromMillisecondsSinceEpoch(listForecast['dt'] * 1000);
  }

  double _parseTemperature(listForecast) {
    return listForecast['temp'].toDouble();
  }

  @override
  Widget build(BuildContext context) {
    Widget _itemForecast(dynamic item) {
      DateFormat dateFormat = DateFormat('EEEE');
      int _temperatureDay = item['temp']['day'].round();
      int _temperatureNight = item['temp']['night'].round();
      String icon = item['weather'][0]['icon'];

      return Container(
        width: 135,
        margin: const EdgeInsets.fromLTRB(5, 8, 20, 8),
        child: Row(
          children: [
            Image.asset(
              darkMode != true
                  ? "assets/weather/${icon.substring(0, icon.length - 1)}n.png"
                  : "assets/weather/${icon.substring(0, icon.length - 1)}d.png",
              width: 50,
              height: 50,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(
                      DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
                    ),
                    style: TextStyle(
                      color: darkMode != true
                          ? AppColors.tl_primary
                          : AppColors.td_primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    item['weather'][0]['description'],
                    style: TextStyle(
                      color: darkMode != true
                          ? AppColors.tl_primary
                          : AppColors.td_primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "$_temperatureDay° / $_temperatureNight°",
              style: TextStyle(
                color: darkMode != true
                    ? AppColors.tl_primary
                    : AppColors.td_primary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildForecast() {
      return BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Прогноз на неделю',
                  style: TextStyle(
                    color: darkMode != true
                        ? AppColors.tl_primary
                        : AppColors.td_primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Container(
                height: 540,
                margin: const EdgeInsets.fromLTRB(16, 25, 16, 45),
                decoration: BoxDecoration(
                    color: darkMode != true
                        ? AppColors.cl_background
                        : AppColors.cd_background,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      setBoxShadowDark(darkMode),
                      setBoxShadowLight(darkMode),
                    ]),
                child: Center(
                  child: state.listDaily.isNotEmpty
                      ? ListView.builder(
                    itemCount: 8,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _itemForecast(listDaily[index]);
                    },
                  )
                      : CircularProgressIndicator(),
                ),
              ),
            ],
          );
        },
      );
    }

    Widget _detailItem(String title, String subtitle, String icon) {
      return Expanded(
        child: Container(
          height: 100,
          margin: const EdgeInsets.fromLTRB(16, 25, 16, 0),
          padding: EdgeInsets.fromLTRB(16, 5, 16, 5),
          decoration: BoxDecoration(
              color: darkMode != true
                  ? AppColors.cl_background
                  : AppColors.cd_background,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                setBoxShadowDark(darkMode),
                setBoxShadowLight(darkMode),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title",
                    style: TextStyle(
                      color: darkMode != true
                          ? AppColors.tl_primary
                          : AppColors.td_primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "$subtitle",
                    style: TextStyle(
                      color: darkMode != true
                          ? AppColors.tl_primary
                          : AppColors.td_primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Image.asset(
                darkMode != true
                    ? "assets/details/d_$icon.png"
                    : "assets/details/l_$icon.png",
                width: 22,
                height: 22,
              ),
            ],
          ),
        ),
      );
    }

    String _setDirection() {
      if (windDeg == 0) return 'Север';
      if (windDeg == 90) return 'Восток';
      if (windDeg == 180) return 'Юг';
      if (windDeg == 270) return 'Запад';

      if (windDeg > 0 && windDeg < 90) return 'Северо-восток';
      if (windDeg > 90 && windDeg < 180) return 'Юго-восток';
      if (windDeg > 180 && windDeg < 270) return 'Юго-запад';
      if (windDeg > 270 && windDeg < 360) return 'Северо-запад';
      return 'Неизвестно';
    }

    Widget _buildDetails() {
      return BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Детали',
                  style: TextStyle(
                    color: darkMode != true
                        ? AppColors.tl_primary
                        : AppColors.td_primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Row(
                children: [
                  _detailItem("Категория Города", "${state.citySize}", "wind"),
                ],
              ),
              Row(
                children: [
                  _detailItem(_setDirection(), "${windSpeed} км/ч", "wind"),
                  _detailItem("Ощущается", "${feelsLike.round()}°",
                      "temperature"),
                ],
              ),
              Row(
                children: [
                  _detailItem("Влажность", "${humidity} %", "humidity"),
                  _detailItem("Давление", "${pressure} hPa", "pressure"),
                ],
              ),
              SizedBox(height: 20),
            ],
          );
        },
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildForecast(),
        _buildDetails(),
      ],
    );
  }
}
