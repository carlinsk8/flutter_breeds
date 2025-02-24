import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/providers.dart';
import 'core/config/routers.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: Providers.list,
      child: MaterialApp.router(
        routerConfig: routerConfig,
        title: 'Cat Breeds',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.white, color: Colors.white),
          scaffoldBackgroundColor: Colors.white,
          secondaryHeaderColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffffbc7a)),
          useMaterial3: true,
        ),
      ),
    );
}
