/// A minimal Result type so use cases and repositories can surface failures
/// (e.g. "you're offline and this content isn't cached yet") without
/// throwing exceptions across architectural layers.
sealed class Result<T> {
  const Result();

  factory Result.ok(T value) = Ok<T>;
  factory Result.error(String message, [Object? cause]) = Err<T>;

  R when<R>({
    required R Function(T value) ok,
    required R Function(String message, Object? cause) error,
  }) {
    final self = this;
    if (self is Ok<T>) return ok(self.value);
    if (self is Err<T>) return error(self.message, self.cause);
    throw StateError('Unreachable');
  }
}

final class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

final class Err<T> extends Result<T> {
  final String message;
  final Object? cause;
  const Err(this.message, [this.cause]);
}
