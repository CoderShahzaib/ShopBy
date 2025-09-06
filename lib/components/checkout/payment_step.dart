import 'package:flutter/material.dart';
import 'package:shopby/components/checkout/button.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/widgets/buildtextfield.dart';

class PaymentStep extends StatelessWidget {
  final VoidCallback onContinue;
  const PaymentStep({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController cardHolderNameController =
        TextEditingController();
    final TextEditingController expiryDateController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Secure Card Payment",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: AppColors.grey.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                buildTextField(
                  "Card Number",
                  TextInputType.number,
                  cardNumberController,
                ),
                const SizedBox(height: 12),

                buildTextField(
                  "Card Holder Name",
                  TextInputType.text,
                  cardHolderNameController,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        "Expiry Date",
                        TextInputType.datetime,
                        expiryDateController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildTextField(
                        "CVV",
                        TextInputType.number,
                        cvvController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          Button(onContinue: onContinue, text: "Pay Now", color: AppColors.red),
        ],
      ),
    );
  }
}
