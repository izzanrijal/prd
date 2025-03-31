# Voice-to-Structured Text Processing Guideline

This document outlines the workflow and implementation guidelines for processing voice transcriptions into structured text for pediatric consultations in the AhliAnak platform.

## Overview

The voice-to-structured text process is a critical feature that enables mothers to express health concerns verbally while ensuring doctors receive clear, structured information. This two-stage process uses:

1. **Eleven Labs API** for high-quality voice transcription
2. **OpenAI API** for transforming transcriptions into structured medical narratives with clarifying questions

## Workflow Implementation

### 1. Voice Recording & Transcription

- User records voice message via the app's recording interface
- Audio file is sent to Eleven Labs API for transcription
- Raw transcription is returned as text

### 2. Structured Text Generation

- Transcription is sent to OpenAI with the "Pediatric Anamnesis Refiner" prompt
- Prompt instruction set guides OpenAI to:
  - Format text with minimal changes to user's wording
  - Generate relevant medical/parenting clarifying questions
  - Identify emotional urgency
  - Detect language used

### 3. Input JSON Structure

```json
{
  "transcript": "<transcription from Eleven Labs>",
  "currentStructuredSpeech": "<previous structured speech, if any>",
  "previousClarifyingQuestions": [
    {
      "question": "<previous question>",
      "answer": "<user's answer, if provided>",
      "importanceScore": <float value>
    }
  ],
  "languagePreference": "<language code or 'auto-detect'>"
}
```

### 4. Output JSON Structure

```json
{
  "structuredSpeech": "<formatted markdown text>",
  "clarifyingQuestions": [
    {
      "uuid": "<unique identifier>",
      "question": "<clarifying question>",
      "importanceScore": <float between 0.0-1.0>,
      "answer": ""
    }
  ],
  "emotionalUrgency": "<empty or 'High Stress'>",
  "languageDetected": "<language code>"
}
```

## Implementation Code Example

The following code demonstrates how to process a voice recording through the complete workflow:

```javascript
// 1. Process voice recording through Eleven Labs
async function processVoiceRecording(audioFileBuffer, consultationData) {
  try {
    // Step 1: Send to Eleven Labs for transcription
    const transcriptionResult = await elevenLabsClient.transcribe({
      audio: audioFileBuffer,
      language_detection: true // Enable automatic language detection
    });
    
    const transcription = transcriptionResult.text;
    const detectedLanguage = transcriptionResult.detected_language || "auto-detect";
    
    // Step 2: Prepare data for OpenAI
    const openAIInput = {
      transcript: transcription,
      currentStructuredSpeech: consultationData.currentStructuredSpeech || "",
      previousClarifyingQuestions: consultationData.previousClarifyingQuestions || [],
      languagePreference: consultationData.languagePreference || detectedLanguage,
      childProfile: consultationData.childProfile || null // Optional
    };
    
    // Step 3: Process with OpenAI
    const structuredData = await processWithOpenAI(openAIInput);
    
    // Step 4: Return the structured data for display
    return structuredData;
    
  } catch (error) {
    console.error("Error processing voice recording:", error);
    
    // Fallback: If transcription fails but we can't structure it
    return {
      structuredSpeech: "", // Empty since we couldn't get transcription
      clarifyingQuestions: [],
      emotionalUrgency: "",
      languageDetected: consultationData.languagePreference || "unknown"
    };
  }
}

// Process the input data with OpenAI
async function processWithOpenAI(inputData) {
  try {
    const response = await openai.chat.completions.create({
      model: "gpt-4-turbo",
      messages: [
        {
          role: "system", 
          content: PEDIATRIC_ANAMNESIS_REFINER_PROMPT // See full prompt in openai-prompt-implementation-guide.md
        },
        {
          role: "user",
          content: JSON.stringify(inputData)
        }
      ],
      response_format: { type: "json_object" },
      temperature: 0.2
    });
    
    // Parse and validate the response
    const rawResponse = response.choices[0].message.content;
    const parsedResponse = JSON.parse(rawResponse);
    
    // Validate required fields
    if (!parsedResponse.structuredSpeech) {
      throw new Error("Invalid response: missing structuredSpeech");
    }
    
    // Add UUIDs to questions if missing
    if (Array.isArray(parsedResponse.clarifyingQuestions)) {
      parsedResponse.clarifyingQuestions = parsedResponse.clarifyingQuestions.map(q => ({
        ...q,
        uuid: q.uuid || generateUUID()
      }));
    } else {
      parsedResponse.clarifyingQuestions = [];
    }
    
    return {
      structuredSpeech: parsedResponse.structuredSpeech,
      clarifyingQuestions: parsedResponse.clarifyingQuestions,
      emotionalUrgency: parsedResponse.emotionalUrgency || "",
      languageDetected: parsedResponse.languageDetected || inputData.languagePreference || "unknown"
    };
    
  } catch (error) {
    console.error("Error processing with OpenAI:", error);
    
    // Fallback: Return the original transcription as structured speech
    return {
      structuredSpeech: inputData.transcript || inputData.currentStructuredSpeech || "",
      clarifyingQuestions: [],
      emotionalUrgency: "",
      languageDetected: inputData.languagePreference || "unknown"
    };
  }
}

// Generate a UUID v4
function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}
```

This implementation includes proper error handling, fallbacks for failed API calls, and ensures the output always has valid UUIDs for clarifying questions.

## Implementation Guidelines

### Error Handling

- Implement timeout handling for both API calls
- Provide fallback options if either API fails:
  - Allow manual editing of raw transcription if Eleven Labs fails
  - Display raw transcription if OpenAI processing fails
- Log failures for quality improvement

### Front-end Integration

- Display structuredSpeech using markdown rendering
- Present clarifyingQuestions in order of importanceScore (highest first)
- Allow users to answer questions directly or dismiss irrelevant ones
- Visually highlight emotionalUrgency when present

### Performance Considerations

- Process transcription asynchronously to avoid blocking UI
- Implement progressive loading states
- Cache responses to prevent redundant API calls
- Set appropriate timeouts (recommended: 10s for transcription, 15s for OpenAI)

### Security & Privacy

- Ensure all API calls use secure connections (HTTPS)
- Do not persist raw audio longer than necessary
- Implement proper error messages that don't expose sensitive information
- Follow data minimization principles

### Accessibility

- Provide visual feedback during voice recording
- Ensure structured text and questions are properly read by screen readers
- Support keyboard navigation for answering clarifying questions

## Relationship to PRD Requirements

This implementation directly fulfills several user stories from the PRD:

- **Story 1 & 6**: Converting spoken concerns to structured texts
- **Story 7**: Generating immediate clarification questions
- **Story 8**: Dynamically updating questions based on additional input
- **Story 9**: Avoiding repetition of previously answered questions
- **Story 11**: Capturing emotional urgency

## Prompt Maintenance

The OpenAI prompt should be periodically reviewed and updated based on:

- User feedback
- Doctor feedback on structure quality
- Analysis of question relevance and importance scoring
- Language accuracy for multi-language support

## Technical Specifications

- **Eleven Labs API**: Use the latest transcription model with Indonesian language support
- **OpenAI API**: Use GPT-4 or later with the "Pediatric Anamnesis Refiner" system prompt
- **Response Format**: Ensure strict JSON validation to prevent parsing errors
- **UUID Generation**: Use v4 UUIDs for question identification

This guideline should be reviewed quarterly and updated based on performance metrics and user feedback. 