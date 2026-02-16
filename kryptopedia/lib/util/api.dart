import 'dart:convert';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Api {
  static Future<APIResponse> _makeRequest(
    String url, {
    String? token,
    String? body,
  }) async {
    try {
      String appVersion = await PackageInfo.fromPlatform().then(
        (packageInfo) => packageInfo.version,
      );
      Response response;
      if (body != null) {
        response = await post(
          Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "X-App-Version": appVersion,
            if (token != null) "Authorization": "Bearer $token",
          },
          body: body,
        );
      } else {
        response = await get(
          Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "X-App-Version": appVersion,
            if (token != null) "Authorization": "Bearer $token",
          },
        );
      }
      if (response.statusCode.toString().startsWith("2")) {
        return APIResponse(success: true, data: json.decode(response.body));
      } else {
        return APIResponse(success: false, data: response.statusCode);
      }
    } catch (e) {
      return APIResponse(success: false, data: e);
    }
  }

  static Future<APIResponse> preauthInfo(
    String serverURL,
    int teamNumber,
  ) async {
    return await _makeRequest("$serverURL/$teamNumber/api/preauth-info");
  }

  static Future<APIResponse> startSessionRequest(
    String serverURL,
    int teamNumber,
    String eventId,
    String deviceId,
  ) async {
    return await _makeRequest(
      "$serverURL/$teamNumber/api/start-session?event_id=$eventId&device_id=$deviceId",
      body: "",
    );
  }

  static Future<APIResponse> cancelSessionRequest(
    String serverURL,
    int teamNumber,
    String sessionRequestId,
  ) async {
    return await _makeRequest(
      "$serverURL/$teamNumber/api/cancel-session-request?request_id=$sessionRequestId",
      body: "",
    );
  }

  static Future<APIResponse> pokeSessionRequest(
    String serverURL,
    int teamNumber,
    String sessionRequestId,
  ) async {
    return await _makeRequest(
      "$serverURL/$teamNumber/api/poke-session?request_id=$sessionRequestId",
    );
  }

  static Future<APIResponse> syncData(
    String serverURL,
    int teamNumber,
    String authToken,
    String lastSync,
    List<SyncDataItem> data,
  ) async {
    return await _makeRequest(
      "$serverURL/$teamNumber/api/sync?since=$lastSync",
      token: authToken,
      body: json.encode(data.map((d) => d.toMap()).toList()),
    );
  }
}

class APIResponse<T> {
  final bool success;
  final T data;

  APIResponse({required this.success, required this.data});
}

/// param data MUST INCLUDE "uid"
class SyncDataItem {
  final String type;
  final dynamic data;
  final bool deleted;

  SyncDataItem({required this.type, required this.data, this.deleted = false});

  Map<String, dynamic> toMap() {
    return {"type": type, "data": data, "deleted": deleted};
  }
}
