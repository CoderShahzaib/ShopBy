import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/data/response/api_response.dart';
import 'package:shopby/model/categories_model.dart';
import 'package:shopby/repository/categories_repository.dart';

class HomeCategoriesViewModel
    extends StateNotifier<ApiResponse<List<Categories>>> {
  final CategoriesRepository _categoriesRepository;
  HomeCategoriesViewModel(this._categoriesRepository)
      : super(ApiResponse.loading());

  Future<void> fetchCategories() async {
    state = ApiResponse.loading();
    try {
      final data = await _categoriesRepository.fetchCategories();
      state = ApiResponse.completed(data);
    } catch (error, stackTrace) {
      debugPrint("fetchCategories Error: $error\nStackTrace: $stackTrace");
    }
  }
}

final categoriesViewModelProvider = StateNotifierProvider<
        HomeCategoriesViewModel, ApiResponse<List<Categories>>>(
    (ref) => HomeCategoriesViewModel(ref.watch(categoriesProvider)));
