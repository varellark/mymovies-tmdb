import 'package:flutter/material.dart';
import '../../pages/login/login_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/detail/detail_page.dart';
import '../../pages/search/search_page.dart';
import '../../pages/favorite/favorite_page.dart';
import '../../models/movie.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String search = '/search';
  static const String favorite = '/favorite';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case detail:
        final movie = settings.arguments as Movie;
        return MaterialPageRoute(builder: (_) => DetailPage(movie: movie));

      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());

      case favorite:
        return MaterialPageRoute(builder: (_) => const FavoritePage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} tidak ditemukan!'),
            ),
          ),
        );
    }
  }
}
