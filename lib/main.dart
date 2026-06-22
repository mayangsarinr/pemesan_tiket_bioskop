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

  await initializeDateFormatting('id_ID', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await SeedMovies.seedMovies();

  runApp(const CinemaGoApp());
}

class CinemaGoApp extends StatelessWidget {
  const CinemaGoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
