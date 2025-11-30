import { aiClient } from './ai_client';

const INTERVIEW_MODEL = 'gemini-2.0-flash';

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

interface InterviewInput {
    industry?: string;
    question: string;
    answer: string;
    metrics?: Record<string, any>;
}

interface InterviewOutput {
    overallScore: number;
    relevance: number;
    correctness: number;
    clarity: number;
    communication: number;
    softskills: number;
    issues: string[];
    improvements: string[];
    feedbackMessage: string;
}

export const analyzeInterview = async (input: InterviewInput): Promise<InterviewOutput> => {
    const systemInstruction = `
You are an expert, strict, but helpful interview coach.
Your goal is to evaluate the candidate's spoken answer to a specific interview question.

**LANGUAGE HANDLING:**
- The candidate might speak in English, Hindi, Hinglish (Hindi in English script), or a mix.
- **ALWAYS** analyze the content regardless of the language used.
- **ALWAYS** output your analysis and feedback in **ENGLISH**.
- If the candidate speaks a language other than English (e.g., pure Hindi), strictly evaluate the content but add a specific improvement suggestion: "Please try to answer in professional English for better global employability."

**SCORING GUIDELINES:**
1. **Relevance**: Did they answer *this specific question*? 
   - If they said "I don't know", "I don't remember", "I'm not sure", or gave up -> **Relevance MUST be < 30**.
   - If the answer is unrelated to the question -> **Relevance MUST be < 30**.
2. **Correctness**: Is the answer factually true and complete? Does it cover key aspects expected for this question?
3. **Communication**: Is the answer structured (STAR method)? Is it clear? (Ignore minor grammar errors if the meaning is clear).

**FEEDBACK REQUIREMENTS:**
- **Issues**: Be specific. What key points did they miss? Was the answer too vague?
- **Improvements**: Give concrete examples of what to add. E.g., "Mention specific tools like X or Y", "Use the STAR method: Situation, Task, Action, Result."
- **Feedback Message**: A warm, encouraging, 1-2 sentence summary directly to the candidate. 
    - If they said "I don't know", say: "That's completely okay! Honesty is better than guessing. Here's a quick tip on how to handle this question..."
    - If they did well, say: "Great job! You covered the key points well. To make it even better..."

Output strictly in JSON format:
{
  "overallScore": number (0-100),
  "relevance": number (0-100),
  "correctness": number (0-100),
  "clarity": number (0-100),
  "communication": number (0-100),
  "softskills": number (0-100),
  "issues": ["Critical missing point 1", "Structural issue 2", "Language note (if applicable)"],
  "improvements": ["Specific addition 1", "Structural advice 2"],
  "feedbackMessage": "Your personalized coaching message here."
}
`;

    const userPrompt = `
    Industry: ${input.industry || 'General'}
    Question: ${input.question}
    Candidate Answer: "${input.answer}"
    
    Metrics: ${JSON.stringify(input.metrics || {})}
    
    Analyze this answer now.
    `;

    try {
        const result = await aiClient.callModel({
            model: INTERVIEW_MODEL,
            systemInstruction,
            input: userPrompt,
            generationConfig: SAFE_GENERATION_CONFIG,
            safetySettings: STRICT_SAFETY_SETTINGS,
        });

        const cleanText = result.text.replace(/```json/g, '').replace(/```/g, '').trim();
        return JSON.parse(cleanText) as InterviewOutput;
    } catch (error) {
        console.error('Error analyzing interview:', error);
        throw new Error('Failed to analyze interview');
    }
};
