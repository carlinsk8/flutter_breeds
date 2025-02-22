import 'package:flutter/widgets.dart';

import 'app.dart';
import '/core/di/injection_feature.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init dependency injection.
  await di.init();
  runApp(const App());
}
