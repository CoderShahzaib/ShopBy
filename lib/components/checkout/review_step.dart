import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopby/components/checkout/button.dart';
import 'package:shopby/resources/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/cart_notifier.dart';

class ReviewStep extends ConsumerWidget {
  final VoidCallback onContinue;
  final String? orderId;
  const ReviewStep({super.key, required this.onContinue, this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartNotifier);

    final subtotal = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final shipping = 200.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Review Your Order",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Items", Icons.shopping_bag),
          _buildItemsCard(cartItems),
          const SizedBox(height: 20),
          _buildSectionTitle("Delivery Address", Icons.location_on),
          _buildAddressCard(),
          const SizedBox(height: 20),
          _buildSectionTitle("Order Summary", Icons.receipt_long),
          _buildSummaryCard(subtotal, shipping),
          const SizedBox(height: 30),
          Button(
            onContinue: onContinue,
            text: "Place Order",
            color: AppColors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.black, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsCard(List cartItems) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: cartItems
              .map<Widget>(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.productName,
                        style: TextStyle(fontSize: 16, color: AppColors.black),
                      ),
                      Text(
                        "${item.quantity} x Rs. ${item.totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, color: AppColors.black),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return FutureBuilder<QuerySnapshot>(
      future: firestore
          .collection("orders")
          .orderBy("created_at", descending: true)
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: Text("Loading..."),
            ),
          );
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Address Found"));
        }
        final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final name = data["name"];
        final address = data["address"];
        final city = data["city"];
        final postalCode = data["postalCode"];
        return Card(
          color: AppColors.white,
          margin: const EdgeInsets.only(top: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
                Text(
                  address,
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
                Text(
                  "$city, $postalCode",
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(double subTotal, double shipping) {
    final total = subTotal + shipping;

    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildSummaryRow("Subtotal", "Rs. ${subTotal.toStringAsFixed(2)}"),
            const SizedBox(height: 6),
            _buildSummaryRow("Shipping", "Rs. ${shipping.toStringAsFixed(2)}"),
            const Divider(height: 20, color: AppColors.grey),
            _buildSummaryRow(
              "Total",
              "Rs. ${total.toStringAsFixed(2)}",
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: AppColors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppColors.red : AppColors.black,
          ),
        ),
      ],
    );
  }
}
