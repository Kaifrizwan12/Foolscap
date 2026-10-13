const router = require('express').Router();
const makeRateLimiter = require('../middleware/rateLimit.middleware');

/// NOT mounted under /v1 — this returns HTML, not JSON. The public pitch
/// link a client opens with no app installed renders here, server-side.
/// See docs/ARCHITECTURE.md section 6 and docs/TECHNICAL_DEEP_DIVE.md
/// section 5. Scaffolded ahead of Phase 3 (pitches don't exist yet) so the
/// route shape is settled; wire up pitchPageController once
/// services/pitches.service.js exists.
router.get('/pitch/:token', makeRateLimiter({ max: 30 }), (req, res) => {
  res.status(501).send('Not implemented yet — see docs/FEATURE_PLAN.md Phase 3.1');
});

module.exports = router;
