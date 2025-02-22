import 'package:get_it/get_it.dart';

import '../api/api_auth_client.dart';

initCore(GetIt sl) {
  sl.registerLazySingleton(
    () => ApiAuthClient(),
  );
}
