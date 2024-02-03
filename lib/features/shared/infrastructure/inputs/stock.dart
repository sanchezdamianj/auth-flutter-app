import 'package:formz/formz.dart';

// Define input validation errors
enum StockError { empty, format, value }

// Extend FormzInput and provide the input type and error type.
class Stock extends FormzInput<int, StockError> {
  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  // Call super.pure to represent an unmodified form input.
  const Stock.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const Stock.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StockError.empty) return 'This field is required';
    if (displayError == StockError.value) {
      return 'Stock must be a number greater than zero';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StockError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return StockError.empty;
    }
    final isInteger = int.tryParse(value.toString()) ?? -1;
    if (isInteger == -1) return StockError.value;

    if (value < 0) return StockError.value;

    return null;
  }
}
