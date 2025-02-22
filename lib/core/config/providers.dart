import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/breeds/presentation/providers/breeds_provider.dart';
import '../di/injection_feature.dart';

class Providers {
  static List<SingleChildWidget> list = [
    ListenableProvider<BreedsProvider>(create: (_) => sl<BreedsProvider>()),
  ];
}
