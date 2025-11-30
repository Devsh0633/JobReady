#!/bin/bash

BASE_URL="http://127.0.0.1:5001/jobready-functions/us-central1"

echo "Testing Healthcheck..."
curl -X GET "$BASE_URL/healthcheck"
echo -e "\n"

echo "Testing Writer Generate..."
curl -X POST "$BASE_URL/writerGenerate" \
  -H "Content-Type: application/json" \
  -d '{
    "jobRole": "Software Engineer",
    "companyName": "TechCorp",
    "tone": "formal",
    "context": "I have 5 years of experience in React and Node.js."
  }'
echo -e "\n"

echo "Testing Writer Shorten..."
curl -X POST "$BASE_URL/writerShorten" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "I am writing to you today to express my sincere interest in the position of Software Engineer at your esteemed company. I believe that my skills and experience make me a perfect fit for this role."
  }'
echo -e "\n"

echo "Testing Interview Analyze..."
curl -X POST "$BASE_URL/interviewAnalyze" \
  -H "Content-Type: application/json" \
  -d '{
    "question": "Explain the event loop in Node.js",
    "answer": "The event loop is what allows Node.js to perform non-blocking I/O operations."
  }'
echo -e "\n"
