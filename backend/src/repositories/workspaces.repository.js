const { db, FieldValue } = require('../config/firebaseAdmin');
const { NotFoundError, ForbiddenError } = require('../utils/errors');

/// Only this file touches Firestore for workspaces. See
/// docs/TECHNICAL_DEEP_DIVE.md section 2.7, docs/FIRESTORE_SCHEMA.md.
async function create({ name, ownerUid }) {
  const ref = db.collection('workspaces').doc();
  const workspace = {
    name,
    ownerUid,
    memberUids: [ownerUid],
    members: { [ownerUid]: { role: 'owner', joinedAt: FieldValue.serverTimestamp() } },
    plan: 'free',
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  };
  await ref.set(workspace);
  await db.collection('users').doc(ownerUid).set(
    { workspaceIds: FieldValue.arrayUnion(ref.id) },
    { merge: true },
  );
  return { id: ref.id, ...workspace };
}

async function getById(workspaceId) {
  const snap = await db.collection('workspaces').doc(workspaceId).get();
  if (!snap.exists) throw new NotFoundError('Workspace not found');
  return { id: snap.id, ...snap.data() };
}

async function assertMember(workspaceId, uid) {
  const workspace = await getById(workspaceId);
  if (!workspace.memberUids?.includes(uid)) {
    throw new ForbiddenError('You are not a member of this workspace');
  }
  return workspace;
}

async function addMember(workspaceId, uid, role = 'editor') {
  const ref = db.collection('workspaces').doc(workspaceId);
  await ref.update({
    memberUids: FieldValue.arrayUnion(uid),
    [`members.${uid}`]: { role, joinedAt: FieldValue.serverTimestamp() },
    updatedAt: FieldValue.serverTimestamp(),
  });
  await db.collection('users').doc(uid).set(
    { workspaceIds: FieldValue.arrayUnion(workspaceId) },
    { merge: true },
  );
  return getById(workspaceId);
}

module.exports = { create, getById, assertMember, addMember };
