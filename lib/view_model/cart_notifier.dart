import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:persistent_shopping_cart/controller/cart_controller.dart';

final cartNotifier =
    StateNotifierProvider<CartNotifier, List<PersistentShoppingCartItem>>(
      (ref) => CartNotifier(),
    );

class CartNotifier extends StateNotifier<List<PersistentShoppingCartItem>> {
  CartNotifier() : super([]) {
    _loadCart();
    CartController().cartListenable.addListener(_loadCart);
  }

  void _loadCart() {
    final cartItems = CartController().getCartItems();
    state = [...cartItems];
  }

  Future<void> addItem(PersistentShoppingCartItem item) async {
    await PersistentShoppingCart().addToCart(item);
  }

  Future<void> incrementQuantity(String productId) async {
    await PersistentShoppingCart().incrementCartItemQuantity(productId);
  }

  Future<void> decrementQuantity(String productId) async {
    await PersistentShoppingCart().decrementCartItemQuantity(productId);
  }

  Future<void> removeItem(String productId) async {
    await PersistentShoppingCart().removeFromCart(productId);
  }

  Future<void> clearCart() async {
    PersistentShoppingCart().clearCart();
  }

  Future<void> reloadCart() async {
    _loadCart();
  }

  @override
  void dispose() {
    CartController().cartListenable.removeListener(_loadCart);
    super.dispose();
  }
}
