import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/product_details_provider.dart';

class ProductDetailsNotifier extends StateNotifier<ProductDetailsState> {
  ProductDetailsNotifier()
    : super(const ProductDetailsState(selectedImage: ""));
  void setSelectedImage(String selectedImage) =>
      state = state.copyWith(selectedImage: selectedImage);
}

final productDetailsProvider =
    StateNotifierProvider<ProductDetailsNotifier, ProductDetailsState>(
      (ref) => ProductDetailsNotifier(),
    );
