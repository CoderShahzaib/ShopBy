class AppUrls {
  static const String baseUrl = "https://api.escuelajs.co/api/v1/products";
  static const String categories = "https://api.escuelajs.co/api/v1/categories";
  static String categoryView(String slug, {String? title}) {
    if (title != null && title.isNotEmpty) {
      return "$baseUrl/?categorySlug=$slug&title=$title";
    }
    return "$baseUrl/?categorySlug=$slug";
  }

  static String filterProduct(String name) {
    return "https://api.escuelajs.co/api/v1/products?title=$name";
  }

  static String fetchSimilarProductsByCategory(int categoryId) =>
      "https://api.escuelajs.co/api/v1/categories/$categoryId/products";
}
