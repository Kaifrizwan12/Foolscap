const { ValidationError } = require('../utils/errors');

/// zod-based request validation. Reject first, process never — see
/// docs/SECURITY_PRACTICES.md. Validated output is attached to req.validated
/// so controllers never re-read raw req.body/params/query.
module.exports = function validate(schema) {
  return (req, res, next) => {
    const result = schema.safeParse({ body: req.body, params: req.params, query: req.query });
    if (!result.success) {
      return next(new ValidationError(result.error.flatten()));
    }
    req.validated = result.data;
    next();
  };
};
