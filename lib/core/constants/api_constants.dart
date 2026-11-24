/// Adresele serviciului Web REST folosit de aplicație.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://test-api-jlbn.onrender.com';

  /// GET — datele paginii Home.
  static const String feedPath = '/lab2026/v3/feed';

  /// GET — detaliile sălii.
  static const String feedDetailsPath = '/lab2026/v3/feed/details';

  /// Serverul gratuit de pe Render „doarme” și primul răspuns poate dura
  /// până la ~1 minut, de aceea timeout-ul e generos.
  static const Duration timeout = Duration(seconds: 60);
}
