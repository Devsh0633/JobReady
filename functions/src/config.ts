import * as functions from 'firebase-functions';
import * as dotenv from 'dotenv';

dotenv.config();

// Try to get API key from multiple sources
const getApiKey = () => {
    // 1. Try Firebase Config (Production)
    const configKey = functions.config().gemini?.api_key;
    if (configKey) return configKey;

    // 2. Try Environment Variable (Local/Development)
    const envKey = process.env.GEMINI_API_KEY;
    if (envKey) return envKey;

    return '';
};

const apiKey = getApiKey();

if (!apiKey) {
    console.error('CRITICAL: GEMINI_API_KEY not found in functions.config() or .env');
} else {
    console.log(`Config loaded. API Key present: ${apiKey.substring(0, 5)}...`);
}

export const config = {
    geminiApiKey: apiKey,
    environment: process.env.NODE_ENV || 'development',
};
