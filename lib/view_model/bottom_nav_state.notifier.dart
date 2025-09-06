import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/bottom_nav_state.dart';

class BottomNavStateNotifier extends StateNotifier<BottomNavState> {
  BottomNavStateNotifier() : super(BottomNavState(currentIndex: 0));
  void changeIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

final bottomNavProvider =
    StateNotifierProvider<BottomNavStateNotifier, BottomNavState>(
      (ref) => BottomNavStateNotifier(),
    );
