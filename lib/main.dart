import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/providers/home_provider.dart';
import 'package:promohunter/providers/page_provider.dart';
import 'package:promohunter/ui/auth/info_screen.dart';
import 'package:promohunter/ui/library_screen.dart';
import 'package:promohunter/ui/main_screen.dart';
import 'package:promohunter/ui/on_boarding_screen.dart';
import 'package:promohunter/ui/splash_screen.dart';
import 'package:promohunter/utils/analytics_client.dart';
import 'package:promohunter/utils/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  Analytics.instance.logAppOpen();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(PromoHunterApp());
}

class PromoHunterApp extends StatefulWidget {
  @override
  _PromoHunterAppState createState() => _PromoHunterAppState();
}

class _PromoHunterAppState extends State<PromoHunterApp>
    with TickerProviderStateMixin {
  Widget _getHomeWidget(AuthService auth) {
    if (auth.isLogged && auth.userExist) return MainScreen();

    return FutureBuilder<bool>(
      future: auth.autoLogin(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        return snapshot.data && auth.userExist
            ? MainScreen()
            : snapshot.data && !auth.userExist
                ? InfoScreen()
                : ChangeNotifierProvider(
                    create: (context) => PageProvider(),
                    child: OnBoardingScreen(),
                  );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (BuildContext context) => AuthService(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (BuildContext context) => HomeProvider(),
        ),
        ChangeNotifierProvider<TabIndexProvider>(
          create: (BuildContext context) => TabIndexProvider(
            TabController(
              length: 4,
              initialIndex: 0,
              vsync: this,
            ),
            2,
          ),
        )
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Promo Hunter',
          theme: AppTheme.theme,
          home: _getHomeWidget(auth),
          navigatorObservers: <NavigatorObserver>[
            Analytics.instance.observer,
          ],
        ),
      ),
    );
  }
}
