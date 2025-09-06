import 'package:flutter/material.dart';
import 'package:shopby/components/checkout/buildStepContent.dart';
import 'package:shopby/components/checkout/check_out_screen_header.dart';
import 'package:shopby/resources/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/checkout_screen_notifier.dart';

class CheckOutScreen extends ConsumerStatefulWidget {
  const CheckOutScreen({super.key});

  @override
  ConsumerState<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends ConsumerState<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final state = ref.watch(checkoutScreenProvider);
    final notifer = ref.read(checkoutScreenProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Check Out",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CheckOutScreenHeader(
                text: "Shipping",
                image: "assets/delivery.png",
                isActive: state.currentStep >= 0,
              ),
              Container(height: 1, width: 30, color: Colors.black),

              CheckOutScreenHeader(
                text: "Payment",
                image: "assets/credit-card.png",
                isActive: state.currentStep >= 1,
              ),
              Container(height: 1, width: 30, color: Colors.black),
              CheckOutScreenHeader(
                text: "Review",
                image: "assets/review.png",
                isActive: state.currentStep == 2,
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          StepContent(controller: state.pageController),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: state.currentStep == 0 ? () {} : notifer.prevStep,
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    backgroundColor: AppColors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Go back",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: state.currentStep == 2 ? () {} : notifer.nextStep,
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    backgroundColor: AppColors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Agree and Continue",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
