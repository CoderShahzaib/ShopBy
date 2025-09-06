import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/data/response/api_response.dart';
import 'package:shopby/data/response/status.dart';
import 'package:shopby/model/products_model.dart';
import 'package:shopby/repository/category_view_repository.dart';

class HomeViewModel extends StateNotifier<ApiResponse<List<Products>>> {
  final CategoriesViewRepository _repository;

  HomeViewModel(this._repository) : super(ApiResponse.loading());

  Future<void> fetchProducts({String? slug, String? title}) async {
    state = state.copyWith(status: Status.loading);

    try {
      final data = await _repository.fetchProducts(slug: slug, title: title);
      state = ApiResponse.completed(data);
    } catch (error, stackTrace) {
      state = ApiResponse.error(error.toString());
      debugPrint("fetchProducts Error: $error\nStackTrace: $stackTrace");
    }
  }
}

final categoryModelProvider =
    StateNotifierProvider.family<
      HomeViewModel,
      ApiResponse<List<Products>>,
      String
    >((ref, slug) => HomeViewModel(CategoriesViewRepository()));
