import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopby/components/checkout/button.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/view_model/cart_notifier.dart';
import 'package:shopby/widgets/buildtextfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Shipping extends ConsumerWidget {
  final VoidCallback onContinue;
  const Shipping({super.key, required this.onContinue});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.read(cartNotifier);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    double screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController postalCodeController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Please Enter Your Shipping Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          buildTextField("Full Name", TextInputType.text, nameController),
          SizedBox(height: screenHeight * 0.02),
          buildTextField(
            "Address",
            TextInputType.streetAddress,
            addressController,
          ),
          SizedBox(height: screenHeight * 0.02),
          buildTextField("City", TextInputType.text, cityController),
          SizedBox(height: screenHeight * 0.02),
          buildTextField(
            "Postal Code",
            TextInputType.number,
            postalCodeController,
          ),
          SizedBox(height: screenHeight * 0.04),
          Button(
            onContinue: () async {
              final docRef = await firestore
                  .collection("orders")
                  .add({
                    "name": nameController.text,
                    "address": addressController.text,
                    "city": cityController.text,
                    "postalCode": postalCodeController.text,
                    "created_at": Timestamp.now(),
                    "ItemName": cartItems
                        .map((item) => item.productName)
                        .toList(),
                    "ItemQuantity": cartItems
                        .map((item) => item.quantity)
                        .toList(),
                    "ItemPrice": cartItems
                        .map((item) => item.totalPrice)
                        .toList(),
                    "SubTotal": cartItems.fold(
                      0.0,
                      (sum, item) => sum + item.totalPrice + 200.0,
                    ),
                  })
                  .then((value) {
                    onContinue();
                  });
            },
            text: "Next",
            color: AppColors.red,
          ),
        ],
      ),
    );
  }
}
