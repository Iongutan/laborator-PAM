import 'package:equatable/equatable.dart';

/// Erorile pe care stratul Domain le dă mai departe către Presentation.
/// Fiecare are un mesaj gata de afișat.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Fără conexiune la internet / serverul nu poate fi contactat.
class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('No internet connection. Check your network and try again.');
}

/// Serverul nu a răspuns în timp util.
class TimeoutFailure extends Failure {
  const TimeoutFailure()
      : super('The server took too long to respond. Please try again.');
}

/// Serverul a răspuns cu un cod HTTP de eroare (4xx / 5xx).
class ServerFailure extends Failure {
  const ServerFailure(this.statusCode)
      : super('Server error ($statusCode). Please try again later.');

  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Răspunsul nu este un JSON valid sau are alt format decât cel așteptat.
class ParsingFailure extends Failure {
  const ParsingFailure() : super('Received invalid data from the server.');
}
