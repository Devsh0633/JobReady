import { config } from './config';
import { GoogleGenerativeAI } from '@google/generative-ai';


// Initialize client lazily or check for key
const genAI = config.geminiApiKey ? new GoogleGenerativeAI(config.geminiApiKey) : null;

export class AiClient {
    async callModel(req: {
        model: string;
        systemInstruction?: string;
        input: string;
        generationConfig?: any;
        safetySettings?: any;
    }) {
        console.log('AiClient.callModel started');

        if (!genAI) {
            console.error('GoogleGenerativeAI client not initialized. Missing API Key.');
            throw new Error('Backend configuration error: Gemini API key missing.');
        }

        const { model, systemInstruction, input, generationConfig, safetySettings } = req;
        console.log(`Requesting model: ${model}`);

        try {
            const modelInstance = genAI.getGenerativeModel({
                model,
                generationConfig,
                safetySettings,
            });

            // Prepend system instruction to input if provided
            const fullPrompt = systemInstruction
                ? `${systemInstruction}\n\n${input}`
                : input;

            console.log('Sending request to Gemini...');
            const result = await modelInstance.generateContent(fullPrompt);
            const response = await result.response;
            const text = response.text();
            console.log('Gemini response received successfully');

            return { raw: result, text };
        } catch (error: any) {
            console.error('Error calling Gemini API:', error);
            console.error('Error message:', error.message);
            console.error('Error stack:', error.stack);
            if (error.response) {
                console.error('Gemini API Error Response:', JSON.stringify(error.response));
            }
            throw error;
        }
    }
}

export const aiClient = new AiClient();
