const workspacesRepository = require('../repositories/workspaces.repository');
const invitesRepository = require('../repositories/invites.repository');

/// Business logic + permission checks beyond raw auth. See
/// docs/TECHNICAL_DEEP_DIVE.md section 2.6.
async function createWorkspace({ name, ownerUid }) {
  return workspacesRepository.create({ name, ownerUid });
}

async function createInvite({ workspaceId, uid }) {
  await workspacesRepository.assertMember(workspaceId, uid);
  const token = await invitesRepository.create(workspaceId);
  return { token };
}

async function acceptInvite({ token, uid }) {
  const workspaceId = await invitesRepository.consume(token);
  return workspacesRepository.addMember(workspaceId, uid, 'editor');
}

module.exports = { createWorkspace, createInvite, acceptInvite };
