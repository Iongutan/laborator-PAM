import 'package:discount_calculator/core/error/exceptions.dart';
import 'package:discount_calculator/core/network/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../helpers/fakes.dart';

void main() {
  test('200 → JSON decodat, cu Accept: application/json', () async {
    http.Request? sent;
    final ApiClient api = fakeApi(fakeServer(onRequest: (r) => sent = r));

    final Map<String, dynamic> json = await api.getJson('/lab2026/v3/feed');

    expect(json['header']['greeting'], 'Good Morning');
    expect(sent!.method, 'GET');
    expect(sent!.url.toString(), 'https://test.local/lab2026/v3/feed');
    expect(sent!.headers['Accept'], 'application/json');
  });

  test('404 / 500 → ServerException cu codul de stare', () async {
    expect(() => fakeApi(fakeServer()).getJson('/nu-exista'),
        throwsA(isA<ServerException>().having((e) => e.statusCode, 'code', 404)));
    expect(() => fakeApi(fakeServer(statusCode: 500)).getJson('/lab2026/v3/feed'),
        throwsA(isA<ServerException>().having((e) => e.statusCode, 'code', 500)));
  });

  test('JSON invalid → ParsingException', () async {
    final ApiClient api =
        fakeApi(MockClient((_) async => http.Response('<html>oops', 200)));
    expect(() => api.getJson('/x'), throwsA(isA<ParsingException>()));
  });

  test('fără conexiune → NetworkException', () async {
    final ApiClient api = fakeApi(
        MockClient((_) async => throw http.ClientException('offline')));
    expect(() => api.getJson('/x'), throwsA(isA<NetworkException>()));
  });

  test('răspuns prea lent → RequestTimeoutException', () async {
    final ApiClient api = ApiClient(
      client: fakeServer(delay: const Duration(milliseconds: 200)),
      baseUrl: 'https://test.local',
      timeout: const Duration(milliseconds: 20),
    );
    expect(() => api.getJson('/lab2026/v3/feed'),
        throwsA(isA<RequestTimeoutException>()));
  });
}
