const logger = require('../utils/logger');

/// Single error envelope for the whole API. Must be registered last in
/// app.js. See docs/TECHNICAL_DEEP_DIVE.md section 2.8, docs/API_CONTRACTS.md.
// eslint-disable-next-line no-unused-vars
module.exports = function errorHandler(err, req, res, next) {
  const statusCode = err.statusCode || 500;

  logger.error({
    reqId: req.id,
    route: req.originalUrl,
    statusCode,
    code: err.code,
    message: err.message,
  });

  res.status(statusCode).json({
    ok: false,
    error: {
      code: err.code || 'INTERNAL_ERROR',
      message: statusCode === 500 ? 'Something went wrong. Try again.' : err.message,
      details: err.details,
    },
  });
};
