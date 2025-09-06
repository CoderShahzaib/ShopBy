import 'package:shopby/data/response/status.dart';

class ApiResponse<T> {
  String? message;
  T? data;
  Status? status;
  ApiResponse({this.status, this.data, this.message});
  ApiResponse.loading() : status = Status.loading;
  ApiResponse.completed(this.data) : status = Status.completed;
  ApiResponse.error(this.message) : status = Status.error;
  ApiResponse<T> copyWith({
    Status? status,
    T? data,
    String? message,
  }) {
    return ApiResponse<T>(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message);
  }

  @override
  String toString() {
    return "Status:$status\nData:$data\nMessage:$message";
  }
}
