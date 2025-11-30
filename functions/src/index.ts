import * as functions from 'firebase-functions';
import cors = require('cors');
import { generateContent, rewriteContent } from './writer';
import { analyzeInterview } from './interview';
import { rateLimit } from './middleware';

const corsHandler = cors({ origin: true });

// Helper to wrap logic with CORS and Rate Limiting
const runWithMiddleware = (req: functions.https.Request, res: functions.Response, handler: (body: any) => Promise<any>) => {
    corsHandler(req, res, () => {
        rateLimit(req, res, async () => {
            try {
                if (req.method !== 'POST') {
                    res.status(405).send({ error: 'Method Not Allowed' });
                    return;
                }
                const result = await handler(req.body);
                res.status(200).send(result);
            } catch (error: any) {
                console.error('Function error:', error);
                res.status(500).send({ error: error.message || 'Internal Server Error' });
            }
        });
    });
};

// --- Writer Endpoints ---

export const writerGenerate = functions.https.onRequest((req, res) => {
    runWithMiddleware(req, res, async (body) => {
        const { jobRole, companyName, tone, context } = body;
        if (!jobRole || !companyName || !tone) {
            throw new Error('Missing required fields: jobRole, companyName, tone');
        }
        return await generateContent({ jobRole, companyName, tone, context: context || '' });
    });
});

export const writerShorten = functions.https.onRequest((req, res) => {
    runWithMiddleware(req, res, async (body) => {
        if (!body.text) throw new Error('Missing required field: text');
        return await rewriteContent(body.text, 'shorten');
    });
});

export const writerExpand = functions.https.onRequest((req, res) => {
    runWithMiddleware(req, res, async (body) => {
        if (!body.text) throw new Error('Missing required field: text');
        return await rewriteContent(body.text, 'expand');
    });
});

export const writerFormal = functions.https.onRequest((req, res) => {
    runWithMiddleware(req, res, async (body) => {
        if (!body.text) throw new Error('Missing required field: text');
        return await rewriteContent(body.text, 'formal');
    });
});

export const writerSimplify = functions.https.onRequest((req, res) => {
    runWithMiddleware(req, res, async (body) => {
        if (!body.text) throw new Error('Missing required field: text');
        return await rewriteContent(body.text, 'simplify');
    });
});

// --- Interview Endpoint ---

export const interviewAnalyze = functions.https.onRequest((req, res) => {
    runWithMiddleware(req, res, async (body) => {
        const { question, answer, industry, metrics } = body;
        if (!question || !answer) {
            throw new Error('Missing required fields: question, answer');
        }
        return await analyzeInterview({ question, answer, industry, metrics });
    });
});

// --- Healthcheck ---

export const healthcheck = functions.https.onRequest((req, res) => {
    corsHandler(req, res, () => {
        res.status(200).send({ status: 'ok', timestamp: new Date().toISOString() });
    });
});
