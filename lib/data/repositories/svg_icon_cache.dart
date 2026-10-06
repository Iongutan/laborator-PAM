import 'package:http/http.dart' as http;

/// Descarcă asincron iconițele SVG din JSON și le păstrează în memorie,
/// ca fiecare URL să fie cerut o singură dată.
class SvgIconCache {
  SvgIconCache._();

  static final Map<String, Future<String?>> _cache = {};

  /// Returnează textul SVG sau `null` dacă iconița nu se poate încărca.
  static Future<String?> load(String url) {
    return _cache.putIfAbsent(url, () async {
      try {
        final http.Response res = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 10));
        final String body = res.body;
        if (res.statusCode == 200 && body.contains('<svg')) return body;
      } catch (_) {
        // Fără internet sau URL greșit → se folosește iconița locală.
      }
      _cache.remove(url);
      return null;
    });
  }
}
