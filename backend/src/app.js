const express = require('express');
const helmet = require('helmet');
const cors = require('cors');

const Env = require('./config/env');
const requestLogger = require('./middleware/requestLogger.middleware');
const errorHandler = require('./middleware/errorHandler.middleware');
const routes = require('./routes');

/// See docs/TECHNICAL_DEEP_DIVE.md section 2.2 — assembled once, exported,
/// started by a plain `app.listen` in index.js (no Cloud Functions).
const app = express();

app.use(helmet());
app.use(cors({ origin: Env.allowedOrigins.length ? Env.allowedOrigins : true }));
app.use(express.json({ limit: '2mb' }));
app.use(requestLogger);

app.use('/v1', routes);

// Mounted at root, not /v1 — serves HTML, not JSON. See
// docs/ARCHITECTURE.md section 6 and docs/TECHNICAL_DEEP_DIVE.md section 5.
app.use(require('./routes/pitchPage.routes'));

app.use(errorHandler); // must be last

module.exports = app;
