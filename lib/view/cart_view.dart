import 'package:flutter/material.dart';
import 'package:shopby/components/cart/network_image_widget.dart';
import 'package:shopby/components/cart/quantity_selector.dart';
import 'package:shopby/resources/colors.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:shopby/view/check_out_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/cart_notifier.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({super.key});

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  String promoCode = '';
  double discount = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartNotifier);
    final cartActions = ref.read(cartNotifier.notifier);

    final subtotal = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * 0.05;
    final grandTotal = subtotal + tax - discount;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: const Text(
          "Your Cart",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: cartItems.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final imageUrl =
                            (item.productImages != null &&
                                item.productImages!.isNotEmpty &&
                                item.productImages!.first.isNotEmpty)
                            ? item.productImages!.first
                            : (item.productThumbnail?.isNotEmpty == true
                                  ? item.productThumbnail!
                                  : 'https://via.placeholder.com/100');

                        return Dismissible(
                          key: Key(item.productId),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) {
                            final removedItem = item;
                            cartActions.removeItem(item.productId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${item.productName} removed"),
                                action: SnackBarAction(
                                  label: "UNDO",
                                  onPressed: () {
                                    PersistentShoppingCart().addToCart(
                                      removedItem,
                                    );
                                    cartActions.reloadCart();
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NetworkImageWidget(
                                  imageUrl: imageUrl,
                                  width: 100,
                                  height: 100,
                                  borderRadius: 12,
                                  iconSize: 20,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\$${item.unitPrice.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.red,
                                            ),
                                          ),
                                          QuantitySelector(
                                            quantity: item.quantity,
                                            increment: () =>
                                                cartActions.incrementQuantity(
                                                  item.productId,
                                                ),
                                            decrement: () =>
                                                cartActions.decrementQuantity(
                                                  item.productId,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Enter Promo Code",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            onChanged: (val) {
                              promoCode = val;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                          ),
                          child: const Text(
                            "Apply",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        _buildPriceRow("Subtotal", subtotal),
                        const SizedBox(height: 4),
                        _buildPriceRow("Tax (5%)", tax),
                        if (discount > 0) _buildPriceRow("Discount", -discount),
                        const SizedBox(height: 12),
                        _buildPriceRow(
                          "Total",
                          grandTotal,
                          isBold: true,
                          highlight: true,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CheckOutScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Checkout",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double value, {
    bool isBold = false,
    bool highlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: highlight ? AppColors.red : AppColors.black,
          ),
        ),
      ],
    );
  }
}
