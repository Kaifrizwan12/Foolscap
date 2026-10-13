/// The ONLY config module that knows the Gemini key exists. Consumed only by
/// services/geminiAnalysis.service.js (Phase 1) — see docs/ARCHITECTURE.md
/// section 2 (the AI firewall) and docs/SECURITY_PRACTICES.md.
///
/// TODO(phase-1): initialize the Gemini client here once GEMINI_API_KEY has
/// been set in the backend host's own env var / secret manager (Render,
/// Railway, Vercel, etc. — see backend/.env.example), e.g.:
///   const { GoogleGenerativeAI } = require('@google/generative-ai');
///   const client = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
/// Do not read process.env.GEMINI_API_KEY anywhere outside this file.
module.exports = {
  // getClient() { ... }
};
