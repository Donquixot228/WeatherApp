import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/pages/pages.dart';
import 'package:weather/repositories/local_database/db_last_search.dart';
import 'package:weather/repositories/local_database/local_store.dart';
import 'package:weather/routes/app_router.dart';
import 'package:weather/service/locator.dart';
import 'package:weather/service/navigation_service.dart';

import 'bloc/weather_bloc/weather_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => LocalSettingRepository(),
        ),
        RepositoryProvider(
          create: (context) => MastersDatabaseProvider(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WeatherBloc(
              localSettingRepository: LocalSettingRepository(),
              mastersDatabaseProvider: MastersDatabaseProvider(),
            )..add(InitialSetting()),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

//ToDO Строчка 26-30, этот способ обычно использую не сразу в мейне, а
// а только на странице контроллере после страниц авторизации и тд..
// эта система локатора нам позволяет не перереысовывать  каждый раз всю страницу, а только саму часть body.
// Крайне удобно и эфективно в работе в связке с bottomNavBar и Drawer.
// у меня еще есть пару фишек с навигацией, которые покажу на собесе.
//TOdo В проекте все картинки в пнг формате, обычно использую SVG

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      home: Scaffold(
        body: Navigator(
          key: locator<NavigationService>().navigatorKey,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: HomePage.routeName,
        ),
      ),
    );
  }
}
