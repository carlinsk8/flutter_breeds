import 'package:flutter/material.dart';
import 'package:flutter_breeds/features/breeds/presentation/pages/breeds_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/breeds/presentation/pages/detail_breed_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/breeds',
      builder: (context, state) => const BreedsPage(),
    ),
    GoRoute(
      path: '/reedDetail',
      builder: (context, state) {
        final params = state.extra;
        if (params is DetailBreedPageParams) {
          return DetailBreedPage(params: params);
        }
        return  Scaffold(
          appBar: AppBar(
            title: const Text('Error 401'),
          ),
          body: const Center(
            child: Text('Error 401: params found'),
          ),
        ); 
      },
    ),
  ],
  
);
