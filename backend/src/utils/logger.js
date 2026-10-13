/// Structured JSON logs. Never log tokens, the Gemini key, raw video bytes,
/// or full transcript text — see docs/SECURITY_PRACTICES.md.
function log(level, fields) {
  // eslint-disable-next-line no-console
  console[level === 'error' ? 'error' : 'log'](JSON.stringify({ level, time: new Date().toISOString(), ...fields }));
}

module.exports = {
  info: (fields) => log('info', fields),
  warn: (fields) => log('warn', fields),
  error: (fields) => log('error', fields),
};
