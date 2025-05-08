import 'dart:convert';
import 'package:barbee_hive_app/data/api/endpoint_constants.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
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

  static Future<dynamic> get(String endpoint, {bool auth = true}) async {
    try {
      final uri = Uri.parse('${Endpoints.baseUrl}$endpoint');
      print('GET Request URL: $uri');
      final response = await _safeRequest('GET', uri, headers: _headers(includeAuth: auth));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> data, {bool auth = true}) async {
    try {
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
      throw Exception('POST request error: $e');
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
        final request = http.Request(method, currentUri)..headers.addAll(headers);
        if (body != null) request.body = body;
        final streamedResponse = await client.send(request);
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode >= 300 && response.statusCode < 400 && response.headers['location'] != null) {
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
    } else if (statusCode == 301 || statusCode == 302 || statusCode == 307 || statusCode == 308) {
      throw Exception('Redirect detected: ${response.headers['location'] ?? 'Unknown location'}');
    } else if (statusCode == 401) {
      throw Exception(body?['message'] ?? 'Unauthorized request');
    } else if (statusCode == 403) {
      throw Exception(body?['message'] ?? 'Forbidden: Access denied');
    } else if (statusCode == 404) {
      throw Exception(body?['message'] ?? 'Resource not found');
    } else if (statusCode == 422) {
      final errors = body?['errors'] ?? {};
      final firstError = errors.isNotEmpty
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







