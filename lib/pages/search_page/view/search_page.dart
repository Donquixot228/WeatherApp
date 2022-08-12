import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather/bloc/weather_bloc/weather_bloc.dart';
import 'package:weather/resources/app_colors.dart';
import 'package:weather/service/locator.dart';
import 'package:weather/utils/popular_cities.dart';
import '../../../service/navigation_service.dart';
import '../widgets/popular_city.dart';
import '../widgets/search_field.dart';

class SearchPage extends StatelessWidget {
  static const String routeName = '/searchPage';

  static Widget create() {
    return SearchPage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.loading) {
         // FlushbarHelper.createInformation(message: 'Загружаем погоду').show(context);
          context.loaderOverlay.show();
        }
        if (state.status == WeatherStatus.error) {
          FlushbarHelper.createError(message: state.errorMessage).show(context);
        }
        else {
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
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: state.isDark != true
                    ? AppColors.cl_background
                    : AppColors.cd_background,
                body: Stack(
                  children: [
                    ListView(
                      children: [
                        SizedBox(height: 120),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 45,
                          ),
                          width: 100,
                          height: 58,
                          decoration: BoxDecoration(
                            color: state.isDark != true
                                ? AppColors.cl_background
                                : AppColors.cd_background,
                            borderRadius: BorderRadius.all(Radius.circular(95)),
                            boxShadow: [
                              setBoxShadowDark(state.isDark),
                              setBoxShadowLight(state.isDark),
                            ],
                          ),
                          child: BuildSearchField(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 5),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child:  TabBar(
                              isScrollable: true,
                              indicator: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: AppColors.redButton,
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: state.isDark != true
                                  ? AppColors.darkTextColor
                                  : AppColors.white,
                              indicatorColor: Colors.white,
                              physics: BouncingScrollPhysics(),
                              tabs: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Большие города',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Средние города',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Малые города',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        state.searchQuery.isEmpty
                            ? Container(
                                width: double.maxFinite,
                                height: MediaQuery.of(context).size.height*0.75,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TabBarView(
                                    children: [
                                      BuildPopularCity('Большие'),
                                      BuildPopularCity('Средние'),
                                      BuildPopularCity('Малые'),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        //_buildLastSearch(),
                      ],
                    ),
                    Container(
                      color: state.isDark != true
                          ? AppColors.cl_background
                          : AppColors.cd_background,
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                locator<NavigationService>().goBack();
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      setBoxShadowDark(state.isDark),
                                      setBoxShadowLight(state.isDark),
                                    ]),
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Поиск",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: state.isDark != true
                                        ? AppColors.cd_background
                                        : AppColors.cl_background,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                context.read<WeatherBloc>().add(ChangeTheme());
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    setBoxShadowDark(state.isDark),
                                    setBoxShadowLight(state.isDark),
                                  ],
                                ),
                                child: Icon(
                                  state.isDark != true
                                      ? Icons.brightness_3
                                      : Icons.brightness_7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
