import 'dart:convert';
import 'package:http/http.dart';
import 'package:shopby/data/network/base_api_services.dart';
import 'package:shopby/data/response/exception.dart';

class NetworkApiServices extends BaseApiServices {
  dynamic responseJson;
  @override
  Future<dynamic> getApiResponse(String url) async {
    try {
      final Response response = await get(
        Uri.parse(url),
      ).timeout(
        const Duration(seconds: 10),
      );
      return returnResponse(response);
    } catch (e) {
      throw e.toString();
    }
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var data = utf8.decode(response.bodyBytes);
        return jsonDecode(data);

      default:
        throw FetchDataException(
            "Error occured while communicating with server with status code ${response.statusCode}");
    }
  }
}
