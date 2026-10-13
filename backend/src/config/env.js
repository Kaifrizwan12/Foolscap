/// Non-secret runtime config. Secrets (Gemini key, Firebase service account)
/// live in the host's env vars / secret manager, not here — see
/// docs/SECURITY_PRACTICES.md.
const Env = {
  port: Number(process.env.PORT) || 8080,
  allowedOrigins: (process.env.ALLOWED_ORIGINS || '').split(',').filter(Boolean),
};

module.exports = Env;
