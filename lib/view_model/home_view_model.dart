import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/data/response/api_response.dart';
import 'package:shopby/data/response/status.dart';
import 'package:shopby/model/products_model.dart';
import 'package:shopby/repository/home_repository.dart';
import 'package:riverpod/riverpod.dart';

class HomeViewModel extends StateNotifier<ApiResponse<List<Products>>> {
  final HomeRepository _repository;

  HomeViewModel(this._repository) : super(ApiResponse.loading());

  Future<void> fetchProducts({String? title}) async {
    state = state.copyWith(status: Status.loading);

    try {
      final response = await _repository.fetchProducts(title: title);
      state = state.copyWith(status: Status.completed, data: response);
    } catch (error) {
      state = state.copyWith(message: error.toString(), status: Status.error);
    }
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, ApiResponse<List<Products>>>(
        (ref) => HomeViewModel(ref.watch(homeRepositoryProvider)));
