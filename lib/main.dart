import 'package:bloc/bloc.dart';
import 'package:example_drift_with_bloc/app.dart';
import 'package:example_drift_with_bloc/bloc/observer.dart';
import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/theme.dart';
import 'package:example_drift_with_bloc/utils/enums.dart';
import 'package:example_drift_with_bloc/utils/globals.dart';
import 'package:example_drift_with_bloc/utils/routes.dart';
import 'package:flutter/material.dart';

void main() {
  setupLocator();
  FlutterError.onError = (details) {
    getIt<AppDatabase>().insertLog(LogLevel.error, details.exceptionAsString(),
        tag: 'FlutterError');
  };
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'History of SpaceX missions',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      home: const App(title: 'Home page'),
    );
  }
}
