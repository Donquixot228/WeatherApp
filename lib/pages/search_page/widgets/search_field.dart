
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/service/locator.dart';
import 'package:weather/service/navigation_service.dart';

import '../../../bloc/weather_bloc/weather_bloc.dart';
import '../../../resources/app_colors.dart';

class BuildSearchField extends StatelessWidget {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(45.0)),
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return TextFormField(
          style: TextStyle(
            color: state.isDark != true
                ? AppColors.cd_background
                : AppColors.cl_background,
          ),
          decoration: InputDecoration(
            suffix: SizedBox(width: 20),
            focusedBorder: border,
            border: border,
            prefixIcon: Icon(
              Icons.search,
              color: state.isDark != true
                  ? AppColors.cd_background
                  : AppColors.cl_background,
            ),
            filled: true,
            hintText: 'Например: Италия',
            hintStyle: TextStyle(
                color: state.isDark != true
                    ? AppColors.cd_background
                    : AppColors.cl_background,
                fontWeight: FontWeight.w300),
          ),
          onChanged: (String value) {
            context.read<WeatherBloc>().add(ChangeSearchQuery(value));
          },
          onEditingComplete: (){
            context.read<WeatherBloc>().add(GetWeatherByCity());
             locator<NavigationService>().goBack();

          },
        );
      },
    );
  }
}
