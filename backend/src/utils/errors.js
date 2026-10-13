/// One error hierarchy, mirrored by the Flutter AppException hierarchy on
/// the other side of the wire — see docs/TECHNICAL_DEEP_DIVE.md section 2.8.
class AppError extends Error {
  constructor(message, { statusCode = 500, code = 'INTERNAL_ERROR', details } = {}) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.details = details;
  }
}

class ValidationError extends AppError {
  constructor(details, message = 'Check your input and try again.') {
    super(message, { statusCode: 422, code: 'VALIDATION_ERROR', details });
  }
}

class UnauthorizedError extends AppError {
  constructor(message = 'Please sign in again.') {
    super(message, { statusCode: 401, code: 'UNAUTHORIZED' });
  }
}

class ForbiddenError extends AppError {
  constructor(message = 'You do not have access to this.') {
    super(message, { statusCode: 403, code: 'FORBIDDEN' });
  }
}

class NotFoundError extends AppError {
  constructor(message = 'Not found.') {
    super(message, { statusCode: 404, code: 'NOT_FOUND' });
  }
}

module.exports = { AppError, ValidationError, UnauthorizedError, ForbiddenError, NotFoundError };
