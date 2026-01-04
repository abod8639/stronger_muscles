import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/models/user_model.dart';
import 'package:stronger_muscles/firebase_options.dart';
import 'package:stronger_muscles/functions/init_controllers_app.dart';
import 'package:stronger_muscles/core/constants/app_theme.dart';
import 'package:stronger_muscles/routes/routes.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/presentation/bindings/theme_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stronger_muscles/presentation/bindings/language_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load the .env file
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(OrderItemModelAdapter());
  Hive.registerAdapter(AddressModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  
  // Open Boxes
  await Hive.openBox<CartItemModel>('cart');
  await Hive.openBox<String>('wishlist');
  await Hive.openBox('settings'); // For theme and language settings
  
  runApp(const MyApp());
  
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Controllers
    final themeController = Get.put(ThemeController());
    final languageController = Get.put(LanguageController());

    return Obx(() => GetMaterialApp(
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
    ));
  }
}
