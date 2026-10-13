const { db, FieldValue } = require('../config/firebaseAdmin');
const { NotFoundError } = require('../utils/errors');

/// Brand Bible documents. See docs/FIRESTORE_SCHEMA.md
/// workspaces/{wid}/clients/{cid}.
function collection(workspaceId) {
  return db.collection(`workspaces/${workspaceId}/clients`);
}

async function create(workspaceId, fields) {
  const ref = collection(workspaceId).doc();
  const data = {
    ...fields,
    brandBibleVersion: 1,
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  };
  await ref.set(data);
  return { id: ref.id, ...data };
}

async function update(workspaceId, clientId, fields) {
  const ref = collection(workspaceId).doc(clientId);
  const snap = await ref.get();
  if (!snap.exists) throw new NotFoundError('Client not found');
  // Bump brandBibleVersion on every save — see docs/FIRESTORE_SCHEMA.md on
  // why a script's linter result must record which version it was checked
  // against.
  await ref.update({
    ...fields,
    brandBibleVersion: FieldValue.increment(1),
    updatedAt: FieldValue.serverTimestamp(),
  });
  return { id: ref.id, ...(await ref.get()).data() };
}

module.exports = { create, update };
