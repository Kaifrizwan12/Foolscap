const { randomUUID } = require('crypto');
const logger = require('../utils/logger');

/// Attaches a request ID and logs route/status/timing for every request.
/// See docs/SECURITY_PRACTICES.md logging rules — never logs headers/body.
module.exports = function requestLogger(req, res, next) {
  req.id = randomUUID();
  const startedAt = Date.now();

  res.on('finish', () => {
    logger.info({
      reqId: req.id,
      method: req.method,
      route: req.originalUrl,
      statusCode: res.statusCode,
      durationMs: Date.now() - startedAt,
    });
  });

  next();
};
