import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/dietary_preference_provider.dart';
import 'providers/menu_provider.dart';
import 'data/services/remote_config_service.dart';
import 'data/services/cache_service.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Cache Service
  final cacheService = CacheService();
  await cacheService.initialize();

  // Initialize Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;
  final remoteConfigService = RemoteConfigService(remoteConfig);

  // Set system UI overlays
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DietaryPreferenceProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              MenuProvider(remoteConfigService, cacheService)..initialize(),
        ),
      ],
      child: const IITJMenuApp(),
    ),
  );
}

class IITJMenuApp extends StatelessWidget {
  const IITJMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IITJ Menu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
