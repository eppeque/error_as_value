# Error as value

A Dart library that enables you to use error as values instead of throwing exceptions.

## Getting started

### 1. Add the dependency

You can add this library as a dependency to your project with the following addition to your `pubspec.yaml` file:

```yaml
error_as_value:
  git: https://github.com/eppeque/error_as_value
```

### 2. Import this package in your code

You can import this library in your code with following line:

```dart
import 'package:error_as_value/error_as_value.dart';
```

You're now ready to use the `Result` type in your file.

## Usage

```dart
Result<double, String> divide(int a, int b) {
    if (b == 0) {
        return Result.err("Division by zero");
    }

    return Result.ok(a / b);
}

void main() {
    final (value, error) = divide(10, 2).values;

    if (error != null) {
        print(error); // Prints "Division by zero"
    } else {
        print(value); // Prints 5
    }
}
```

**Enjoy!**
