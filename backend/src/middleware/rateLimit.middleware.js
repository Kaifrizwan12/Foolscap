const rateLimit = require('express-rate-limit');

/// Shared factory for the public, unauthenticated endpoints (Pitch public
/// routes, invite accept) — see docs/SECURITY_PRACTICES.md.
module.exports = function makeRateLimiter({ windowMs = 60_000, max = 30 } = {}) {
  return rateLimit({ windowMs, max, standardHeaders: true, legacyHeaders: false });
};
