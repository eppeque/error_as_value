/// `Result<T, E>` is the type used for returning and propagating errors.
/// It is a class with the factories, [Result.ok], representing success and containing a value,
/// and [Result.err], representing error and containing an error value.
///
/// Functions return [Result] whenever errors are expected and recoverable.
/// A simple function returning [Result] might be defined and used like so:
///
/// ```
/// Result<double, String> divide(int a, int b) {
///   if (b == 0) {
///     return Result.err("Division by zero");
///   }
///
///   return Result.ok(a / b);
/// }
///
/// void main() {
///   final (value, error) = divide(10, 2).values;
///
///   if (error != null) {
///     print(error); // Prints "Division by zero"
///   } else {
///     print(value); // Prints 5
///   }
/// }
/// ```
///
/// Pattern matching on [Result] is clear and straightforward for simple cases,
/// but [Result] comes with some convenience getters that make working with it more succint.
///
/// ```
/// // The `isOk` and `isErr` getters do what they say.
/// final Result<int, int> goodResult = Result.ok(10);
/// final Result<int, int> badResult = Result.err(10);
///
/// print(goodResult.isOk); // true
/// print(goodResult.isErr); // false
///
/// print(badResult.isOk); // false
/// print(badResult.isErr); // true
/// ```
///
/// ## Extracting contained values
///
/// These methods extract the contained value in a [Result] when it is the `ok` variant.
/// If the [Result] is `err`:
///
/// - [Result.expect] throws an exception with a provided custom message.
/// - [Result.unwrap] throws an exception with a generic message.
/// - [Result.unwrapOr] returns the provided default value.
/// - [Result.unwrapOrElse] returns the result of evaluating the provided function.
///
class Result<T, E> {
  /// The ok value.
  final T? _value;

  /// The error value.
  final E? _error;

  /// Private constructor that takes a value XOR an error.
  Result._(this._value, this._error) {
    if (_value != null && _error != null) {
      throw Exception("Neither a value nor an error has been passed");
    }

    if (_value == null && _error == null) {
      throw Exception("Both value and error has been passed");
    }
  }

  /// Creates an `ok` variant of [Result].
  ///
  /// That means that the value is the given one and the error is null.
  factory Result.ok(T value) => Result._(value, null);

  /// Creates an `err` variant of [Result].
  ///
  /// That means that the value is null and the error is the given one.
  factory Result.err(E error) => Result._(null, error);

  /// Destructure this instance of [Result] to get the value and the error. Note that one of them is null.
  ///
  /// This getter is useful if you don't use the extracting methods.
  ///
  /// # Examples
  ///
  /// ```
  /// final Result<int, String> x = Result.ok(10);
  /// final (value, error) = x.values;
  ///
  /// if (error != null) {
  ///   print("Error: $error");
  /// } else {
  ///   print("Value = $value");
  /// }
  /// ```
  (T?, E?) get values => (_value, _error);

  /// Returns `true` if the result is `ok`.
  ///
  /// # Examples
  ///
  /// ```
  /// final Result<int, String> x = Result.ok(-3);
  /// print(x.isOk); // true
  ///
  /// final Result<int, String> y = Result.err("Some error message");
  /// print(y.isOk); // false
  /// ```
  bool get isOk => _value != null;

  /// Returns `true` if the result is `err`
  ///
  /// # Examples
  ///
  /// ```
  /// final Result<int, String> x = Result.ok(-3);
  /// print(x.isErr); // false
  ///
  /// final Result<int, String> y = Result.err("Some error message");
  /// print(y.isErr); // true
  /// ```
  bool get isErr => _error != null;

  /// Returns the contained `ok` value.
  ///
  /// Because this method may throw an exception, its use is generally discouraged.
  /// Instead, prefer to use pattern matching and handle the `err` case explicitly,
  /// or call [Result.unwrapOr] or [Result.unwrapOrElse].
  ///
  /// # Exception
  ///
  /// Throws an exception if the value is an error, with the message provided by the `err` value.
  ///
  /// # Examples
  ///
  /// Basic usage:
  ///
  /// ```
  /// final Result<int, String> x = Result.ok(2);
  /// print(x.unwrap()); // 2
  ///
  /// final Result<int, String> y = Result.err("emergency failure");
  /// y.unwrap(); // Throws an exception with `emergency failure`
  /// ```
  T unwrap() {
    if (_value != null) return _value;

    throw Exception(
      "Called `Result.unwrap()` on an error value: \"$_error\"",
    );
  }

  /// Returns the contained `ok` value or a provided [defaultValue].
  ///
  /// Arguments passed to `unwrapOr` are eagerly evaluated;
  /// if you are passing the result of a function call, it is recommended to use [Result.unwrapOrElse],
  /// which is lazily evaluated.
  ///
  /// # Examples
  ///
  /// ```
  /// const default = 2;
  /// final Result<int, String> x = Result.ok(9);
  /// print(result.unwrapOr(default)); // 9
  ///
  /// final Result<int, String> y = Result.err("error");
  /// print(y.unwrapOr(default)); // 2
  /// ```
  T unwrapOr(T defaultValue) {
    if (_value != null) return _value;

    return defaultValue;
  }

  /// Returns the contained `ok` value or computes it from a closure.
  ///
  /// # Examples
  ///
  /// ```
  /// int count(String x) => x.length;
  /// print(Result.ok(2).unwrapOrElse(count)); // 2
  /// print(Result.err("foo").unwrapOrElse(count)); // 3
  /// ```
  T unwrapOrElse(T Function(E) callback) {
    if (_value != null) return _value;

    if (_error != null) return callback(_error);

    throw Exception(); // Unreachable
  }

  /// Returns the contained `ok` value.
  ///
  /// Because this method may throw an exception, its use is generally discouraged.
  /// Instead, prefer to use pattern matching and handle the `err` case explicitly,
  /// or call [Result.unwrapOr] or [Result.unwrapOrElse].
  ///
  /// # Exception
  ///
  /// Throws an exception if the value is an `err`, with a message including the passed [message],
  /// and the content of the error.
  ///
  /// # Examples
  ///
  /// ```
  /// final Result<int, String> x = Result.err("emergency failure");
  /// x.expect("Testing expect"); // Throws an exception with `Testing expect: emergency failure`
  /// ```
  ///
  /// # Recommended message style
  ///
  /// We recommend that `expect` messages are used to describe
  /// the reason you __expect__ the [Result] should be `ok`.
  T expect(String message) {
    if (_value != null) return _value;

    throw Exception("$message: $_error");
  }
}
