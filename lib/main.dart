import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/ui/splash_screen.dart';
import 'package:tr_tree/utils/routes.dart';
import 'package:tr_tree/view_models/authentication/forget_pass_view_model.dart';
import 'package:tr_tree/view_models/authentication/sign_in_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tr_tree/view_models/authentication/sign_up_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => SignInViewModel(),
        ),
        Provider(
          create: (_) => SignUpViewModel(),
        ),
        Provider(
          create: (_) => ForgetPassViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TRI TREE',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        routes: Routes.routes,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', ''), // English, no country code
        ],
      ),
    );
  }
}
