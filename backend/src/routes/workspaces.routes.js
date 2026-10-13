const router = require('express').Router();
const auth = require('../middleware/auth.middleware');
const validate = require('../middleware/validate.middleware');
const { createWorkspaceSchema, acceptInviteSchema } = require('../validators/workspaces.validators');
const controller = require('../controllers/workspaces.controller');

router.post('/workspaces', auth, validate(createWorkspaceSchema), controller.create);
router.post('/workspaces/:wid/invites', auth, controller.createInvite);
router.post('/workspaces/invites/:token/accept', auth, validate(acceptInviteSchema), controller.acceptInvite);

module.exports = router;
