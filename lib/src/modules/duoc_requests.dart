import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class WrongUserAuthException implements Exception {
  String cause;
  WrongUserAuthException(this.cause);
}

class DuocRequest {
  static const String _baseUri = 'duoc.hinotori.moe';
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> postLoginRequest(
      String email, String password) async {
    try {
      http.Response response = await http.post(Uri.https(_baseUri, 'login'),
          body: json.encode({"username": email, "password": password}),
          headers: {"Content-Type": "application/json", 'Accept': '*/*'});

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      return jsonResponse;
    } catch (exception) {
      throw Exception("Error trying to connect to API: $exception");
    }
  }

  static Future<Map<String, dynamic>> getStudent() async {
    String accessToken = await getAccessToken();

    try {
      http.Response response = await http.get(Uri.https(_baseUri, 'student'),
          headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"});
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } catch (exception) {
      throw Exception("Error trying to connect to API: $exception");
    }
  }

  static Future<List<dynamic>> getSchedule() async {
    String accessToken = await getAccessToken();

    try {
      http.Response response = await http.get(Uri.https(_baseUri, 'schedule'),
          headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"});
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } catch (exception) {
      throw Exception("Error trying to connect to API: $exception");
    }
  }

  static Future<List<dynamic>> getAttendance() async {
    String accessToken = await getAccessToken();

    try {
      http.Response response = await http.get(Uri.https(_baseUri, 'attendance'),
          headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"});
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } catch (exception) {
      http.Response response = await http.get(Uri.https(_baseUri, 'attendance'),
          headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"});
      Map<String, dynamic> data = jsonDecode(response.body);
      throw Exception("Error trying to connect to API: $exception");
    }
  }

  static Future<List<dynamic>> getGrades() async {
    String accessToken = await getAccessToken();

    try {
      http.Response response = await http.get(Uri.https(_baseUri, 'grades'),
          headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"});
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } catch (exception) {
      throw Exception("Error trying to connect to API: $exception");
    }
  }

  static Future<String> getAccessToken() async {
    String? accessToken = await storage.read(key: "access_token");
    //String? refreshToken = await storage.read(key: "refresh_token");

    if (accessToken == null) {
      //refreshToken == null) {
      throw WrongUserAuthException("Access or Refresh token is null");
    }

    if (!JwtDecoder.isExpired(accessToken)) {
      return accessToken;
    }
    /*else if (!JwtDecoder.isExpired(refreshToken)) {
      debugPrint("Refreshing token");
      try {
        debugPrint(accessToken);
        debugPrint(refreshToken);
        http.Response response = await http.post(
            Uri.parse('$_baseUri/auth/refresh'),
            headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
            body: {"refresh_token": refreshToken});
        Map<String, String> jsonResponse = jsonDecode(response.body);

        if (response.statusCode == 200) {
          await storage.write(
              key: "access_token", value: jsonResponse["access_token"]);
          await storage.write(
              key: "refresh_token", value: jsonResponse["refresh_token"]);

          return jsonResponse["access_token"]!;
        } else {
          debugPrint('$response.statusCode');
        }
      } catch (exception) {
        debugPrint("Some error connecting to the API $exception");
        throw Exception(exception);
      }
    }*/
    throw WrongUserAuthException("User tokens are invalid");
  }

  static void cleanTokens() async {
    storage.deleteAll();
  }
}
