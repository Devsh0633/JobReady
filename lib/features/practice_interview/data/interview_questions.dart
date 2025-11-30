// Industry-Specific Interview Questions

const List<String> itSoftwareQuestions = [
  "Tell me about a project where you used Java, Python, or C++.",
  "Explain Object-Oriented Programming (OOP) concepts with examples.",
  "What is the difference between SQL and NoSQL databases?",
  "How do you handle a bug you can't fix immediately?",
  "Describe the software development life cycle (SDLC).",
  "What is the importance of version control systems like Git?",
  "Explain the concept of RESTful APIs.",
  "How do you optimize code for better performance?",
  "Tell me about a time you had a conflict with a team member.",
  "What are your favorite development tools and why?",
  "Explain the difference between a process and a thread.",
  "How do you stay updated with the latest technology trends?",
];

const List<String> salesMarketingQuestions = [
  "Sell me this pen.",
  "How do you handle a customer who says 'I'm not interested'?",
  "Describe a time you met or exceeded a difficult sales target.",
  "What is your approach to lead generation?",
  "How do you handle rejection in sales?",
  "Explain the difference between B2B and B2C sales.",
  "How do you build long-term relationships with clients?",
  "What social media platforms are best for marketing a B2B product?",
  "Describe a successful marketing campaign you analyzed.",
  "How do you prioritize your sales pipeline?",
  "What motivates you to sell?",
  "How would you handle a client who is unhappy with the product?",
];

const List<String> coreEngineeringQuestions = [
  "Explain the difference between stress and strain.",
  "What safety protocols do you follow on a site or in a lab?",
  "Describe a project where you applied core engineering principles.",
  "How do you ensure quality control in a production line?",
  "What is the importance of thermodynamics in your field?",
  "Explain the working principle of a 4-stroke engine (or relevant machine).",
  "How do you handle equipment failure during a critical operation?",
  "Describe your experience with CAD software.",
  "How do you manage project timelines in an engineering project?",
  "What is the role of sustainability in modern engineering?",
  "Explain a complex technical concept to a non-technical person.",
  "How do you troubleshoot a system that is not performing as expected?",
];

const List<String> bpoSupportQuestions = [
  "How would you handle an angry customer on the phone?",
  "What does 'good customer service' mean to you?",
  "How do you handle multiple chat sessions simultaneously?",
  "Describe a time you went above and beyond for a customer.",
  "How do you deal with a repetitive task without losing focus?",
  "What would you do if you didn't know the answer to a customer's question?",
  "How do you handle high-pressure situations?",
  "Explain the importance of empathy in customer support.",
  "How do you ensure accurate data entry while working fast?",
  "What are your strengths in verbal communication?",
  "How do you handle a customer who is demanding a refund you can't give?",
  "Why do you want to work in the BPO industry?",
];

const List<String> hrQuestions = [
  "Tell me about yourself.",
  "What are your greatest strengths and weaknesses?",
  "Where do you see yourself in 5 years?",
  "Why should we hire you?",
  "Describe a challenge you overcame.",
  "How do you handle stress and pressure?",
  "What motivates you?",
  "Why do you want to leave your current job?",
  "What are your salary expectations?",
  "Do you have any questions for us?",
];

final Map<String, List<String>> questionsByIndustry = {
  "IT & Software": itSoftwareQuestions,
  "Sales & Marketing": salesMarketingQuestions,
  "Core Engineering": coreEngineeringQuestions,
  "BPO & Support": bpoSupportQuestions,
};
