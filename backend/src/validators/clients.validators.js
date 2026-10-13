const { z } = require('zod');

/// Brand Bible fields. Data model lands in Phase 0.3, linting logic that
/// actually reads bannedWords/preferredTerms/approvedClaims is Phase 4 — see
/// docs/FEATURE_PLAN.md and docs/FIRESTORE_SCHEMA.md
/// workspaces/{wid}/clients/{cid}.
const brandBibleBody = z.object({
  // 1. Identity
  name: z.string().min(1).max(120),
  industry: z.string().max(80).optional(),
  logoUrl: z.string().url().optional(),
  brandColors: z.array(z.object({ name: z.string(), hex: z.string() })).max(20).optional(),
  platforms: z.array(z.enum(['tiktok', 'instagram', 'youtube', 'other'])).optional(),

  // 2. Voice & tone
  voiceAdjectives: z.array(z.string().max(40)).max(20).optional(),
  toneNotes: z.string().max(4000).optional(),
  voiceDoExamples: z.array(z.string().max(500)).max(50).optional(),
  voiceDontExamples: z.array(z.string().max(500)).max(50).optional(),
  formality: z.enum(['casual', 'neutral', 'formal']).optional(),

  // 3. Language rules — what the Phase 4 linter actually executes against
  bannedWords: z.array(z.string().max(80)).max(500).optional(),
  preferredTerms: z.array(z.object({ banned: z.string(), preferred: z.string() })).max(200).optional(),
  requiredDisclaimers: z
    .array(
      z.object({
        id: z.string(),
        text: z.string().max(500),
        placement: z.enum(['caption', 'on_screen', 'voiceover']),
      }),
    )
    .max(50)
    .optional(),
  approvedClaims: z
    .array(z.object({ id: z.string(), text: z.string().max(500), expiresAt: z.string().datetime().optional() }))
    .max(200)
    .optional(),
  competitorMentionPolicy: z.enum(['never', 'generic_only', 'allowed']).optional(),
  legalReviewRequired: z.boolean().optional(),

  // 4. Audience
  personas: z
    .array(
      z.object({
        id: z.string(),
        label: z.string().max(80),
        ageRange: z.string().max(20).optional(),
        painPoints: z.array(z.string().max(200)).max(20),
        primaryPlatform: z.enum(['tiktok', 'instagram', 'youtube', 'other']).optional(),
      }),
    )
    .max(20)
    .optional(),

  // 5. Product / model specs
  products: z
    .array(
      z.object({
        id: z.string(),
        name: z.string().max(120),
        keyFeatures: z.array(z.string().max(200)).max(20),
        priceNote: z.string().max(200).optional(),
        availabilityNote: z.string().max(200).optional(),
      }),
    )
    .max(100)
    .optional(),
  modelSpecs: z.string().max(4000).optional(), // legacy free-text overflow, see docs/FIRESTORE_SCHEMA.md

  // 6. Content pillars
  pillars: z
    .array(
      z.object({
        id: z.string(),
        label: z.string().max(80),
        color: z.string(),
        description: z.string().max(300).optional(),
        targetFrequency: z.string().max(40).optional(),
      }),
    )
    .max(50)
    .optional(),

  // 7. Competitors (config only — not scraped data, see docs/FIRESTORE_SCHEMA.md)
  competitors: z
    .array(z.object({ id: z.string(), name: z.string().max(120), handle: z.string().optional(), platform: z.enum(['tiktok', 'instagram', 'youtube', 'other']).optional() }))
    .max(100)
    .optional(),
});

const createClientSchema = z.object({
  body: brandBibleBody,
  params: z.object({ wid: z.string().min(1) }),
  query: z.object({}),
});

const updateClientSchema = z.object({
  body: brandBibleBody.partial(),
  params: z.object({ wid: z.string().min(1), cid: z.string().min(1) }),
  query: z.object({}),
});

module.exports = { createClientSchema, updateClientSchema };
