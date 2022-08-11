import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather/bloc/weather_bloc/weather_bloc.dart';
import 'package:weather/pages/home_page/view/detail_view.dart';
import 'package:weather/pages/home_page/widgets/current_weather_widget.dart';
import 'package:weather/pages/search_page/view/search_page.dart';
import 'package:weather/resources/app_colors.dart';

import '../../models/weather_model.dart';
import '../../service/locator.dart';
import '../../service/navigation_service.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  static Widget create() {
    return HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.loading) {
          context.loaderOverlay.show();
        }
        if (state.status == WeatherStatus.error) {
          FlushbarHelper.createError(message: state.errorMessage).show(context);
          // if (state.loginStatus == LoginStatus.success) {
          //   Navigator.of(context).push(
          //     MainControllerPage.route(),
          //   );
          //   FlushbarHelper.createSuccess(
          //       message:'Welcome to the community'
          //   ).show(context);(context);
        } else {
          context.loaderOverlay.hide();
        }
      },
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return LoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: Center(
              child: SpinKitDoubleBounce(
                color: state.isDark != true
                    ? AppColors.cd_background
                    : AppColors.cl_background,
                size: 50.0,
              ),
            ),
            overlayOpacity: 0.5,
            child: Scaffold(
              backgroundColor: state.isDark != true
                  ? AppColors.cl_background
                  : AppColors.cd_background,
              body: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: state.isDark != true
                        ? AppColors.cl_background
                        : AppColors.cd_background,
                    expandedHeight: MediaQuery.of(context).size.height * 0.75,
                    floating: false,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 100),
                              Expanded(
                                child: CurrentWeather(),
                              ),
                            ],
                          ),
                          Container(
                            color: state.isDark != true
                                ? AppColors.cl_background
                                : AppColors.cd_background,
                            child: SafeArea(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      context.read<WeatherBloc>().emit(
                                          state.copyWith(searchQuery: ''));
                                      locator<NavigationService>()
                                          .navigateTo(SearchPage.routeName);

                                      // await Navigator.push(
                                      //   context,
                                      //   FadeRoute(
                                      //     page: SearchScreen(darkMode: _darkMode),
                                      //   ),
                                      // );
                                      // _getForecast();
                                      // _setCity();
                                      //_setTheme();
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: state.isDark != true
                                            ? AppColors.cl_background
                                            : AppColors.cd_background,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        boxShadow: [
                                          setBoxShadowDark(state.isDark),
                                          setBoxShadowLight(state.isDark),
                                        ],
                                      ),
                                      child: Icon(Icons.menu),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      state.cityName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: state.isDark != true
                                              ? AppColors.tl_primary
                                              : AppColors.td_primary,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  SizedBox(width: 82, height: 82),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        DetailView(
                          darkMode: state.isDark,
                          windDeg: state.weatherModel.windDeg,
                          windSpeed: state.weatherModel.windSpeed,
                          feelsLike: state.weatherModel.feelsLike,
                          humidity: state.weatherModel.humidity,
                          pressure: state.weatherModel.pressure,
                          listHourly: state.listHourly,
                          listDaily: state.listDaily,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
