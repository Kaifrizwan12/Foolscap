const router = require('express').Router();
const auth = require('../middleware/auth.middleware');
const validate = require('../middleware/validate.middleware');
const { createClientSchema, updateClientSchema } = require('../validators/clients.validators');
const controller = require('../controllers/clients.controller');

router.post('/workspaces/:wid/clients', auth, validate(createClientSchema), controller.create);
router.patch('/workspaces/:wid/clients/:cid', auth, validate(updateClientSchema), controller.update);

module.exports = router;
