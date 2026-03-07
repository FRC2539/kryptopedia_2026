import 'dart:convert';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:kryptopedia/models/tba_event_alliance.dart';

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

  static Future<APIResponse> _makeTbaRequest(
    String url,
    String tbaAuthKey,
  ) async {
    try {
      Response response;
      response = await get(
        Uri.parse(url),
        headers: {"X-TBA-Auth-Key": tbaAuthKey},
      );

      return APIResponse(success: true, data: json.decode(response.body));
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
    List<SyncDataItem> data, {
    bool fromClean = false,
  }) async {
    return await _makeRequest(
      "$serverURL/$teamNumber/api/sync?since=$lastSync&from_clean=$fromClean",
      token: authToken,
      body: json.encode(data.map((d) => d.toMap()).toList()),
    );
  }

  static Future<APIResponse> uploadPhoto(
    String serverURL,
    int teamNumber,
    String authToken,
    String associatedRecordUid,
    String photoPath,
  ) async {
    try {
      String appVersion = await PackageInfo.fromPlatform().then(
        (packageInfo) => packageInfo.version,
      );
      var request = MultipartRequest(
        'POST',
        Uri.parse("$serverURL/$teamNumber/api/photos/$associatedRecordUid"),
      );
      request.headers.addAll({
        "X-App-Version": appVersion,
        "Authorization": "Bearer $authToken",
      });
      request.files.add(await MultipartFile.fromPath('photo', photoPath));
      StreamedResponse response = await request.send();
      if (response.statusCode.toString().startsWith("2")) {
        return APIResponse(
          success: true,
          data: json.decode(
            await response.stream.bytesToString(),
          )["upload_time"],
        );
      } else {
        return APIResponse(success: false, data: response.statusCode);
      }
    } catch (e) {
      return APIResponse(success: false, data: e);
    }
  }

  static Future<APIResponse> downloadPitPhoto(
    String serverURL,
    int teamNumber,
    String authToken,
    String associatedRecordUid,
  ) async {
    try {
      String appVersion = await PackageInfo.fromPlatform().then(
        (packageInfo) => packageInfo.version,
      );
      Response response = await get(
        Uri.parse("$serverURL/$teamNumber/api/photos/$associatedRecordUid"),
        headers: {
          "X-App-Version": appVersion,
          "Authorization": "Bearer $authToken",
        },
      );
      if (response.statusCode.toString().startsWith("2")) {
        return APIResponse(success: true, data: response.bodyBytes);
      } else {
        return APIResponse(success: false, data: response.statusCode);
      }
    } catch (e) {
      return APIResponse(success: false, data: e);
    }
  }

  static Future<APIResponse> getTBATeamRankings(String eventCode) async {
    return await _makeTbaRequest(
      "https://www.thebluealliance.com/api/v3/event/2026${eventCode.toLowerCase()}/rankings",
      "WPzUFYmmSy8xyxxysdXT258MnSE7y1piZBZQYv21rrWMDawjFFBaKhMcXLxpgLih",
    );
  }

  static Future<APIResponse> getTBATeamInsights(String eventCode) async {
    return await _makeTbaRequest(
      "https://www.thebluealliance.com/api/v3/event/2026${eventCode.toLowerCase()}/oprs",
      "WPzUFYmmSy8xyxxysdXT258MnSE7y1piZBZQYv21rrWMDawjFFBaKhMcXLxpgLih",
    );
  }
}

class APIResponse<T> {
  final bool success;
  final T data;

  APIResponse({required this.success, required this.data});
}

class SyncDataItem {
  final String type;
  final dynamic data;
  final String uid;
  final String? scouterId;
  final bool deleted;

  SyncDataItem({
    required this.type,
    required this.data,
    required this.uid,
    this.scouterId,
    this.deleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "data": data,
      "uid": uid,
      "scouter_id": scouterId,
      "deleted": deleted,
    };
  }
}
