import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/profile_screen_state.dart';

class ProfileScreenNotifier extends StateNotifier<ProfileScreenState> {
  ProfileScreenNotifier() : super(ProfileScreenState());

  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void toggleVisibility() {
    state = state.copyWith(toggleVisibility: !state.toggleVisibility);
  }
}

final profileScreenProvider =
    StateNotifierProvider<ProfileScreenNotifier, ProfileScreenState>(
      (ref) => ProfileScreenNotifier(),
    );
