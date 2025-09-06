class ProfileScreenState {
  final int selectedIndex;
  final bool toggleVisibility;

  const ProfileScreenState({
    this.selectedIndex = 0,
    this.toggleVisibility = false,
  });

  ProfileScreenState copyWith({int? selectedIndex, bool? toggleVisibility}) {
    return ProfileScreenState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      toggleVisibility: toggleVisibility ?? this.toggleVisibility,
    );
  }
}
