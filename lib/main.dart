import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:levaeu_app/screens/initial_screen.dart';

import 'package:levaeu_app/hive/user.dart';

import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/routes.dart';
import 'package:levaeu_app/utils/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  await Hive.openBox(userBox);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledToast(
      locale: const Locale('pt', 'BR'),
      child: ScreenUtilInit(
        designSize: const Size(360, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () => MaterialApp(
          title: 'LevaEu',
          routes: routes,
          theme: theme(context),
          home: const AppHome(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('pt', 'BR'),
          ]
        )
      )
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    return const InitialScreen();
  }
}