import * as functions from 'firebase-functions';

const rateLimitMap = new Map<string, number[]>();
const WINDOW_MS = 60 * 1000; // 1 minute
const MAX_REQUESTS = 20;

export const rateLimit = (req: functions.https.Request, res: functions.Response, next: () => void) => {
    const ip = req.ip || 'unknown';
    const now = Date.now();

    const requests = rateLimitMap.get(ip) || [];
    const recentRequests = requests.filter(time => now - time < WINDOW_MS);

    if (recentRequests.length >= MAX_REQUESTS) {
        res.status(429).send({ error: 'Too many requests, please try again later.' });
        return;
    }

    recentRequests.push(now);
    rateLimitMap.set(ip, recentRequests);

    // Cleanup old entries periodically (simple optimization)
    if (Math.random() < 0.01) {
        for (const [key, times] of rateLimitMap.entries()) {
            const validTimes = times.filter(t => now - t < WINDOW_MS);
            if (validTimes.length === 0) {
                rateLimitMap.delete(key);
            } else {
                rateLimitMap.set(key, validTimes);
            }
        }
    }

    next();
};
