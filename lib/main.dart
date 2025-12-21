import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/dietary_preference_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/app_config_provider.dart';
import 'data/services/remote_config_service.dart';
import 'data/services/cache_service.dart';
import 'data/services/ad_service.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/hub/hub_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize AdMob
  await AdService().initialize();

  // Initialize Cache Service
  final cacheService = CacheService();
  await cacheService.initialize();

  // Initialize Remote Config (do this ONCE before creating providers)
  final remoteConfig = FirebaseRemoteConfig.instance;
  final remoteConfigService = RemoteConfigService(remoteConfig);

  // Initialize and fetch remote config before app starts
  try {
    await remoteConfigService.initialize();
    await remoteConfigService.fetchAndActivate();
    debugPrint('✅ Remote Config fetched successfully at startup');
  } catch (e) {
    debugPrint('⚠️ Remote Config initial fetch failed: $e');
    // App will continue with defaults/cache
  }

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
        ChangeNotifierProvider(
          create: (_) => AppConfigProvider(remoteConfigService)..initialize(),
        ),
      ],
      child: IITJMenuApp(remoteConfigService: remoteConfigService),
    ),
  );
}

class IITJMenuApp extends StatefulWidget {
  final RemoteConfigService remoteConfigService;

  const IITJMenuApp({super.key, required this.remoteConfigService});

  @override
  State<IITJMenuApp> createState() => _IITJMenuAppState();
}

class _IITJMenuAppState extends State<IITJMenuApp> with WidgetsBindingObserver {
  DateTime? _lastPausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App going to background - record time
      _lastPausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      // App coming back to foreground
      _checkAndRefresh();
    }
  }

  void _checkAndRefresh() {
    // Only refresh if app was paused for more than 30 minutes
    if (_lastPausedTime != null) {
      final timePaused = DateTime.now().difference(_lastPausedTime!);
      if (timePaused.inMinutes >= 30) {
        debugPrint(
            '🔄 App resumed after ${timePaused.inMinutes} min - refreshing data');
        // Refresh providers
        context.read<MenuProvider>().refresh();
        context.read<AppConfigProvider>().refresh();
      }
    }
  }

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
        '/hub': (context) => const HubScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
