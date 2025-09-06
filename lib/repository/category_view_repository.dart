import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/data/network/base_api_services.dart';
import 'package:shopby/data/network/network_api_services.dart';
import 'package:shopby/model/products_model.dart';
import 'package:shopby/resources/app_urls.dart';

class CategoriesViewRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<List<Products>> fetchProducts({String? slug, String? title}) async {
    final url = (title != null && title.isNotEmpty)
        ? "${AppUrls.categoryView(slug!)}&title=$title"
        : AppUrls.categoryView(slug!);
    try {
      final response = await _apiServices.getApiResponse(url);
      if (response is List) {
        return response.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception("Failed to fetch products: ${e.toString()}");
    }
  }

  Future<List<Products>> fetchSimilarProducts(
    String categorySlug,
    int currentProductId,
  ) async {
    final response = await http.get(
      Uri.parse(AppUrls.categoryView(categorySlug, title: "")),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((json) => Products.fromJson(json))
          .where((product) => product.id != currentProductId)
          .toList();
    } else {
      throw Exception("Failed to load similar products");
    }
  }
}

final categoriesViewProvider = FutureProvider.family<List<Products>, String>(
  (ref, slug) => CategoriesViewRepository().fetchProducts(slug: slug),
);
