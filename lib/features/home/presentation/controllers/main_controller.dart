import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_controller.g.dart';

@Riverpod(keepAlive: true)
class MainController extends _$MainController {
  @override
  int build() => 0;

  void changeTabIndex(int index) {
    state = index;
  }
}
