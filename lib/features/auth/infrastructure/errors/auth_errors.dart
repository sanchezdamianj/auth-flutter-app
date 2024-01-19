class ConnectionTimeOut implements Exception {}

class WrongCredential implements Exception {}

class Invalidtoken implements Exception {}

class CustomError implements Exception {
  final String message;
  final bool loggedRequired;
  // final int errorCode;
  // CustomError(this.message, this.errorCode);
  // Because if i need to logged the error i can use this
  CustomError(this.message, [this.loggedRequired = false]);
}
