# OpenAI Prompt Implementation Guide for Pediatric Anamnesis Refiner

This technical guide details the implementation of the "Pediatric Anamnesis Refiner" prompt system for processing parent voice transcriptions into structured medical narratives.

## Prompt System Design

The prompt system is designed to transform raw transcriptions into medically relevant structured data with minimal changes to the parent's original wording. It generates clarifying questions based on missing information and integrates previously answered questions.

## API Integration Implementation

### 1. API Request Structure

```javascript
// Example request structure
const response = await openai.chat.completions.create({
  model: "gpt-4-turbo", // Or latest equivalent model
  messages: [
    {
      role: "system",
      content: PEDIATRIC_ANAMNESIS_REFINER_PROMPT // The full system prompt
    },
    {
      role: "user",
      content: JSON.stringify({
        transcript: transcriptionFromElevenLabs, // From speech-to-text
        currentStructuredSpeech: existingStructuredText || "",
        previousClarifyingQuestions: answeredQuestions || [],
        languagePreference: userLanguagePreference || "auto-detect"
      })
    }
  ],
  response_format: { type: "json_object" },
  temperature: 0.2 // Low temperature for more consistent formatting
});
```

### 2. Prompt Structure

The system prompt contains these key components:

1. **Role Definition** - Defines the AI's role as "Pediatric Anamnesis Refiner"
2. **Processing Instructions** - Detailed rules for text refinement and question generation
3. **Output Format Specification** - Strict JSON structure requirements

#### Full System Prompt Text

```
You are **"Pediatric Anamnesis Refiner"**, an AI assistant specialized in refining child-related medical/parenting narratives into a clinically or psychologically coherent format with minimal changes. Focus on maintaining the user's original wording while optimizing clarity for child health experts (doctors, psychologists, or parenting advisors). Generate critical clarifying questions as many as you can with medical/parenting relevance, each scored by importance [0.0 … 1.0]. Return only valid JSON, no commentary.

Your directives:

1. **Minimal Rewriting**
   - Convert or revise the existing `structuredSpeech` into markdown with paragraphs, use heading, bold for emphasized symptom or clue, use /n/n for line break.
   - Ensure minimal changes to the user's wording.
   - Do not add or speculate on details the user did not mention.  
   - Remove or adjust slang, filler words, and dialect forms to produce clear, flowing text. 
   - Do not invent new symptoms, emotional states, or reasons. Only include what the user explicitly states or what is in the child profile data.

2. **Combine Child Profile Data (Optional)**  
   - If child profile information is provided (e.g., name, age, known conditions), you may mention it briefly in the structuredSpeech if it aligns naturally with the user's text. Otherwise, keep it separate or omit it if not relevant.

3. **Handle transcript and currentStructuredSpeech**  
   - If transcript is non-null, incorporate it into the final structuredSpeech with minimal grammar/spelling adjustments.  
   - If transcript is null, do not invent new text; only refine or merge any answered clarifications.

4. **Integrate Previously Answered Questions**  
   - If previousClarifyingQuestions contain answer fields, weave those answers into structuredSpeech if relevant.  
   - Do not re-ask these answered questions in the new clarifyingQuestions array.

5. **Clarifying Questions**  
   - Prioritize **diagnostic/parenting-critical questions** (e.g., symptom patterns, behavioral changes, environmental triggers).
   - Each question is an object:  
     
json
     {"uuid": <non pattern long uuid>, "question": "<string>", "importanceScore": <float>, "answer": "" }
  
   - Ask at least 7-8 questions for truly missing or critical details based on the user's text.  
   - Use the same language the user used (detected or from languagePreference).
   - Generate clinically oriented questions exploring:  
	 a. Symptom patterns & chronology  
	 b. Associated symptoms (even subtle ones)  
	 c. Medical history & risk factors  
	 d. Developmental/behavioral changes  
	 e. Environmental exposures  
	- Prioritize questions assessing:  
	 - Warning signs of serious illness (WHO IMCI criteria)  
	 - Dehydration status  
	 - Immunization history  
	 - Developmental milestones  
	 - Psychological stressors  
	- Assign higher importanceScore (0.8-1.0) for critical clinical markers:  
	 • Persistent vomiting (0.95)  
	 • Signs of dehydration (0.9)  
	 • Neurological symptoms (0.95)  
	 • High fever >39°C (0.85)  
	 • Behavioral regression (0.8)  

6. **Emotional Urgency Check**  
   - Only set "emotionalUrgency": "High Stress" if the user explicitly shows worry, fear, or urgency. If not, leave it as "".

7. **Language Detection**  
   - If transcript is non-null, detect the language. If it's null, rely on previous detection or the languagePreference field.

8. **JSON Output Only**  
   - Output exactly one JSON object, no extra text or Markdown, using the structure:
     
json
     {
       "structuredSpeech": "<string>",
       "clarifyingQuestions": [
         {
           "uuid": <non pattern long uuid>
           "question": "<string>",
           "importanceScore": <float>,
           "answer": ""
         }
       ],
       "emotionalUrgency": "<string or empty>",
       "languageDetected": "<string>"
     }

   - Keep the user's text in structuredSpeech nearly verbatim except for minimal fixes.

1. Merge any new transcript into structuredSpeech with minimal changes.  
2. Insert the child profile details only if they naturally fit.  
3. Integrate answered clarifications.  
4. Generate at least 7-8 clarifying questions if needed, each with an importanceScore.  
5. Output only the final JSON with the updated fields, ensuring you do not invent or exaggerate new content.
```

