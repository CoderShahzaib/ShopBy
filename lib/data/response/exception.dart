class AppExceptions implements Exception {
  final String _prefix;
  final String _message;

  AppExceptions(this._prefix, this._message);
  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppExceptions {
  FetchDataException(String message)
      : super("Error During Communication: ", message);
}

class BadRequestException extends AppExceptions {
  BadRequestException(String message) : super("Invalid Request: ", message);
}

class UnauthorisedException extends AppExceptions {
  UnauthorisedException(String message) : super("Unauthorised: ", message);
}

class InvalidInputException extends AppExceptions {
  InvalidInputException(String message) : super("Invalid Input: ", message);
}

class ServerException extends AppExceptions {
  ServerException(String message) : super("Server Error: ", message);
}

class CacheException extends AppExceptions {
  CacheException(String message) : super("Cache Error: ", message);
}

class NoInternetException extends AppExceptions {
  NoInternetException(String message) : super("No Internet: ", message);
}

class UnexpectedException extends AppExceptions {
  UnexpectedException(String message) : super("Unexpected Error: ", message);
}

class TimeoutException extends AppExceptions {
  TimeoutException(String message) : super("Timeout Error: ", message);
}

class NoDataException extends AppExceptions {
  NoDataException(String message) : super("No Data: ", message);
}
