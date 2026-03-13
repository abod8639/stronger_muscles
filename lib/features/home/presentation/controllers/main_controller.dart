import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_controller.g.dart';

@riverpod
class MainController extends _$MainController {
  @override
  int build() => 0;

  void changeTabIndex(int index) {
    state = index;
  }
}
