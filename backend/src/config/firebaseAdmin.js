const admin = require('firebase-admin');

/// Running on a plain Node host (not Cloud Functions), there is no ambient
/// GCP identity — the service account must be provided explicitly via env
/// vars. Never commit the service account JSON itself (see
/// docs/SECURITY_PRACTICES.md and .gitignore). Store it as a base64-encoded
/// env var on the host (Render/Railway/Vercel/etc. all support multi-line
/// or base64 secrets this way) and decode it here.
if (!admin.apps.length) {
  const encoded = process.env.FIREBASE_SERVICE_ACCOUNT_BASE64;
  if (!encoded) {
    throw new Error(
      'FIREBASE_SERVICE_ACCOUNT_BASE64 is not set — see backend/.env.example and docs/ENVIRONMENTS.md',
    );
  }
  const serviceAccount = JSON.parse(Buffer.from(encoded, 'base64').toString('utf8'));

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  });
}

/// Only repositories import this module — see docs/TECHNICAL_DEEP_DIVE.md
/// section 2, layer boundary table.
module.exports = {
  admin,
  db: admin.firestore(),
  storage: admin.storage(),
  FieldValue: admin.firestore.FieldValue,
};
