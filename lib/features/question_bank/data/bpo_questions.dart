import 'question_model.dart';

const List<QuestionItem> bpoQuestions = [
  QuestionItem(
    id: 'BPO-Q1',
    industry: 'BPO & Support',
    topic: 'Inbound vs Outbound Process',
    question: '''What is the difference between Inbound and Outbound Process?
(Asked at: Teleperformance, Concentrix)''',
    shortAnswer: '''Inbound processes involve receiving calls from customers who need help—like queries, complaints, or support. Outbound processes involve agents calling customers for follow-ups, sales, surveys, or confirmations. Inbound focuses on customer service; outbound focuses on communication and persuasion. Both require strong communication and process understanding.''',
    deepExplanation: '''Inbound agents handle problem-solving, soft skills, empathy, and resolution metrics like CSAT and FCR. Outbound agents need persuasion skills, objection handling, and compliance with DNC (Do Not Call) norms. Inbound calls usually have defined SLAs; outbound may target sales, lead conversion, or appointment setting. Both require CRM tools and clear documentation.

Example
Amazon CS (Inbound) vs Credit card sales (Outbound).

Mistakes
Thinking outbound = only sales


Not understanding SLA difference


Tips
Emphasize multitasking + calm tone.


Resources
HubSpot Customer Support Training''',
  ),
  QuestionItem(
    id: 'BPO-Q2',
    industry: 'BPO & Support',
    topic: 'Handling Angry Customers',
    question: '''How do you handle an angry customer?
(Asked at: Amazon, Genpact, Infosys BPM)''',
    shortAnswer: '''I start by actively listening without interrupting. I acknowledge the customer’s frustration, apologize for their experience, and reassure them I will resolve the issue. I stay calm, use positive language, and follow a step-by-step approach to fix the problem. Finally, I confirm resolution and thank them for their patience.''',
    deepExplanation: '''Handling anger requires emotional intelligence. Customers want validation first, solution second. Techniques: LEAP (Listen, Empathize, Apologize, Provide Solution). Keeping a steady tone helps de-escalate. Always check facts, offer alternatives, and avoid blame. Document accurately for follow-up. Never take comments personally—focus on resolution.

Example
“I understand this is frustrating. Let me quickly check this for you.”

Mistakes
Interrupting


Defensive responses


Tips
Smile while speaking—it reflects in voice.


Resources
Dale Carnegie: Handling Difficult Conversations''',
  ),
  QuestionItem(
    id: 'BPO-Q3',
    industry: 'BPO & Support',
    topic: 'Ticketing System',
    question: '''What is a Ticketing System? Name a few tools.
(Asked at: Tech Support L1)''',
    shortAnswer: '''A ticketing system tracks customer issues from start to resolution. Each query becomes a “ticket” with priority, status, and assigned agent. Common tools include Zendesk, Freshdesk, Jira Service Desk, and ServiceNow. Ticketing systems improve workflow, reduce delays, and ensure accountability.''',
    deepExplanation: '''Each ticket stores history, customer details, and action logs. SLAs define how fast a ticket must be resolved. Priority = urgency + impact. Ticket categorization helps route to the correct department. Analytics track agent productivity, FCR rates, and customer satisfaction. Used in voice, chat, and email support.

Example
Customer’s refund issue logged under “Billing > Refund Request”.

Mistakes
Incorrect ticket categorization


Tips
Always update ticket notes after each interaction.


Resources
Zendesk “Agent Fundamentals”''',
  ),
  QuestionItem(
    id: 'BPO-Q4',
    industry: 'BPO & Support',
    topic: 'SLA, TAT, AHT, CSAT',
    question: '''What do you know about SLA, TAT, AHT, and CSAT?
(Asked at: Wipro BPM, Concentrix)''',
    shortAnswer: '''SLAs are service commitments like response time.
 TAT is turnaround time for resolving requests.
 AHT is average handling time per interaction.
 CSAT measures customer satisfaction.
 These metrics help improve service quality and efficiency.''',
    deepExplanation: '''SLA violations reduce customer trust. TAT reflects internal efficiency. AHT measures productivity—too high = slow, too low = rushed conversations. CSAT is gathered through customer feedback surveys. Agents must balance all: good speed + correct resolution + a positive experience.

Example
SLA: Respond within 24 hours.
 AHT target: 4 minutes per call.

Mistakes
Reducing AHT at the cost of accuracy


Tips
Use call control phrases to maintain pace.


Resources
ICMI Customer Service Metrics Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q5',
    industry: 'BPO & Support',
    topic: 'Tell me about yourself',
    question: '''Tell me about yourself (BPO Version).
(Most asked question at all BPOs)''',
    shortAnswer: '''I am a communication-driven person with strong listening skills and patience. I enjoy helping people and solving problems. I have good command over English, can multitask, and adapt quickly to new tools. I’m looking to join a BPO where I can grow my skills, deliver excellent customer service, and build my career in the support industry.''',
    deepExplanation: '''They are testing: communication clarity, confidence, tone, grammar, and structure. A perfect BPO introduction includes: communication strength, empathy, patience, ability to handle pressure, openness to shifts, and motivation to learn. Do not mention weaknesses or unrelated hobbies.

Example
Use a 40–50 second structured answer.

Mistakes
Speaking too long


Overly personal details


Tips
Keep it crisp, warm, and professional.


Resources
YouTube: Concentrix HR Interview examples''',
  ),
  QuestionItem(
    id: 'BPO-Q6',
    industry: 'BPO & Support',
    topic: 'Handling Back-to-Back Calls',
    question: '''How do you handle back-to-back calls?
(Asked at: Teleperformance & International Voice)''',
    shortAnswer: '''I stay calm, maintain consistent energy, and reset mentally after each call. I take brief notes, follow the process, and don’t let a difficult call impact the next one. Prioritizing accuracy, maintaining a positive tone, and staying hydrated helps me manage long call volumes effectively.''',
    deepExplanation: '''BPOs measure AHT, hold time, after-call work, and demeanor consistency. High-pressure environments test emotional stability. Using call scripts, templates, and keyboard shortcuts shortens repeat work. Avoid burnout by micro-pauses and correct posture. Quality > speed.

Example
Handling 60–80 calls during peak season.

Mistakes
Carrying over emotions from previous call


Tips
Quick deep breaths help reset tone.


Resources
HubSpot: High-Volume Call Handling Tips''',
  ),
  QuestionItem(
    id: 'BPO-Q7',
    industry: 'BPO & Support',
    topic: 'Why should we hire you?',
    question: '''Why should we hire you? (BPO Version)
(Asked everywhere)''',
    shortAnswer: '''I have strong communication skills, I learn fast, and I stay calm even in tough situations. I genuinely enjoy helping people and resolving problems. I can adapt to any shift, follow guidelines, and consistently deliver high-quality service. I’ll contribute to your process from day one.''',
    deepExplanation: '''They want reliability plus soft skills. Highlight:
communication


empathy


punctuality


process discipline


shift flexibility


willingness to learn
 Avoid bragging; stay humble and confident.


Example
Link your skills to job: “I can handle customer objections confidently.”

Mistakes
Saying “Because I need the job.”


Tips
Match strengths with BPO expectations.


Resources
Concentrix Sample HR Answers''',
  ),
  QuestionItem(
    id: 'BPO-Q8',
    industry: 'BPO & Support',
    topic: 'Call Control',
    question: '''What is Call Control?
(Asked at: International Voice roles)''',
    shortAnswer: '''Call control means guiding the conversation effectively while ensuring the customer feels heard. It includes managing talk time, asking focused questions, summarizing, and keeping the call on track. It prevents unnecessary delays and improves AHT.''',
    deepExplanation: '''Techniques:
Use closed-ended questions for clarity


Redirect politely


Summaries to confirm understanding


Professional phrases (“Let me quickly check that for you…”)
 Helps maintain call flow, avoid rambling, and ensure resolution in expected time.


Example
“Before we proceed, may I confirm the last four digits…?”

Mistakes
Sounding robotic


Interrupting too early


Tips
Maintain balance: control + empathy.


Resources
ICMI: Call Flow Best Practices''',
  ),
  QuestionItem(
    id: 'BPO-Q9',
    industry: 'BPO & Support',
    topic: 'Unknown Answers',
    question: '''What if you do not know the answer to a customer’s question?
(Asked at: All BPOs)''',
    shortAnswer: '''I stay calm, avoid guessing, and inform the customer politely that I’ll check the information. I consult internal knowledge bases or seniors and return with accurate details. My goal is to provide a correct and complete answer, not a quick but wrong one.''',
    deepExplanation: '''Agents must maintain credibility. Wrong answers reduce CSAT and increase repeat calls. Companies expect agents to follow: Pause → Investigate → Resolve flow. Use hold properly, update the ticket, and verify with supervisor when required.

Example
“I want to make sure I give you the correct information. Allow me a moment to check.”

Mistakes
Guessing answers


Long silence without hold


Tips
Use KB articles regularly.


Resources
Zendesk Knowledge Base Training''',
  ),
  QuestionItem(
    id: 'BPO-Q10',
    industry: 'BPO & Support',
    topic: 'Night Shifts',
    question: '''How do you handle night shifts or rotational shifts?
(Asked at: International Support roles)''',
    shortAnswer: '''I am comfortable with night and rotational shifts. I maintain a healthy routine, take proper rest during the day, and stay consistent with my schedule. I understand that global customer support requires flexibility, and I’m prepared for it.''',
    deepExplanation: '''BPOs look for reliability and shift readiness. Night shifts require discipline like light control, hydration, and balanced meals. Candidates must show commitment. Mention experience with long hours, college schedules, or flexible routines.

Example
Worked late during exams or previous job.

Mistakes
Sounding unsure


Saying “I’ll manage somehow”


Tips
Be confident & practical.


Resources
WHO: Night Shift Health Guidelines''',
  ),
  QuestionItem(
    id: 'BPO-Q11',
    industry: 'BPO & Support',
    topic: 'Active Listening',
    question: '''What is Active Listening? Why is it important in BPO?
(Asked at: Amazon CS, Genpact Voice/Chat)''',
    shortAnswer: '''Active listening means fully focusing on the customer’s words, tone, and emotions. It involves acknowledging, clarifying, and responding thoughtfully. It helps build trust, reduces misunderstandings, and improves first-call resolution.''',
    deepExplanation: '''Active listening has 4 components:
Attention: No distractions, full focus


Acknowledgment: “I understand”, “I see your concern”


Clarification: Asking questions to confirm


Response: Accurate and empathetic
 For BPO roles, active listening improves CSAT, reduces escalations, and increases call efficiency.


Example
“I understand this is inconvenient. Let me look into it right away.”

Mistakes
Interrupting


Not paraphrasing customer issues


Tips
Take brief notes; avoid typing while customer speaks.


Resource
Dale Carnegie: Listening Skills''',
  ),
  QuestionItem(
    id: 'BPO-Q12',
    industry: 'BPO & Support',
    topic: 'Soft Skills vs Hard Skills',
    question: '''What is Soft Skills vs Hard Skills in BPO?
(Asked at: All HR rounds)''',
    shortAnswer: '''Soft skills are communication, empathy, tone, patience, and problem-solving. Hard skills are process-related abilities like using CRM tools, typing speed, ticketing systems, and product knowledge. Both are equally important for delivering great customer experiences.''',
    deepExplanation: '''Soft skills = how you treat the customer.
 Hard skills = how you solve their problem.
 Soft skills build trust and reduce frustration; hard skills ensure accurate resolution. BPO success depends on striking a balance: fast solution + polite tone + clear communication.
Example
Soft skill: Empathy
 Hard skill: Knowing how to issue a refund in the CRM
Mistakes
Believing soft skills = personality only


Tips
Practice mock calls regularly.


Resource
LinkedIn Learning: Customer Service Fundamentals''',
  ),
  QuestionItem(
    id: 'BPO-Q13',
    industry: 'BPO & Support',
    topic: 'Handling Long Wait Times',
    question: '''How do you handle long wait times or putting customers on hold?
(Asked at: Teleperformance, International Voice)''',
    shortAnswer: '''I always ask for permission before placing a customer on hold. I explain why it’s needed and assure them it will be as brief as possible. If the hold time is long, I return periodically to update them. This keeps them informed and reduces frustration.''',
    deepExplanation: '''Hold etiquette affects CSAT and call abandonment. Best practices:
Ask permission


Give estimated time


Return updates every 30–40 seconds


Thank them for waiting


Always mute hold music when necessary
 Proper hold usage avoids dead air and maintains professionalism.


Example
“May I place you on a brief hold while I check this for you?”

Mistakes
Putting on hold without asking


Long silence


Tips
Keep solutions ready before returning to call.


Resource
ICMI: Hold Time Best Practices''',
  ),
  QuestionItem(
    id: 'BPO-Q14',
    industry: 'BPO & Support',
    topic: 'Email Etiquette',
    question: '''What is Email Etiquette in a BPO?
(Asked at: Non-voice roles, Email Support)''',
    shortAnswer: '''Email etiquette includes writing clear, concise, polite, and grammatically correct emails. It requires using correct formatting, professional tone, and proper greetings and closings. Accuracy, empathy, and structure are key.''',
    deepExplanation: '''Emails must have:
Clear subject line


Short intro + context


Steps or solution


Polite closing
 Important rules: avoid slang, avoid long paragraphs, use bullet points, double-check spelling. Avoid CAPS (feels rude). Follow templates when available.


Example
“Dear John, Thank you for contacting us. I understand your concern regarding…”

Mistakes
Writing too casually


Over-explaining


Tips
Proofread before sending.


Resource
Grammarly Tone Recommendations''',
  ),
  QuestionItem(
    id: 'BPO-Q15',
    industry: 'BPO & Support',
    topic: 'Escalation',
    question: '''What is Escalation? When do you escalate an issue?
(Asked at: Genpact, Wipro BPM)''',
    shortAnswer: '''Escalation happens when a customer issue cannot be resolved at your level and must be forwarded to a higher team. You escalate when the issue is beyond your authority, technical limitations, or policy restrictions.''',
    deepExplanation: '''Escalations must be timely, documented clearly, and justified. Types:
Functional escalation: to technical team


Hierarchical escalation: to supervisor
 Agents escalate when: policy requires approval, system limitations, dissatisfaction, fraudulent concerns, or complex technical issues. Poor escalations increase TAT and customer frustration.


Example
Refund beyond allowed limit escalated to senior team.

Mistakes
Escalating too soon


Not recording proper details


Tips
Attempt first-level resolution before escalating.


Resource
ITIL Foundation — Escalation Paths''',
  ),
  QuestionItem(
    id: 'BPO-Q16',
    industry: 'BPO & Support',
    topic: 'Voice vs Non-Voice Process',
    question: '''What is the difference between Voice and Non-Voice Process?
(Asked at: All BPOs)''',
    shortAnswer: '''Voice processes involve speaking with customers through calls (inbound/outbound). Non-voice processes include chat, email, and ticket support. Voice needs strong speaking and listening skills; non-voice needs typing speed and written communication.''',
    deepExplanation: '''Voice: real-time solutions, tone control, faster feedback.
 Non-voice: slower but requires clarity, grammar, and precision.
 Voice metrics: AHT, FCR, CSAT.
 Non-voice metrics: response time, accuracy, ticket quality.
 Both require multitasking and CRM tools.
Example
Amazon Chat vs Amazon Voice.

Mistakes
Assuming non-voice is “easier”.


Tips
Highlight strengths based on role applied.


Resource
Six Sigma for Contact Centers''',
  ),
  QuestionItem(
    id: 'BPO-Q17',
    industry: 'BPO & Support',
    topic: 'Customer Persona',
    question: '''What is a Customer Persona? Why is it useful in support?
(Asked at: Quality Analyst roles)''',
    shortAnswer: '''A customer persona is a profile representing a typical customer’s needs, behavior, and preferences. Personas help agents understand who they’re speaking to and tailor communication accordingly.''',
    deepExplanation: '''Personas include demographics, goals, challenges, and expectations. Support teams use personas to modify tone, speed, technical depth, and empathy. Example: older customers need slower pacing; tech-savvy customers prefer direct instructions. QA teams evaluate agents on persona alignment.
Example
Persona: “Time-sensitive working professional.”

Mistakes
Treating all customers the same.


Tips
Study persona guide before calls.


Resource
HubSpot Persona Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q18',
    industry: 'BPO & Support',
    topic: 'Customer Verification',
    question: '''How do you verify customer identity on a call?
(Asked at: Banking BPO, Insurance, Fintech)''',
    shortAnswer: '''I follow company policy to verify identity, usually using name, registered phone/email, last four digits of an ID, or security questions. I never disclose personal information before verification. This protects customer privacy and prevents fraud.''',
    deepExplanation: '''Verification ensures data security (GDPR, ISO 27001 compliance). Steps include:
Ask security questions


Match CRM details


If mismatch → deny sensitive actions
 Never guess or reveal hints. Financial processes require stricter checks. Failing verification leads to controlled access only.


Example
“Can you confirm your date of birth and registered mobile number?”

Mistakes
Revealing info without verification


Tips
Follow 2FA or OTP if required.


Resource
PCI-DSS Customer Verification Guidelines''',
  ),
  QuestionItem(
    id: 'BPO-Q19',
    industry: 'BPO & Support',
    topic: 'Handling Repetitive Tasks',
    question: '''How do you handle repetitive tasks without losing quality?
(Asked at: Operations, QA evaluations)''',
    shortAnswer: '''I maintain consistency by following SOPs, using checklists, and staying focused. I divide work into manageable steps and take short mental breaks when needed. I double-check outputs to ensure accuracy even when tasks are repetitive.''',
    deepExplanation: '''Repetition requires discipline:
Templates for accuracy


Short breaks for refresh


Avoid multitasking


Prioritize quality over speed
 Many BPO tasks are repetitive, so agents must stay motivated. Proper posture, hydration, and mindfulness also help productivity.


Example
Handling 200+ similar email tickets daily.

Mistakes
Rushing → errors


Tips
Use keyboard shortcuts.


Resource
Kaizen & Continuous Improvement Techniques''',
  ),
  QuestionItem(
    id: 'BPO-Q20',
    industry: 'BPO & Support',
    topic: 'Multitasking',
    question: '''What is Multitasking? Give an example from a BPO workflow.
(Asked at: Chat Support, Voice + Ticket hybrid roles)''',
    shortAnswer: '''Multitasking is handling multiple actions efficiently without losing accuracy. In BPO, it could mean talking to a customer while checking CRM details, documenting notes, and processing requests—all at the same time.''',
    deepExplanation: '''BPO multitasking requires prioritization, muscle memory, and tool mastery. Agents often:
Handle multiple chat windows


Switch between CRM + Email + Knowledge Base


Document while speaking
 Proper multitasking reduces AHT and increases efficiency—but must not compromise quality.


Example
Chat agent handling 3 simultaneous chat sessions.

Mistakes
Trying to multitask without understanding workflow


Tips
Learn keyboard shortcuts & templates.


Resource
Google Workspace Productivity Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q21',
    industry: 'BPO & Support',
    topic: 'Handling Talkative Customers',
    question: '''How do you handle customers who talk too much or go off-topic?
(Asked at: Customer Support Voice roles, Amazon & Concentrix)''',
    shortAnswer: '''I politely guide the conversation back to the main issue using soft call-control phrases. I acknowledge what the customer is saying, then redirect them gently to keep the call efficient and productive. My goal is to balance respect with professional time management.''',
    deepExplanation: '''Customers may vent or overshare. Techniques include:
Acknowledge + Redirect: “I understand, and to help you faster…”


Use closed-ended questions: to limit rambling


Summaries: “So to confirm, the issue is…”


Call pacing: control tone & tempo
 This ensures good AHT without sounding rude.


Example
“Absolutely, I understand. Now to resolve your issue quickly, may I confirm your order ID?”

Mistakes
Cutting customer mid-sentence


Sounding robotic


Tips
Smile while speaking—it influences tone.


Resource
ICMI: Call Control Masterclass''',
  ),
  QuestionItem(
    id: 'BPO-Q22',
    industry: 'BPO & Support',
    topic: 'First Call Resolution (FCR)',
    question: '''What is First Call Resolution (FCR)? Why is it important?
(Asked at: Teleperformance, Wipro BPM)''',
    shortAnswer: '''FCR means resolving a customer issue on the very first interaction without the need for follow-ups. It improves customer satisfaction, reduces workload, and shows strong problem-solving skills. High FCR = more efficient support.''',
    deepExplanation: '''FCR links directly to CSAT. When customers don’t need to call again, frustration drops. FCR requires: strong product knowledge, good probing questions, clear communication, and ownership. BPOs track FCR weekly and use it to measure agent performance.
Example
Processing a refund + sending confirmation email in the same call.

Mistakes
Marking cases as FCR without verifying resolution


Tips
Ask: “Is there anything else I can help you with today?”


Resource
HDI: First-Call Resolution Framework''',
  ),
  QuestionItem(
    id: 'BPO-Q23',
    industry: 'BPO & Support',
    topic: 'Probing',
    question: '''What is Probing? Give examples.
(Asked at: Amazon Chat, Tech Support L1)''',
    shortAnswer: '''Probing means asking targeted questions to understand the real issue. It helps identify root cause quickly and reduces AHT. Probing includes open-ended and closed-ended questions depending on the situation.''',
    deepExplanation: '''Open-ended: gather details (“Can you explain what happened before the error?”)
 Closed-ended: confirm specifics (“Is the charger original?”)
 Effective probing prevents wrong solutions, escalations, and repeated calls. It also improves accuracy in ticketing.
Example
“For clarification, is the error appearing before or after login?”

Mistakes
Asking too many questions at once


Tips
Ask one clear question at a time.


Resource
ServiceNow Probing Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q24',
    industry: 'BPO & Support',
    topic: 'Empathy vs Sympathy',
    question: '''What is the difference between Empathy and Sympathy?
(Asked in HR rounds for all support roles)''',
    shortAnswer: '''Empathy means understanding and acknowledging a customer’s feelings. Sympathy means feeling bad for them. BPOs require empathy because it builds trust and keeps communication professional without becoming emotional.''',
    deepExplanation: '''Empathy phrases:
“I understand how frustrating this must be.”
 Sympathy phrases:


“I feel so sorry for you.”
 Empathy focuses on the customer’s experience, not our emotions. Excess sympathy makes conversations unprofessional and reduces control.


Example
Empathy: “Let me help you fix this right away.”

Mistakes
Using emotional language


Over-apologizing


Tips
Use empathy + solution, not empathy alone.


Resource
Dale Carnegie: Empathetic Communication''',
  ),
  QuestionItem(
    id: 'BPO-Q25',
    industry: 'BPO & Support',
    topic: 'Handling Backlogs',
    question: '''How do you deal with backlogs or high-volume days?
(Asked at: Operations roles & Quality Analyst interviews)''',
    shortAnswer: '''I prioritize tasks based on urgency and impact, follow SOPs strictly, and avoid rushing. I maintain calm, work systematically, and update customers on delays when necessary. My focus is accuracy + speed.''',
    deepExplanation: '''During peak load:
Use templates


Reduce after-call work with brief notes


Batch similar tasks


Avoid multitasking beyond limits


Coordinate with teammates for smoother workflow
 This ensures high-quality output even on heavy days.


Example
Promotions or festival days with 200+ tickets.

Mistakes
Skipping documentation


Panic work


Tips
Follow the “Urgent–Important Priority Matrix.”


Resource
Kaizen for Contact Centers''',
  ),
  QuestionItem(
    id: 'BPO-Q26',
    industry: 'BPO & Support',
    topic: 'Knowledge Base (KB)',
    question: '''What is a Knowledge Base (KB)? Why is it important?
(Asked at: Technical Support & Non-voice)''',
    shortAnswer: '''A knowledge base is a collection of help articles, troubleshooting steps, and product FAQs used by agents to solve customer issues quickly. It ensures consistency, accuracy, and faster resolution.''',
    deepExplanation: '''KB contains SOPs, scripts, refund rules, troubleshooting guides. It reduces confusion and avoids contradictory answers. New agents use KB heavily during training. Updated KB = low AHT + high FCR. QA teams ensure KB compliance.
Example
Refund eligibility article in Zendesk KB.

Mistakes
Ignoring KB updates


Tips
Bookmark commonly used KB articles.


Resource
Zendesk KB Writing Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q27',
    industry: 'BPO & Support',
    topic: 'AHT Reduction',
    question: '''Explain AHT. How can you reduce it without compromising quality?
(Asked at: All BPOs, especially voice roles)''',
    shortAnswer: '''AHT = talk time + hold time + after-call work. To reduce AHT, I use call control, templates, proper probing, and avoid unnecessary long conversations while keeping resolution accuracy high.''',
    deepExplanation: '''Techniques:
Use keyboard shortcuts


Ask focused questions


Document during the call


Avoid rambling


Manage hold efficiently
 AHT should never be reduced by rushing or skipping steps. Quality and empathy must remain intact.


Example
Reducing AHT from 6 minutes → 4 minutes through better probing.

Mistakes
Ending calls too fast (hurts CSAT)


Tips
Practice “think-fast, speak-clear”.


Resource
ICMI AHT Optimization Report''',
  ),
  QuestionItem(
    id: 'BPO-Q28',
    industry: 'BPO & Support',
    topic: 'Quality Assurance (QA)',
    question: '''What is Quality Assurance (QA) in a BPO?
(Asked at: QA/Analyst roles)''',
    shortAnswer: '''QA ensures calls, chats, and emails meet company standards. QA teams evaluate accuracy, tone, empathy, policy compliance, and documentation to maintain consistent service quality.''',
    deepExplanation: '''QA checks:
Soft skills


Process adherence


Product knowledge


Compliance (PCI, GDPR)
 Feedback is given through scorecards. QA reduces errors, improves performance, and ensures customer trust. Calibration sessions align QA & agents.


Example
QA deducts points for incorrect hold process.

Mistakes
Treating QA as policing


Tips
Take feedback positively.


Resource
COPC Customer Service Standard''',
  ),
  QuestionItem(
    id: 'BPO-Q29',
    industry: 'BPO & Support',
    topic: 'Chat vs Email Support',
    question: '''What is the difference between Chat Support and Email Support?
(Asked at: Non-voice roles)''',
    shortAnswer: '''Chat support is real-time and fast-paced. Email support is slower but requires detailed responses. Chat needs quick thinking and multitasking; email needs accurate writing skills and structure.''',
    deepExplanation: '''Chat:
Handle 2–4 chats simultaneously


Short messages


Quick probing
 Email:


Detailed explanations


Correct formatting


Ticket priorities
 Both use canned responses, CRM tools, and templates. Chat focuses on speed; email focuses on clarity.


Example
Chat: “One moment, I’m checking that.”
 Email: Structured paragraphs & headings.

Mistakes
Writing long messages on chat


Tips
Learn shortcuts (Ctrl+K, canned replies).


Resource
Freshdesk Chat Handling Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q30',
    industry: 'BPO & Support',
    topic: 'Motivation',
    question: '''What motivates you to work in BPO?
(Asked at: HR rounds for all BPO companies)''',
    shortAnswer: '''I enjoy helping people and solving problems. BPO roles allow me to work with global customers, improve communication skills, and grow professionally. I’m motivated by learning opportunities, structured career paths, and performance-based growth.''',
    deepExplanation: '''Interviewers test long-term interest. Mention:
Skill development


Exposure to international processes


Performance-driven environment


Opportunity to grow into QA, SME, Trainer, or TL roles
 Avoid generic answers like “I need a job.”


Example
Growth from agent → SME → QA.

Mistakes
Mentioning “money only”


Tips
Link motivation to learning & growth.


Resource
Career Paths in BPM Industry (NASSCOM)''',
  ),
  QuestionItem(
    id: 'BPO-Q31',
    industry: 'BPO & Support',
    topic: 'Soft Call Closure',
    question: '''What is Soft Call Closure? Give an example.
(Asked at: Teleperformance, International Voice)''',
    shortAnswer: '''Soft call closure means ending the call politely while ensuring the customer feels fully supported. It includes summarizing the solution, checking if anything else is needed, and closing with a courteous phrase. It prevents abrupt endings and improves CSAT.''',
    deepExplanation: '''Soft closure follows a structure:
Solution Summary – confirm the fix


Final Check – “Is there anything else I can help you with today?”


Appreciation – thank them for contacting


Warm goodbye – friendly closing line
 It signals professionalism and ensures no unresolved queries.


Example
“Your refund has been processed and will reflect in 3–5 days. Is there anything else I can help you with today?”

Mistakes
Ending with “Okay bye”


Not summarizing the solution


Tips
Keep closure under 15 seconds.


Resource
ICMI: Call Closure Techniques''',
  ),
  QuestionItem(
    id: 'BPO-Q32',
    industry: 'BPO & Support',
    topic: 'Net Promoter Score (NPS)',
    question: '''What is Net Promoter Score (NPS)?
(Asked at: QA rounds, Voice/Chat Support)''',
    shortAnswer: '''NPS measures customer loyalty by asking customers how likely they are to recommend the service. Scores range from 0 to 10. It helps companies understand customer satisfaction and long-term loyalty.''',
    deepExplanation: '''Scores:
9–10 → Promoters


7–8 → Passives


0–6 → Detractors
 NPS = %Promoters – %Detractors.
 Agents influence NPS by empathy, accuracy, and ownership. High NPS indicates strong customer experience; low NPS signals service gaps.


Example
Amazon CS uses NPS for post-interaction surveys.

Mistakes
Thinking NPS = CSAT (NPS is loyalty, not satisfaction)


Tips
Give clear solutions & proactive help to boost NPS.


Resource
Qualtrics NPS Handbook''',
  ),
  QuestionItem(
    id: 'BPO-Q33',
    industry: 'BPO & Support',
    topic: 'Call Calibration',
    question: '''What is Call Calibration? Why is it needed?
(Asked at: QA/SME interviews)''',
    shortAnswer: '''Calibration ensures all QA teams, TLs, and agents evaluate calls in the same way. It aligns quality standards, reduces scoring differences, and ensures fairness.''',
    deepExplanation: '''During calibration, teams listen to the same call and compare evaluations. Differences in penalties or scoring are discussed until everyone agrees. This improves scoring accuracy, agent trust, and consistency across shifts or processes.
Example
Weekly calibration between QA team and client SPOCs.

Mistakes
Treating calibration as feedback session (it’s alignment)


Tips
Take notes on scoring patterns.


Resource
COPC Calibration Framework''',
  ),
  QuestionItem(
    id: 'BPO-Q34',
    industry: 'BPO & Support',
    topic: 'Voice Modulation',
    question: '''What is Voice Modulation? Why is it important?
(Asked at: International Voice roles)''',
    shortAnswer: '''Voice modulation means adjusting your tone, pitch, and speed to match the conversation. It helps express empathy, confidence, and clarity. Good modulation makes customers feel valued and improves communication.''',
    deepExplanation: '''Elements:
Pitch: vary to avoid monotone


Speed: slower for older customers


Tone: warm, patient


Stress: highlight key words
 Proper modulation reduces misunderstandings and keeps conversations engaging. It is essential for international processes where accents differ.


Example
Lowering pitch when giving instructions; higher warmth when apologizing.

Mistakes
Speaking too fast


Flat or robotic tone


Tips
Practice reading scripts with emotional variety.


Resource
Toastmasters Voice Training''',
  ),
  QuestionItem(
    id: 'BPO-Q35',
    industry: 'BPO & Support',
    topic: 'Blended Process',
    question: '''What is Blended Process in BPO?
(Asked at: Concentrix, Sutherland)''',
    shortAnswer: '''A blended process combines voice and non-voice tasks. Agents handle calls, chats, and emails depending on workload. It increases flexibility and optimizes resources.''',
    deepExplanation: '''Blended processes use omnichannel tools to route tasks. Agents must switch between call etiquettes and writing skills. Metrics differ per channel, so time management is key. Companies prefer blended agents because they reduce idle time and improve SLA adherence.
Example
Agent handling voice calls in peak hours and chat during low calls.

Mistakes
Switching without adjusting tone or writing style


Tips
Use templates for chat/email during rush.


Resource
Genesys Omnichannel Support Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q36',
    industry: 'BPO & Support',
    topic: 'Call Wrap-Up / ACW',
    question: '''What is Call Wrap-Up or After-Call Work (ACW)?
(Asked at: Teleperformance, Wipro BPM)''',
    shortAnswer: '''ACW refers to the tasks done after ending a call, such as updating notes, completing forms, tagging tickets, and sending follow-up emails. Efficient ACW improves AHT and helps maintain accurate records.''',
    deepExplanation: '''ACW includes:
Summarizing interaction


Selecting correct ticket category


Updating CRM fields


Triggering workflows
 Long ACW increases AHT. Agents should document while on call when possible and use short, clear notes.


Example
Adding “Customer requested refund; ticket escalated to billing.”

Mistakes
Writing lengthy notes


Forgetting to tag issues properly


Tips
Use bullet-style notes.


Resource
Zendesk Ticket Documentation Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q37',
    industry: 'BPO & Support',
    topic: 'Confidentiality',
    question: '''How do you maintain confidentiality in a BPO environment?
(Asked at: Banking, Fintech, Insurance support)''',
    shortAnswer: '''I follow data privacy rules strictly, avoid sharing sensitive details, verify callers before giving information, and use company systems responsibly. I never write personal data on paper or discuss customer details outside the workplace.''',
    deepExplanation: '''Confidentiality includes:
GDPR, ISO 27001 compliance


PCI-DSS for card data


Clean desk policy


No screenshots


No personal storage devices
 Training is mandatory. Violations lead to process removal or termination.


Example
Not sharing full card number with customers.

Mistakes
Mentioning sensitive data aloud


Tips
Follow “need-to-know” principle.


Resource
PCI-DSS Compliance Basics''',
  ),
  QuestionItem(
    id: 'BPO-Q38',
    industry: 'BPO & Support',
    topic: 'Cultural Differences',
    question: '''How do you handle cultural differences in international support?
(Asked at: US/UK/Australia processes)''',
    shortAnswer: '''I adapt my tone, vocabulary, pacing, and expressions based on the customer’s region. I avoid slang, stay respectful, and focus on clarity. Understanding cultural differences helps build rapport quickly.''',
    deepExplanation: '''Customers from US/UK/AU have different expectations.
US: friendly, direct


UK: polite, formal


AU: casual but clear
 Agents must adjust idioms, avoid local Indian slang, and understand holiday references. Cultural neutrality ensures smooth communication.


Example
Avoiding phrases like “do one thing” or “only” unnecessarily.

Mistakes
Using Indian English phrases


Misinterpreting sarcasm


Tips
Listen carefully to customer tone.


Resource
Intercultural Communication by Hofstede''',
  ),
  QuestionItem(
    id: 'BPO-Q39',
    industry: 'BPO & Support',
    topic: 'Chat Average Response Time (ART)',
    question: '''What is Chat Average Response Time (ART)?
(Asked at: Chat Support roles)''',
    shortAnswer: '''ART measures how quickly an agent responds to customer chat messages. Lower ART indicates faster service and better customer experience. It is a key metric for chat support.''',
    deepExplanation: '''Chat response speed depends on multitasking, canned messages, and knowledge of shortcuts. ART is different from AHT because chats may run parallel. Keeping ART low ensures customers don’t feel ignored, improving CSAT.
Example
Target ART: 20–30 seconds per message.

Mistakes
Writing long paragraphs


Delayed responses while checking info


Tips
Use templates and short sentences.


Resource
Freshchat Productivity Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q40',
    industry: 'BPO & Support',
    topic: 'International Voice Process Interest',
    question: '''Why do you want to join an international voice process?
(Asked at: International Voice, Teleperformance Global)''',
    shortAnswer: '''I want to improve my global communication skills, handle diverse customers, and grow in an international environment. International voice roles offer strong learning opportunities, exposure to global standards, and long-term career growth in customer experience.''',
    deepExplanation: '''They test interest in accent, flexibility, and long-term commitment. Highlight:
Learning global communication


Better customer handling


International-quality processes


Career path to SME, QA, Trainer
 Avoid saying “for higher salary”.


Example
“I enjoy speaking with customers and solving problems in real time.”

Mistakes
Mentioning money as primary driver


Tips
Show eagerness to learn accents and communication.


Resource
Concentrix Global Voice Training Manual''',
  ),
  QuestionItem(
    id: 'BPO-Q41',
    industry: 'BPO & Support',
    topic: 'Handling Difficult Customers',
    question: '''How do you handle a customer who refuses to follow instructions?
(Asked at: Tech Support L1, Amazon Voice, Concentrix)''',
    shortAnswer: '''I stay calm and explain why the step is necessary in simple terms. If the customer still refuses, I provide alternative steps where possible. I avoid arguments and maintain empathy while guiding the conversation toward resolution.''',
    deepExplanation: '''Reasons customers refuse steps: fear of mistakes, lack of understanding, frustration, or language barriers.
 Effective techniques include:
Reasoning: “This step helps us diagnose the issue safely.”


Simplifying: breaking steps into smaller parts


Offering alternatives: “If restarting isn’t possible now, we can try clearing cache first.”


Reassurance: “I’ll guide you slowly, no rush.”
 Helps reduce escalations and maintain call control.


Example
Customer refusing router restart → offer checking cables first.

Mistakes
Sounding authoritative


Repeating same line without rephrasing


Tips
Use “because” → it increases compliance by 70%.


Resource
Harvard Comms: Persuasion in Support Calls''',
  ),
  QuestionItem(
    id: 'BPO-Q42',
    industry: 'BPO & Support',
    topic: 'Positive Language',
    question: '''Explain Positive Language with examples.
(Asked at: QA rounds & Voice Process)''',
    shortAnswer: '''Positive language focuses on what can be done rather than what cannot. It reassures customers and creates a pleasant experience. It keeps conversations solution-oriented and reduces frustration.''',
    deepExplanation: '''Positive language avoids negative triggers:
“I can’t” vs “Here’s what we can do…”


“That’s not possible” vs “An alternative option is…”
 Benefits: higher CSAT, better tone perception, shorter call times, and smoother resolutions. Especially useful for denials or delays.


Example
Negative: “You didn’t fill the form correctly.”
 Positive: “Let me help you quickly update the missing information.”

Mistakes
Overly cheerful tone during serious issues


Tips
Replace “but” with “and”.


Resource
Zendesk Tone Optimization Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q43',
    industry: 'BPO & Support',
    topic: 'Scripts',
    question: '''What is a Script? Do you strictly follow it?
(Asked at: Banking/Insurance BPOs)''',
    shortAnswer: '''A script is a predefined set of lines used for greetings, compliance checks, and certain responses. I follow scripts for accuracy and compliance, but I personalize the conversation to keep it natural.''',
    deepExplanation: '''Scripts ensure:
Legal compliance (especially in BFSI)


Consistent greetings


Accurate disclosures
 But agents must avoid sounding robotic. The balance is: follow required script sections, personalize during open conversations, and maintain context.


Example
Mandatory script: “This call may be recorded…”
 Flexible: explanation and resolution steps.

Mistakes
Reading word-by-word


Deviating from compliance lines


Tips
Practice scripts until natural.


Resource
COPC Contact Center Compliance Standards''',
  ),
  QuestionItem(
    id: 'BPO-Q44',
    industry: 'BPO & Support',
    topic: 'Abusive Language',
    question: '''What would you do if a customer uses abusive language?
(Asked at: All voice processes)''',
    shortAnswer: '''I remain calm, avoid reacting emotionally, and focus on solving the issue. If abuse continues, I politely warn the customer. If it still continues, I follow company policy which may include ending the call respectfully.''',
    deepExplanation: '''Support agents must handle verbal aggression professionally. Process:
Stay neutral


Use de-escalation phrases


Provide a warning


Disconnect if policy permits (after informing)
 Companies prioritize employee safety and professional boundaries.


Example
“I’m here to help, but I request we keep the conversation respectful.”

Mistakes
Arguing or responding emotionally


Tips
Keep your tone steady and controlled.


Resource
Amazon CS De-escalation Training''',
  ),
  QuestionItem(
    id: 'BPO-Q45',
    industry: 'BPO & Support',
    topic: 'CRM',
    question: '''What is a CRM? Why is it used in BPO?
(Asked at: Non-voice, Email, Chat, Tech Support)''',
    shortAnswer: '''CRM stands for Customer Relationship Management. It stores customer details, interaction history, tickets, and product information. It helps agents resolve issues faster and maintain accurate records.''',
    deepExplanation: '''CRM benefits:
Track past interactions


Reduce repetition


Maintain data accuracy


Faster troubleshooting


Assign tickets to departments
 Popular CRMs: Salesforce, Zendesk, Freshdesk. Accurate CRM usage directly influences AHT, CSAT, and FCR.


Example
Checking purchase history to verify warranty.

Mistakes
Leaving unnecessary notes


Incorrect tagging


Tips
Use short bullet-style notes.


Resource
Salesforce Agent Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q46',
    industry: 'BPO & Support',
    topic: 'Process Knowledge',
    question: '''What is Process Knowledge? How do you keep it updated?
(Asked at: All BPOs, especially SME/QA aspirants)''',
    shortAnswer: '''Process knowledge means understanding product features, policies, tools, and workflows. I keep it updated by reviewing internal KB, attending trainings, and staying aware of policy or product updates.''',
    deepExplanation: '''Process knowledge improves accuracy, reduces escalations, and increases FCR. Updates come through change logs, internal emails, SOP changes, and team meetings. Agents should bookmark key articles, note updates, and review them daily. High process knowledge = higher QA scores.
Example
New refund policy update → reviewed before shift.

Mistakes
Relying on memory instead of KB


Tips
Spend 5 minutes “KB refresh” daily.


Resource
Internal SOP guidelines''',
  ),
  QuestionItem(
    id: 'BPO-Q47',
    industry: 'BPO & Support',
    topic: 'Multiple Chat Sessions',
    question: '''How do you handle multiple chat sessions at once?
(Asked at: Chat Support roles — Amazon, Flipkart, Swiggy)''',
    shortAnswer: '''I prioritize clarity, use templates, split attention effectively, and avoid long gaps in conversations. I keep responses crisp and maintain thread awareness in each chat window.''',
    deepExplanation: '''Handling 2–4 chats requires:
Quick reading


Parallel typing


Using canned responses


Avoiding long messages


Switching smoothly between customers
 Good chat agents track problem progress in each window mentally. ART and accuracy both matter.


Example
Handling billing chat + tracking issue chat + login issue chat simultaneously.

Mistakes
Copy-pasting wrong template


Confusing chat windows


Tips
Use short, clear sentences.


Resource
Freshchat Multichat Management Guide''',
  ),
  QuestionItem(
    id: 'BPO-Q48',
    industry: 'BPO & Support',
    topic: 'Process Gap',
    question: '''What is a Process Gap? How do you report it?
(Asked at: QA & Ops roles)''',
    shortAnswer: '''A process gap is a missing step, unclear instruction, or inconsistency in workflow that affects efficiency or customer experience. I report it to my TL/QA with screenshots, details, and suggestions for improvement.''',
    deepExplanation: '''Examples of process gaps:
Outdated KB article


Missing refund option in CRM


Conflicting SOP instructions
 Identifying gaps reduces errors and improves customer experience. Escalation format: description → impact → example → proposed fix.


Example
Refund policy in KB not matching real CRM options.

Mistakes
Reporting without evidence


Tips
Keep reporting precise and professional.


Resource
Lean Six Sigma: Process Gap Analysis''',
  ),
  QuestionItem(
    id: 'BPO-Q49',
    industry: 'BPO & Support',
    topic: 'Non-English Customers',
    question: '''How do you deal with non-English-speaking customers?
(Asked at: Global processes — US, UK, EMEA)''',
    shortAnswer: '''I speak slowly, use simple words, avoid idioms, and confirm understanding frequently. If needed, I use translation tools or transfer the call to a bilingual agent as per process. I maintain patience and clarity.''',
    deepExplanation: '''Key techniques:
Break instructions into small steps


Use yes/no questions


Avoid slang


Spell out complicated words


Repeat in simpler phrasing
 Ensures no misunderstanding. Maintaining tone is crucial.


Example
Instead of “Authenticate your credentials,” say “Please enter your password.”

Mistakes
Speaking louder (does not help)


Tips
Use universal vocabulary (“cancel”, “confirm”, “check”).


Resource
Cross-Cultural Communication — Hofstede''',
  ),
  QuestionItem(
    id: 'BPO-Q50',
    industry: 'BPO & Support',
    topic: 'Future Goals',
    question: '''Where do you see yourself in 2 years? (BPO Version)
(Asked at: HR rounds, all companies)''',
    shortAnswer: '''In two years, I see myself becoming an expert in the process, achieving strong performance metrics, and moving into roles like SME, QA, or Trainer. I want to grow within the organization and contribute to team success.''',
    deepExplanation: '''BPOs prefer candidates who show long-term intent. Focus on:
Process mastery


Internal growth


Skill development


Leadership potential
 Avoid saying “I want to leave the BPO industry.”


Example
Starting as agent → SME → QA.

Mistakes
Saying “I’ll start my own business”


Tips
Connect your goals with company growth.


Resource
Career Progression in BPM (NASSCOM)''',
  ),
];
