/// Single response shape for the whole API — see docs/API_CONTRACTS.md and
/// docs/TECHNICAL_DEEP_DIVE.md section 2.8.
function ok(res, data, statusCode = 200) {
  res.status(statusCode).json({ ok: true, data });
}

module.exports = { ok };
