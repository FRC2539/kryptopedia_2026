import 'dart:convert';
import 'package:http/http.dart';

class Api {
  static Future<dynamic> _makeRequest(String URL) async {
    try {
      Response response = await get(Uri.parse(URL));
      if (response.statusCode.toString().startsWith("2")) {
        return APIResponse(success: true, data: json.decode(response.body));
      } else {
        return APIResponse(success: false, data: response.statusCode);
      }
    } catch (e) {
      return APIResponse(success: false, data: e);
    }
  }

  static Future<dynamic> preauthInfo(String serverURL) async {
    return await _makeRequest("$serverURL/api/preauth-info");
  }
}

class APIResponse {
  final bool success;
  final dynamic data;

  APIResponse({required this.success, required this.data});
}
