import 'package:flutter/widgets.dart';
import 'package:shopby/view_model/checkout_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreenNotifier extends StateNotifier<CheckoutScreenState> {
  CheckoutScreenNotifier() : super(CheckoutScreenState()) {
    state.pageController.addListener(_pageListener);
  }

  void _pageListener() {
    final currentPage = state.pageController.page?.round() ?? 0;
    if (currentPage != state.currentStep) {
      state = state.copyWith(currentStep: currentPage);
    }
  }

  void nextStep({String? newOrderId}) {
    state = state.copyWith(
      currentStep: state.currentStep + 1,
      orderId: newOrderId ?? state.orderId,
    );

    if (state.currentStep <= 2) {
      state.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
      state.pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

final checkoutScreenProvider =
    StateNotifierProvider<CheckoutScreenNotifier, CheckoutScreenState>(
      (ref) => CheckoutScreenNotifier(),
    );
