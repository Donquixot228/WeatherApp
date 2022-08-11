import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/service/locator.dart';
import 'package:weather/service/navigation_service.dart';

import '../../../bloc/weather_bloc/weather_bloc.dart';
import '../../../resources/app_colors.dart';
import '../../../utils/popular_cities.dart';

class BuildPopularCity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        List<Widget> buildListCities() {
          List<Widget> choices = [];
          cities.forEach((city) {
            choices.add(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ActionChip(
                  backgroundColor:
                  state.isDark != true
                      ? AppColors.cl_background
                      : AppColors.cd_background,
                  elevation: 0,
                  pressElevation: 0,
                  label: Text(
                    city,
                    style: TextStyle(

                      color: state.isDark != true
                          ? AppColors.tl_primary
                          : AppColors.td_primary,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  onPressed: () {
                    context.read<WeatherBloc>().add(ChangeSearchQuery(city));
                    context.read<WeatherBloc>().add(GetWeatherByCity());
                    log(state.searchQuery);
                    locator<NavigationService>().goBack();
                  },
                ),
              ),
            );
          });
          return choices;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Популярные города',
                style: TextStyle(
                  color: state.isDark != true
                      ? AppColors.tl_primary
                      : AppColors.td_primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              height: 310,
              margin: const EdgeInsets.fromLTRB(16, 25, 16, 45),
              decoration: BoxDecoration(
                color: state.isDark != true
                    ? AppColors.cl_background
                    : AppColors.cd_background,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  setBoxShadowDark(state.isDark),
                  setBoxShadowLight(state.isDark),
                ],
              ),
              child: Center(child: Wrap(children: buildListCities())),
            ),
          ],
        );
      },
    );
  }
}