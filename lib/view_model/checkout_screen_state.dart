import 'package:flutter/widgets.dart';

class CheckoutScreenState {
  final PageController pageController;
  final int currentStep;
  final String? orderId;

  CheckoutScreenState({
    PageController? pageController,
    this.currentStep = 0,
    this.orderId,
  }) : pageController = pageController ?? PageController();

  CheckoutScreenState copyWith({
    PageController? pageController,
    int? currentStep,
    String? orderId,
  }) {
    return CheckoutScreenState(
      pageController: pageController ?? this.pageController,
      currentStep: currentStep ?? this.currentStep,
      orderId: orderId ?? this.orderId,
    );
  }
}
