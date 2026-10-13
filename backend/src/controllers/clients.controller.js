const clientsService = require('../services/clients.service');
const { ok } = require('../utils/responseEnvelope');

exports.create = async (req, res, next) => {
  try {
    const { wid } = req.validated.params;
    const client = await clientsService.createClient({ workspaceId: wid, uid: req.uid, fields: req.validated.body });
    ok(res, client, 201);
  } catch (e) {
    next(e);
  }
};

exports.update = async (req, res, next) => {
  try {
    const { wid, cid } = req.validated.params;
    const client = await clientsService.updateClient({
      workspaceId: wid,
      clientId: cid,
      uid: req.uid,
      fields: req.validated.body,
    });
    ok(res, client);
  } catch (e) {
    next(e);
  }
};
