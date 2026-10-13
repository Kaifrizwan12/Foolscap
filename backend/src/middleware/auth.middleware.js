const { admin } = require('../config/firebaseAdmin');
const { UnauthorizedError } = require('../utils/errors');

/// Verifies the Firebase ID token on every protected route and attaches
/// req.uid. See docs/TECHNICAL_DEEP_DIVE.md section 2.4 and
/// docs/SECURITY_PRACTICES.md.
module.exports = async function auth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return next(new UnauthorizedError('Missing token'));

  try {
    const decoded = await admin.auth().verifyIdToken(token);
    req.uid = decoded.uid;
    next();
  } catch (e) {
    next(new UnauthorizedError('Invalid or expired token'));
  }
};
