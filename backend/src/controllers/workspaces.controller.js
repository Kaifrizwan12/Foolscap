const workspacesService = require('../services/workspaces.service');
const { ok } = require('../utils/responseEnvelope');

/// Controllers translate HTTP <-> service calls only — no business logic.
/// See docs/TECHNICAL_DEEP_DIVE.md section 2.5.
exports.create = async (req, res, next) => {
  try {
    const { name } = req.validated.body;
    const workspace = await workspacesService.createWorkspace({ name, ownerUid: req.uid });
    ok(res, workspace, 201);
  } catch (e) {
    next(e);
  }
};

exports.createInvite = async (req, res, next) => {
  try {
    const { wid } = req.params;
    const invite = await workspacesService.createInvite({ workspaceId: wid, uid: req.uid });
    ok(res, invite, 201);
  } catch (e) {
    next(e);
  }
};

exports.acceptInvite = async (req, res, next) => {
  try {
    const { token } = req.validated.params;
    const workspace = await workspacesService.acceptInvite({ token, uid: req.uid });
    ok(res, workspace);
  } catch (e) {
    next(e);
  }
};
