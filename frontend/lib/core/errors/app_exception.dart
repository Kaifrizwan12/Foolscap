/// Single error vocabulary the whole app deals in. Every repository/controller
/// converts transport/Firebase errors into one of these — see
/// docs/TECHNICAL_DEEP_DIVE.md section 1.2 and docs/SECURITY_PRACTICES.md.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  factory AppException.from(Object error) {
    if (error is AppException) return error;
    return ServerException(error.toString());
  }
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Please sign in again.']);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'You do not have access to this.']);
}

class ValidationException extends AppException {
  const ValidationException(this.fieldErrors, [super.message = 'Check the form and try again.']);
  final Map<String, String> fieldErrors;
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found.']);
}

class NetworkTimeoutException extends AppException {
  const NetworkTimeoutException([super.message = 'The connection timed out.']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Something went wrong. Try again.']);
}
