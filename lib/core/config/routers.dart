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
      builder: (context, state) =>
          DetailBreedPage(params: state.extra as DetailBreedPageParams),
    ),
  ],
);
