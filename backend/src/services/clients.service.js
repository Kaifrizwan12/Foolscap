const workspacesRepository = require('../repositories/workspaces.repository');
const clientsRepository = require('../repositories/clients.repository');

/// Brand Bible data entry (Phase 0.3). Linting logic is Phase 4 — see
/// docs/FEATURE_PLAN.md.
async function createClient({ workspaceId, uid, fields }) {
  await workspacesRepository.assertMember(workspaceId, uid);
  return clientsRepository.create(workspaceId, fields);
}

async function updateClient({ workspaceId, clientId, uid, fields }) {
  await workspacesRepository.assertMember(workspaceId, uid);
  return clientsRepository.update(workspaceId, clientId, fields);
}

module.exports = { createClient, updateClient };
