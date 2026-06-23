import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'utils/app_colors.dart';
import 'utils/app_routes.dart';
import 'utils/app_constants.dart';
import 'seed_movies.dart';
import 'screens/splash_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/seat_selection_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/booking_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/favorite_movie_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? dateError;
  String? firebaseError;

  // Step 1: Initialize date formatting
  try {
    // ignore: avoid_print
    print('[DEBUG] Initializing date formatting...');
    await initializeDateFormatting('id_ID', null);
    // ignore: avoid_print
    print('[DEBUG] Date formatting initialized successfully');
  } catch (e, st) {
    dateError = '$e\n$st';
    // ignore: avoid_print
    print('[ERROR] Date formatting failed: $dateError');
  }

  // Step 2: Initialize Firebase
  try {
    // ignore: avoid_print
    print('[DEBUG] Initializing Firebase...');

    final bool isFirebaseAlreadyInitialized = Firebase.apps.any(
      (app) => app.name == defaultFirebaseAppName,
    );

    if (!isFirebaseAlreadyInitialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // ignore: avoid_print
      print('[DEBUG] Firebase initialized successfully');
    } else {
      // ignore: avoid_print
      print('[DEBUG] Firebase already initialized, skipping...');
    }
  } catch (e, st) {
    if (e is FirebaseException && e.code == 'duplicate-app') {
      // ignore duplicate initialization on Android release builds
      // when the default app is already registered by the native layer.
      // ignore: avoid_print
      print('[DEBUG] Firebase duplicate-app error ignored; continuing.');
    } else {
      firebaseError = '$e\n$st';
      // ignore: avoid_print
      print('[ERROR] Firebase initialization failed: $firebaseError');
      // Continue anyway - app can work offline
    }
  }

  //await SeedMovies.seedMovies();

  // ignore: avoid_print
  print('[DEBUG] App starting...');
  runApp(CinemaGoApp(
    dateError: dateError,
    firebaseError: firebaseError,
  ));
}

class CinemaGoApp extends StatelessWidget {
  final String? dateError;
  final String? firebaseError;

  const CinemaGoApp({
    Key? key,
    this.dateError,
    this.firebaseError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show error screen only if there's a critical error
    if (dateError != null) {
      return MaterialApp(
        title: 'CinemaGo - Error',
        debugShowCheckedModeBanner: false,
        home: ErrorScreen(
          title: 'Date Formatting Error',
          error: dateError!,
          isCritical: true,
        ),
      );
    }

    // Firebase error is non-critical - app can continue
    if (firebaseError != null) {
      return MaterialApp(
        title: 'CinemaGo',
        debugShowCheckedModeBanner: false,
        home: ErrorScreen(
          title: 'Firebase Error (Offline Mode)',
          error: firebaseError!,
          isCritical: false,
        ),
      );
    }

    return MaterialApp(
      title: 'CinemaGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primaryDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.lightBlue,
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.signIn: (context) => const SignInScreen(),
        AppRoutes.signUp: (context) => const SignUpScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.movieDetail: (context) => const MovieDetailScreen(),
        AppRoutes.schedule: (context) => const ScheduleScreen(),
        AppRoutes.seatSelection: (context) => const SeatSelectionScreen(),
        AppRoutes.booking: (context) => const BookingScreen(),
        AppRoutes.bookingHistory: (context) => const BookingHistoryScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.favorites: (context) => const FavoriteMovieScreen(),
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String title;
  final String error;
  final bool isCritical;

  const ErrorScreen({
    Key? key,
    required this.title,
    required this.error,
    this.isCritical = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: isCritical ? Colors.red[900] : Colors.orange[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCritical
                    ? '❌ Critical Error - App cannot start'
                    : '⚠️ Warning - App running in offline mode',
                style: TextStyle(
                  color: isCritical ? Colors.red[300] : Colors.orange[300],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Error Details:',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCritical ? Colors.red : Colors.orange,
                  ),
                ),
                child: SelectableText(
                  error,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Troubleshooting:',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Check your internet connection\n'
                '• Ensure google-services.json is correct\n'
                '• Restart the app\n'
                '• Clear app cache (Settings > Apps)\n'
                '• Reinstall the app',
                style: TextStyle(color: AppColors.textLight, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
