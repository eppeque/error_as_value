import 'package:error_as_value/error_as_value.dart';
import 'package:test/test.dart';

void main() {
  test('values returns a non-null value and a null error with ok result', () {
    final Result<int, String> x = Result.ok(10);
    final (value, error) = x.values;

    expect(value, 10);
    expect(error, null);
  });

  test('values returns a null value and a non-null error with err result', () {
    const errorMessage = "error";
    final Result<int, String> x = Result.err(errorMessage);
    final (value, error) = x.values;

    expect(value, null);
    expect(error, errorMessage);
  });

  test('isOk returns true with a ok result', () {
    final Result<int, String> x = Result.ok(10);
    expect(x.isOk, true);
  });

  test('isOk returns false with an err result', () {
    final Result<int, String> x = Result.err("error");
    expect(x.isOk, false);
  });

  test('isErr returns true with an err result', () {
    final Result<int, String> x = Result.err("error");
    expect(x.isErr, true);
  });

  test('isErr returns false with a ok result', () {
    final Result<int, String> x = Result.ok(10);
    expect(x.isErr, false);
  });

  test('unwrap returns the contained value with an ok result', () {
    final Result<int, String> x = Result.ok(10);
    expect(x.unwrap(), 10);
  });

  test('unwrap throws an exception with an err result', () {
    final Result<int, String> x = Result.err("error");
    expect(() => x.unwrap(), throwsA(isA<Exception>()));
  });

  test('unwrapOr returns the contained value with an ok result', () {
    final Result<int, String> x = Result.ok(10);
    expect(x.unwrapOr(5), 10);
  });

  test('unwrapOr returns the default value with an err result', () {
    final Result<int, String> x = Result.err("error");
    expect(x.unwrapOr(5), 5);
  });

  test('unwrapOrElse returns the contained value with an ok result', () {
    int count(String x) => x.length;

    final Result<int, String> x = Result.ok(10);
    expect(x.unwrapOrElse(count), 10);
  });

  test('unwrapOrElse returns the computed value with an err result', () {
    int count(String x) => x.length;

    final Result<int, String> x = Result.err("error");
    expect(x.unwrapOrElse(count), 5);
  });

  test('expect returns the contained value with an ok result', () {
    final Result<int, String> x = Result.ok(10);
    expect(x.expect("Should work"), 10);
  });

  test('expect throws an exception with an err result', () {
    final Result<int, String> x = Result.err("error");
    expect(() => x.expect("Should not work"), throwsA(isA<Exception>()));
  });
}
