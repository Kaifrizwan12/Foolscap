const { z } = require('zod');

/// Request schemas for workspace routes. See docs/API_CONTRACTS.md.
const createWorkspaceSchema = z.object({
  body: z.object({ name: z.string().min(1).max(80) }),
  params: z.object({}),
  query: z.object({}),
});

const acceptInviteSchema = z.object({
  body: z.object({}),
  params: z.object({ token: z.string().min(1) }),
  query: z.object({}),
});

module.exports = { createWorkspaceSchema, acceptInviteSchema };
