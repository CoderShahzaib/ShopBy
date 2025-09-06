import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/components/checkout/payment_step.dart';
import 'package:shopby/components/checkout/review_step.dart';
import 'package:shopby/components/checkout/shipping_step.dart';
import 'package:shopby/view_model/checkout_screen_notifier.dart';

class StepContent extends ConsumerWidget {
  final PageController controller;

  const StepContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutScreenProvider);

    return Expanded(
      child: PageView(
        controller: state.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Shipping(
            onContinue: () {
              ref.read(checkoutScreenProvider.notifier).nextStep();
            },
          ),
          PaymentStep(
            onContinue: () {
              ref.read(checkoutScreenProvider.notifier).nextStep();
            },
          ),
          ReviewStep(
            onContinue: ref.read(checkoutScreenProvider.notifier).nextStep,
          ),
        ],
      ),
    );
  }
}
