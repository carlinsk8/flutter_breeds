import 'package:get_it/get_it.dart';
import '../../features/breeds/di/auth_module.dart';
import 'core_module.dart';

final sl = GetIt.instance;

init() async {
  initCore(sl);
  initBreedsModule(sl);
}
