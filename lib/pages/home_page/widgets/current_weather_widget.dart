import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/weather_bloc/weather_bloc.dart';
import '../../../resources/app_colors.dart';

class CurrentWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 250,
                height: 250,
                child: FlareActor(
                  "assets/flare/weather_icons.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation:
                      "${state.weatherModel.icon.substring(0, state.weatherModel.icon.length - 1)}d",
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${state.weatherModel.temp.round()}°",
                  style: TextStyle(
                      color: state.isDark != true
                          ? AppColors.tl_primary
                          : AppColors.td_primary,
                      fontSize: 80,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "${state.weatherModel.description}",
                  style: TextStyle(
                      color: state.isDark != true
                          ? AppColors.tl_primary
                          : AppColors.td_primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 40),

              ],
            ),
          ],
        );
      },
    );
  }
}
