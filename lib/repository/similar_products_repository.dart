import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/model/products_model.dart';
import 'package:shopby/resources/app_urls.dart';

class SimilarProductsRepository {
  Future<List<Products>> fetchSimilarProducts({
    required int categoryId,
    required int currentProductId,
  }) async {
    final url = AppUrls.fetchSimilarProductsByCategory(categoryId);
    debugPrint("Fetching similar products from: $url");

    final response = await http.get(Uri.parse(url));
    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((json) => Products.fromJson(json))
          .where((p) => p.id != currentProductId)
          .toList();
    } else {
      throw Exception("Error: HTTP ${response.statusCode}");
    }
  }
}

final similarProductsProvider = FutureProvider.family
    .autoDispose<List<Products>, (int, int)>((ref, tuple) {
      final (categoryId, currentProductId) = tuple;
      return SimilarProductsRepository().fetchSimilarProducts(
        categoryId: categoryId,
        currentProductId: currentProductId,
      );
    });
