import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/data/network/base_api_services.dart';
import 'package:shopby/data/network/network_api_services.dart';
import 'package:shopby/model/products_model.dart';
import 'package:shopby/resources/app_urls.dart';

class HomeRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<List<Products>> fetchProducts({String? title}) async {
    try {
      final String url = (title != null && title.isNotEmpty)
          ? AppUrls.filterProduct(title)
          : AppUrls.baseUrl;
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
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository();
});
