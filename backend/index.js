const app = require('./src/app');
const Env = require('./src/config/env');

/// Plain Node.js server — no Cloud Functions. Deployable to any Node host
/// (Render, Railway, Fly.io, Vercel's Node runtime, a VPS, etc.). See
/// docs/ARCHITECTURE.md and docs/ASSUMPTIONS_AND_DECISIONS.md.
app.listen(Env.port, () => {
  // eslint-disable-next-line no-console
  console.log(`Foolscap backend listening on port ${Env.port}`);
});
