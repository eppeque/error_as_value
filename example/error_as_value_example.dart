import 'package:error_as_value/error_as_value.dart';

void main() {
  final Result<int, String> x = Result.ok(-3);
  print(x.isOk); // true
}
