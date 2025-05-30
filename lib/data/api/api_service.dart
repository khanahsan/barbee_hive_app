import 'dart:convert';
import 'dart:io';
import 'package:barbee_hive_app/data/api/endpoint_constants.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/utils/log_util.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {
  //static const String baseUrl = 'https://barbeehive.staging.pegasync.com';
  static String? _token;

  static String? getToken() => _token;

  static void setToken(String token) {
    _token = token;
    TokenStorage.saveToken(token);
  }

  static Future<void> initToken() async {
    _token = await TokenStorage.getToken();
  }

  static void clearToken() {
    _token = null; // Explicitly set to null
    TokenStorage.clearToken(); // Clear from SharedPreferences
  }

  static Map<String, String> _headers({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Future<bool> isInternetAvailable() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        Utilities.showToast(
          toastMsg: 'No internet connection. Please check your WiFi or mobile data.',
          isSuccess: false,
        );
        return false;
      }
      final response = await http.get(
        Uri.parse('https://www.google.com/'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return true;
      }
      Utilities.showToast(
        toastMsg: 'Internet connection is not working. Please check your connection or try again later.',
        isSuccess: false,
      );
      return false;
    } catch (e) {
      Utilities.showToast(
        toastMsg: 'Internet connection is not working. Please check your connection or try again later.',
        isSuccess: false,
      );
      LogUtil.logError('isInternetAvailable: $e');
      return false;
    }
  }

  static Future<dynamic> get(String endpoint, {bool auth = true}) async {
    try {
      if (!(await isInternetAvailable())) {
        throw Exception('No internet connection');
      }
      final uri = Uri.parse('${Endpoints.baseUrl}$endpoint');
      print('GET Request URL: $uri');
      final response = await _safeRequest(
        'GET',
        uri,
        headers: _headers(includeAuth: auth),
      );
      return _handleResponse(response);
    } catch (e) {
      print('GET Error: $e');
      LogUtil.logError('GET $endpoint: $e');
      //throw Exception('GET request error: $e');
      rethrow;
    }
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool auth = true,
  }) async {
    try {
      if (!(await isInternetAvailable())) {
        throw Exception('No internet connection');
      }

      final uri = Uri.parse('${Endpoints.baseUrl}$endpoint');
      print('POST Request URL: $uri');
      final response = await _safeRequest(
        'POST',
        uri,
        headers: _headers(includeAuth: auth),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      print('POST Error: $e');
      LogUtil.logError('POST $endpoint: $e');
      //throw Exception('POST request error: $e');
      rethrow;
    }
  }

 /* static Future<dynamic> multipartPost(
    String endpoint, {
    required Map<String, String> fields,
    File? file,
    String fileField = 'file',
    bool auth = true,
  }) async {
    try {
      if (!(await isInternetAvailable())) {
        throw Exception('No internet connection');
      }

      final uri = Uri.parse('${Endpoints.baseUrl}$endpoint');

      final request = http.MultipartRequest('POST', uri);

      if (auth && _token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields.addAll(fields);

      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(fileField, file.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      print('Multipart POST Error: $e');
      LogUtil.logError('Multipart POST $endpoint: $e');
      //throw Exception('Multipart POST request error: $e');
      rethrow;
       }
  }*/

  static Future<dynamic> multipartPost(
      String endpoint, {
        required Map<String, String> fields,
        Map<String, File>? files, // Changed to support multiple files
        bool auth = true,
      }) async {
    try {
      if (!(await isInternetAvailable())) {
        throw Exception('No internet connection');
      }

      final uri = Uri.parse('${Endpoints.baseUrl}$endpoint');

      final request = http.MultipartRequest('POST', uri);

      if (auth && _token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields.addAll(fields);

      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      print('Multipart POST Error: $e');
      LogUtil.logError('Multipart POST $endpoint: $e');
      rethrow;
    }
  }

  static Future<http.Response> _safeRequest(
    String method,
    Uri uri, {
    required Map<String, String> headers,
    String? body,
    int maxRedirects = 5,
  }) async {
    final client = http.Client();
    try {
      var currentUri = uri;
      var redirects = 0;

      while (redirects < maxRedirects) {
        final request = http.Request(method, currentUri)
          ..headers.addAll(headers);
        if (body != null) request.body = body;
        final streamedResponse = await client.send(request);
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode >= 300 &&
            response.statusCode < 400 &&
            response.headers['location'] != null) {
          currentUri = Uri.parse(response.headers['location']!);
          redirects++;
          continue;
        }
        return response;
      }
      throw Exception('Too many redirects');
    } finally {
      client.close();
    }
  }

  static dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final String rawBody = response.body;

    print('Response Status: $statusCode');
    print('Response Body: $rawBody');

    dynamic body;
    try {
      body = rawBody.isNotEmpty ? jsonDecode(rawBody) : null;
    } catch (e) {
      throw Exception('Failed to parse response: $rawBody');
    }

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else if (statusCode == 301 ||
        statusCode == 302 ||
        statusCode == 307 ||
        statusCode == 308) {
      throw Exception(
        'Redirect detected: ${response.headers['location'] ?? 'Unknown location'}',
      );
    } else if (statusCode == 401) {
      throw Exception(body?['message'] ?? 'Unauthorized request');
    } else if (statusCode == 403) {
      throw Exception(body?['message'] ?? 'Forbidden: Access denied');
    } else if (statusCode == 404) {
      throw Exception(body?['message'] ?? 'Resource not found');
    } else if (statusCode == 422) {
      final errors = body?['errors'] ?? {};
      final firstError =
          errors.isNotEmpty
              ? errors.values.first[0]
              : body?['message'] ?? 'Validation failed';
      throw Exception(firstError);
    } else if (statusCode == 500) {
      throw Exception(body?['message'] ?? 'Internal server error');
    } else {
      throw Exception(body?['message'] ?? 'Unexpected error: $statusCode');
    }
  }
}
