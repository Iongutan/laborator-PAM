import '../error/failures.dart';

/// Rezultatul unei operații: fie [Success] cu date, fie [Failed] cu un [Failure].
/// Use case-urile și repository-ul returnează `Result`, nu aruncă excepții.
sealed class Result<T> {
  const Result();

  /// Execută `onSuccess` sau `onFailure`, după caz.
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        Success<T>(:final data) => onSuccess(data),
        Failed<T>(:final failure) => onFailure(failure),
      };
}

class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

class Failed<T> extends Result<T> {
  const Failed(this.failure);

  final Failure failure;
}
