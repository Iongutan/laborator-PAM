import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

/// Client HTTP reutilizabil: face cererea, verifică codul de stare și
/// decodează JSON-ul. Aruncă excepțiile din core/error/exceptions.dart.
class ApiClient {
  ApiClient({
    http.Client? client,
    this.baseUrl = ApiConstants.baseUrl,
    this.timeout = ApiConstants.timeout,
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final Duration timeout;

  /// GET [path] și returnează corpul răspunsului ca obiect JSON.
  Future<Map<String, dynamic>> getJson(String path) async {
    final Uri uri = Uri.parse('$baseUrl$path');
    final http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: const {'Accept': 'application/json'},
      ).timeout(timeout);
    } on TimeoutException {
      // TimeoutException din dart:async → excepția noastră.
      throw const RequestTimeoutException();
    } on SocketException catch (e) {
      throw NetworkException(e);
    } on http.ClientException catch (e) {
      throw NetworkException(e);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(response.statusCode);
    }

    try {
      final Object? decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) return decoded;
      throw const ParsingException('Expected a JSON object');
    } on FormatException catch (e) {
      throw ParsingException(e);
    }
  }

  void close() => _client.close();
}
