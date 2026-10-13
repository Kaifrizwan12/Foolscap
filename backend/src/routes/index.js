const router = require('express').Router();

/// One file per domain, mounted here. Add the next route group (references,
/// scripts, pitches, takes) per docs/FEATURE_PLAN.md phase order and record
/// it in docs/API_CONTRACTS.md before the frontend consumes it.
router.use(require('./workspaces.routes'));
router.use(require('./clients.routes'));

module.exports = router;
