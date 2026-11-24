// Excepțiile aruncate de stratul Data (data source).
// Repository-ul le transformă în [Failure]-uri.

class ServerException implements Exception {
  const ServerException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'ServerException($statusCode)';
}

class NetworkException implements Exception {
  const NetworkException([this.cause]);

  final Object? cause;

  @override
  String toString() => 'NetworkException($cause)';
}

class RequestTimeoutException implements Exception {
  const RequestTimeoutException();

  @override
  String toString() => 'RequestTimeoutException';
}

class ParsingException implements Exception {
  const ParsingException([this.cause]);

  final Object? cause;

  @override
  String toString() => 'ParsingException($cause)';
}
