import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles/firebase_options.dart';
import 'package:stronger_muscles/functions/hive_init.dart';
import 'package:stronger_muscles/functions/init_controllers_app.dart';
import 'package:stronger_muscles/core/constants/app_theme.dart';
import 'package:stronger_muscles/presentation/widgets/internet_connection_banner.dart';
import 'package:stronger_muscles/routes/routes.dart';
import 'package:stronger_muscles/presentation/bindings/theme_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stronger_muscles/presentation/bindings/language_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); 
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await Hive.initFlutter();
  await hiveInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final themeController = Get.put(ThemeController());
    final languageController = Get.put(LanguageController());

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        initialBinding: initControllersApp(),
        initialRoute: AppRoutes.main,
        getPages: AppPages.routes,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: languageController.currentLocale.value,
        builder: (context, child) => Stack(
          children: [
            child!,
            const Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: InternetConnectionBanner(),
            ),
          ],
        ),
      ),
    );
  }
}