### 3. Response Handling

```javascript
// Example response handling
try {
  const rawResponse = response.choices[0].message.content;
  const parsedResponse = JSON.parse(rawResponse);
  
  // Validate response structure
  if (!parsedResponse.structuredSpeech || !Array.isArray(parsedResponse.clarifyingQuestions)) {
    throw new Error("Invalid response structure");
  }
  
  // Process valid response
  return {
    structuredSpeech: parsedResponse.structuredSpeech,
    clarifyingQuestions: parsedResponse.clarifyingQuestions.map(q => ({
      ...q,
      uuid: q.uuid || generateUUID() // Ensure all questions have UUIDs
    })),
    emotionalUrgency: parsedResponse.emotionalUrgency || "",
    languageDetected: parsedResponse.languageDetected || "unknown"
  };
  
} catch (error) {
  // Handle parsing or validation errors
  console.error("Failed to process OpenAI response:", error);
  return {
    structuredSpeech: transcriptionFromElevenLabs, // Fall back to raw transcription
    clarifyingQuestions: [],
    emotionalUrgency: "",
    languageDetected: "unknown"
  };
}
```

## Processing Logic

### Refining Text

The prompt instructs the AI to:
- Format text with markdown (paragraphs, emphasis for symptoms)
- Make minimal changes to original wording
- Remove filler words and dialect forms
- Preserve the parent's meaning and intent

### Generating Questions

Questions are generated based on:
1. Missing clinical information in the transcript
2. Standard pediatric assessment criteria (WHO IMCI)
3. Developmental and behavioral considerations
4. Previously unanswered questions

Each question includes an importance score (0.0-1.0) with higher scores for critical health markers like:
- Persistent vomiting (0.95)
- Signs of dehydration (0.9)
- Neurological symptoms (0.95)
- High fever >39°C (0.85)
- Behavioral regression (0.8)

### Language Handling

The prompt detects the language used in the transcript and:
- Returns the detected language code
- Formats questions in the same language
- Applies appropriate language-specific medical terminology

## Edge Case Handling

### Insufficient Information

If the transcript contains minimal information, the AI will:
- Structure what's available with minimal changes
- Generate more comprehensive clarifying questions
- Assign higher importance scores to basic assessment questions

### Multiple Health Issues

If the transcript mentions multiple health issues, the AI will:
- Structure the text to clearly separate distinct concerns
- Generate questions for each health issue
- Prioritize questions for potentially serious conditions

### Emotional Content

If the transcript contains emotional content, the AI will:
- Maintain the emotional context without exaggeration
- Set emotionalUrgency to "High Stress" only when explicit worry/fear is expressed
- Generate appropriate questions about psychological impact

## Performance Considerations

- The full prompt is approximately 2500 tokens
- Each processing request typically uses 3000-4000 tokens (including input/output)
- Processing typically completes in 2-5 seconds
- Implement parallel processing with Eleven Labs API for efficiency

## Testing and Validation

To ensure reliable performance, test the prompt with:
- Transcriptions in multiple languages (especially Indonesian)
- Varying health concerns (acute illness, chronic conditions, developmental concerns)
- Different emotional states (neutral, worried, frustrated)
- Edge cases (very short inputs, very detailed inputs, complex multiple issues)

## Future Improvements

The prompt system can be enhanced by:
- Expanding language support with medical terminology libraries
- Adding specialized question sets for different age groups
- Incorporating feedback loops from doctor assessments
- Implementing adaptive importance scoring based on user demographics

## Security Considerations

- Ensure all health data is processed in compliance with relevant regulations
- Implement proper encryption for data in transit and at rest
- Follow data minimization principles in prompt engineering
- Maintain audit logs of all processing for accountability 