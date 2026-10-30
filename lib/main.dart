import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles/core/components/app_internet_banner.dart';
import 'package:stronger_muscles/core/services/firebase_options.dart';
import 'package:stronger_muscles/core/services/push_notification_service.dart';
import 'package:stronger_muscles/core/theme/app_theme.dart';
import 'package:stronger_muscles/bootstrap/hive_init.dart';
import 'package:stronger_muscles/features/notifications/notifications_feature.dart';
import 'package:stronger_muscles/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/core/auth/auth_state_provider.dart';
import 'package:stronger_muscles/core/services/crash_reporting_service.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/profile/profile_feature.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CrashReportingService.init();
  await dotenv.load(fileName: ".env");

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Hive.initFlutter();
  await hiveInit();

  registerAuthStateChecker(
    (ref) => ref.read(authControllerProvider.notifier).isLoggedIn,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pushNotificationServiceProvider).initialize(
        onForegroundMessage: (message) {
          ref.read(notificationControllerProvider.notifier).refresh();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final isDarkMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(languageControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
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
    );
  }
}
