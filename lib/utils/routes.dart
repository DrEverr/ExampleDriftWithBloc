import 'package:example_drift_with_bloc/app.dart';
import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/ui/exceptions/not_found_page.dart';
import 'package:example_drift_with_bloc/ui/favourites_page.dart';
import 'package:example_drift_with_bloc/ui/history_page.dart';
import 'package:example_drift_with_bloc/ui/logs_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';
  static const String history = '/history';
  static const String favourites = '/favourites';
  static const String logs = '/logs';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => const App(title: 'Home page'),
        );
      case Routes.history:
        final history = settings.arguments as History;
        return MaterialPageRoute(
          builder: (context) => HistoryPage(history: history),
        );
      case Routes.favourites:
        return MaterialPageRoute(
          builder: (context) => const FavouritesPage(),
        );
      case Routes.logs:
        return MaterialPageRoute(
          builder: (context) => const LogsPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundPage(),
        );
    }
  }
}