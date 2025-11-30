# JobReady

**Your AI-Powered Interview Preparation Companion**

> [!IMPORTANT]
> **⚠️ NOTICE: Hackathon Submission Snapshot**
>
> This repository contains a **frozen snapshot** of the JobReady application, released under Apache License 2.0 solely for the purpose of the **IIT Bombay E-Summit 2025 iHack Google AdMob Challenge**.
>
> **Development Timeline:**
> *   **Start Date:** November 26, 2025 (Commenced specifically for this challenge after receiving confirmation from authorities).
> *   **Submission Date:** November 30, 2025 (Codebase initialized in this repository for submission).
>
> **Active development of JobReady continues in a private, proprietary repository.**
> Future versions, updates, backend services, and AI models are **NOT** open source and remain the exclusive intellectual property of Devendra Sharma.
>
> The "JobReady" name and logo are trademarks of Devendra Sharma and may not be used in derivative works without permission.

JobReady is a comprehensive mobile application designed to help job seekers prepare for interviews, optimize their resumes, and craft perfect job applications using the power of Generative AI.

## 🚀 Features

*   **AI Resume Parsing:** Instantly extracts skills, experience, and education from PDF resumes.
*   **Application Writer:** Generates tailored cover letters, cold emails, and LinkedIn notes based on your profile and the job description.
*   **AI Interview Coach:** Simulates real interview scenarios with personalized questions generated from your resume.
*   **Voice Analysis:** Analyzes your spoken answers for relevance, clarity, and confidence using AI.
*   **Community Hub:** Connect with other job seekers, share tips, and discuss interview strategies.
*   **Real-time Dashboard:** Track your progress and interview readiness score.

## 🛠️ Tech Stack

*   **Framework:** Flutter (Dart)
*   **Backend:** Firebase (Auth, Firestore, Storage, Cloud Functions)
*   **AI Model:** Google Gemini (via `google_generative_ai`)
*   **State Management:** Provider / Riverpod
*   **Updates:** Shorebird CodePush

## 📦 Installation

This repository contains the source code for the JobReady application.

**Note:** This project relies on proprietary backend services and API keys which are **not included** in this public repository for security reasons.

To run this project locally, you would need to:
1.  Set up your own Firebase project.
2.  Obtain a Google Gemini API key.
3.  Configure `lib/features/ai/ai_env.dart` and `firebase_options.dart`.

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---
*Submitted for the Google AdMob Challenge 2025*
