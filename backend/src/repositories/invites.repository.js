const { randomBytes } = require('crypto');
const { db, FieldValue } = require('../config/firebaseAdmin');
const { NotFoundError } = require('../utils/errors');

/// v1 invite flow: generate a link, anyone signed-in with the link joins as
/// editor — see docs/FEATURE_PLAN.md Phase 0.2 and
/// docs/ASSUMPTIONS_AND_DECISIONS.md on keeping this intentionally minimal.
async function create(workspaceId) {
  const token = randomBytes(16).toString('hex');
  await db.collection('invites').doc(token).set({
    workspaceId,
    createdAt: FieldValue.serverTimestamp(),
  });
  return token;
}

async function consume(token) {
  const ref = db.collection('invites').doc(token);
  const snap = await ref.get();
  if (!snap.exists) throw new NotFoundError('Invite not found or already used');
  const { workspaceId } = snap.data();
  await ref.delete();
  return workspaceId;
}

module.exports = { create, consume };
