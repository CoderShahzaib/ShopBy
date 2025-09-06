import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/data/network/base_api_services.dart';
import 'package:shopby/data/network/network_api_services.dart';
import 'package:shopby/model/categories_model.dart';
import 'package:shopby/resources/app_urls.dart';

class CategoriesRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<List<Categories>> fetchCategories() async {
    try {
      final response = await _apiServices.getApiResponse(AppUrls.categories);
      if (response is List) {
        return response.map((json) => Categories.fromJson(json)).toList();
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception("Failed to fetch products: ${e.toString()}");
    }
  }
}

final categoriesProvider =
    Provider<CategoriesRepository>((ref) => CategoriesRepository());
