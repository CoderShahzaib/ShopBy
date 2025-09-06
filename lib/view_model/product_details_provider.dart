class ProductDetailsState {
  final String selectedImage;
  const ProductDetailsState({required this.selectedImage});

  ProductDetailsState copyWith({String? selectedImage}) =>
      ProductDetailsState(selectedImage: selectedImage ?? this.selectedImage);
}
