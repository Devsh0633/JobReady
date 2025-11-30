import { aiClient } from './ai_client';

const WRITER_MODEL = 'gemini-2.0-flash';

const SAFE_GENERATION_CONFIG = {
    temperature: 0.3,
    topP: 0.8,
    topK: 32,
    maxOutputTokens: 1024,
};

const STRICT_SAFETY_SETTINGS = [
    {
        category: 'HARM_CATEGORY_HATE_SPEECH',
        threshold: 'BLOCK_MEDIUM_AND_ABOVE',
    },
    {
        category: 'HARM_CATEGORY_HARASSMENT',
        threshold: 'BLOCK_MEDIUM_AND_ABOVE',
    },
    {
        category: 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
        threshold: 'BLOCK_LOW_AND_ABOVE',
    },
    {
        category: 'HARM_CATEGORY_DANGEROUS_CONTENT',
        threshold: 'BLOCK_MEDIUM_AND_ABOVE',
    },
];

interface WriterInput {
    jobRole: string;
    companyName: string;
    tone: string;
    context: string;
}

interface WriterOutput {
    subject: string;
    body: string;
    suggestions: string[];
}

export const generateContent = async (input: WriterInput): Promise<WriterOutput> => {
    const systemInstruction = `
You are JobReady's application writer. 
- Write crisp, ATS-friendly cold emails.
- Use clear subject line and structured body.
- NEVER fabricate job titles, companies, or numbers.
- If user input is too vague, ask for clarification instead of making things up.
- Output strictly in JSON format with fields: subject, body, suggestions.
`;

    const userPrompt = `
    Role: ${input.jobRole}
    Company: ${input.companyName}
    Tone: ${input.tone}
    Context: ${input.context}
    
    Generate the email now.
    `;

    try {
        const result = await aiClient.callModel({
            model: WRITER_MODEL,
            systemInstruction,
            input: userPrompt,
            generationConfig: SAFE_GENERATION_CONFIG,
            safetySettings: STRICT_SAFETY_SETTINGS,
        });

        const cleanText = result.text.replace(/```json/g, '').replace(/```/g, '').trim();
        return JSON.parse(cleanText) as WriterOutput;
    } catch (error) {
        console.error('Error generating content:', error);
        console.error('Error details:', JSON.stringify(error, null, 2));
        throw new Error('Failed to generate content');
    }
};

export const rewriteContent = async (text: string, mode: 'shorten' | 'expand' | 'formal' | 'simplify'): Promise<WriterOutput> => {
    const prompts = {
        shorten: 'Rewrite to be more concise and direct.',
        expand: 'Rewrite to be more detailed and persuasive.',
        formal: 'Rewrite to be strictly professional and formal.',
        simplify: 'Rewrite using simple, easy-to-understand language.',
    };

    const systemInstruction = `
You are an expert editor.
- ${prompts[mode]}
- Maintain the core message but adjust the style.
- Output strictly in JSON format with fields: subject, body, suggestions.
`;

    try {
        const result = await aiClient.callModel({
            model: WRITER_MODEL,
            systemInstruction,
            input: `Original Text:\n"${text}"`,
            generationConfig: SAFE_GENERATION_CONFIG,
            safetySettings: STRICT_SAFETY_SETTINGS,
        });

        const cleanText = result.text.replace(/```json/g, '').replace(/```/g, '').trim();
        return JSON.parse(cleanText) as WriterOutput;
    } catch (error) {
        console.error(`Error rewriting content (${mode}):`, error);
        throw new Error(`Failed to rewrite content: ${mode}`);
    }
};
