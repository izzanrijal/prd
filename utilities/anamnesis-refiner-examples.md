# Pediatric Anamnesis Refiner Examples

This document provides example input/output pairs for the Pediatric Anamnesis Refiner system to demonstrate expected behavior across different scenarios.

## Example 1: Fever with Limited Information (Indonesian)

### Input
```json
{
  "transcript": "Anak saya demam dari kemarin malam. Saya sudah kasih paracetamol tapi masih panas.",
  "currentStructuredSpeech": "",
  "previousClarifyingQuestions": [],
  "languagePreference": "id"
}
```

### Output
```json
{
  "structuredSpeech": "Anak saya **demam** dari kemarin malam. Saya sudah kasih paracetamol tapi masih **panas**.",
  "clarifyingQuestions": [
    {
      "uuid": "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890",
      "question": "Berapa suhu anak Anda ketika terakhir diukur?",
      "importanceScore": 0.85,
      "answer": ""
    },
    {
      "uuid": "b2c3d4e5-f6a7-8901-b2c3-d4e5f6a78901",
      "question": "Apakah anak Anda menunjukkan gejala lain seperti batuk, pilek, atau ruam?",
      "importanceScore": 0.8,
      "answer": ""
    },
    {
      "uuid": "c3d4e5f6-a7b8-9012-c3d4-e5f6a7b89012",
      "question": "Apakah anak Anda masih mau makan dan minum seperti biasa?",
      "importanceScore": 0.9,
      "answer": ""
    },
    {
      "uuid": "d4e5f6a7-b8c9-0123-d4e5-f6a7b8c90123",
      "question": "Berapa usia anak Anda?",
      "importanceScore": 0.75,
      "answer": ""
    },
    {
      "uuid": "e5f6a7b8-c9d0-1234-e5f6-a7b8c9d01234",
      "question": "Apakah anak Anda tetap aktif atau lebih lemas dari biasanya?",
      "importanceScore": 0.85,
      "answer": ""
    },
    {
      "uuid": "f6a7b8c9-d0e1-2345-f6a7-b8c9d0e12345",
      "question": "Apakah ada riwayat kontak dengan orang sakit?",
      "importanceScore": 0.7,
      "answer": ""
    },
    {
      "uuid": "a7b8c9d0-e1f2-3456-a7b8-c9d0e1f23456",
      "question": "Apakah anak Anda sudah mendapatkan imunisasi lengkap sesuai usianya?",
      "importanceScore": 0.65,
      "answer": ""
    }
  ],
  "emotionalUrgency": "",
  "languageDetected": "id"
}
```

## Example 2: Multiple Symptoms with Answered Questions (English)

### Input
```json
{
  "transcript": "My son has had diarrhea for two days now and today he started vomiting too. I'm getting worried because he doesn't want to drink anything.",
  "currentStructuredSpeech": "My son has had diarrhea for two days.",
  "previousClarifyingQuestions": [
    {
      "question": "How old is your son?",
      "answer": "He's 3 years old",
      "importanceScore": 0.75
    },
    {
      "question": "Has he had a fever?",
      "answer": "Yes, around 38.5°C this morning",
      "importanceScore": 0.8
    },
    {
      "question": "Is he still urinating normally?",
      "answer": "",
      "importanceScore": 0.9
    }
  ],
  "languagePreference": "en"
}
```

### Output
```json
{
  "structuredSpeech": "My 3-year-old son has had **diarrhea** for two days now and today he started **vomiting** too. He has a **fever** of around 38.5°C measured this morning. I'm getting worried because he doesn't want to drink anything.",
  "clarifyingQuestions": [
    {
      "uuid": "b2c3d4e5-f6a7-8901-b2c3-d4e5f6a78901",
      "question": "Is he still urinating normally?",
      "importanceScore": 0.9,
      "answer": ""
    },
    {
      "uuid": "c3d4e5f6-a7b8-9012-c3d4-e5f6a7b89012",
      "question": "How many times has he vomited today?",
      "importanceScore": 0.85,
      "answer": ""
    },
    {
      "uuid": "d4e5f6a7-b8c9-0123-d4e5-f6a7b8c90123",
      "question": "What is the appearance of his diarrhea (watery, bloody, mucus)?",
      "importanceScore": 0.85,
      "answer": ""
    },
    {
      "uuid": "e5f6a7b8-c9d0-1234-e5f6-a7b8c9d01234",
      "question": "Are there any signs of dehydration (dry mouth, sunken eyes, no tears when crying)?",
      "importanceScore": 0.95,
      "answer": ""
    },
    {
      "uuid": "f6a7b8c9-d0e1-2345-f6a7-b8c9d0e12345",
      "question": "Has he been exposed to anyone with similar symptoms?",
      "importanceScore": 0.7,
      "answer": ""
    },
    {
      "uuid": "a7b8c9d0-e1f2-3456-a7b8-c9d0e1f23456",
      "question": "Has he been eating anything different lately?",
      "importanceScore": 0.65,
      "answer": ""
    },
    {
      "uuid": "b8c9d0e1-f2a3-4567-b8c9-d0e1f2a34567",
      "question": "Is he showing any signs of abdominal pain?",
      "importanceScore": 0.8,
      "answer": ""
    }
  ],
  "emotionalUrgency": "High Stress",
  "languageDetected": "en"
}
```

## Example 3: Developmental Concern (Indonesian with Local Dialect)

### Input
```json
{
  "transcript": "Saya khawatir sama anak saya karena dia belum bisa bicara dengan jelas padahal sudah 2 tahun lebih. Teman-temannya yang seumuran sudah pada bisa ngomong lancar. Dia cuma bisa sebut satu-satu kata kaya 'mama' sama 'papa' tapi belum bisa gabung jadi kalimat ki.",
  "currentStructuredSpeech": "",
  "previousClarifyingQuestions": [],
  "languagePreference": "id"
}
```

### Output
```json
{
  "structuredSpeech": "Saya khawatir dengan anak saya karena dia belum bisa bicara dengan jelas padahal sudah 2 tahun lebih. Teman-temannya yang seumuran sudah bisa berbicara lancar. Dia cuma bisa menyebut satu-satu kata seperti 'mama' dan 'papa' tapi belum bisa menggabungkan menjadi kalimat.",
  "clarifyingQuestions": [
    {
      "uuid": "c3d4e5f6-a7b8-9012-c3d4-e5f6a7b89012",
      "question": "Apakah anak Anda mengerti instruksi atau perintah sederhana yang Anda berikan?",
      "importanceScore": 0.85,
      "answer": ""
    },
    {
      "uuid": "d4e5f6a7-b8c9-0123-d4e5-f6a7b8c90123",
      "question": "Apakah perkembangan motorik (berjalan, memegang benda) anak Anda normal?",
      "importanceScore": 0.8,
      "answer": ""
    },
    {
      "uuid": "e5f6a7b8-c9d0-1234-e5f6-a7b8c9d01234",
      "question": "Apakah ada riwayat keterlambatan bicara dalam keluarga?",
      "importanceScore": 0.7,
      "answer": ""
    },
    {
      "uuid": "f6a7b8c9-d0e1-2345-f6a7-b8c9d0e12345",
      "question": "Bagaimana kemampuan sosial anak Anda? Apakah dia berinteraksi dengan anak lain?",
      "importanceScore": 0.85,
      "answer": ""
    },
    {
      "uuid": "a7b8c9d0-e1f2-3456-a7b8-c9d0e1f23456",
      "question": "Apakah ada riwayat infeksi telinga berulang pada anak Anda?",
      "importanceScore": 0.75,
      "answer": ""
    },
    {
      "uuid": "b8c9d0e1-f2a3-4567-b8c9-d0e1f2a34567",
      "question": "Apakah anak Anda menunjukkan minat terhadap buku atau saat Anda membacakan cerita?",
      "importanceScore": 0.7,
      "answer": ""
    },
    {
      "uuid": "c9d0e1f2-a3b4-5678-c9d0-e1f2a3b45678",
      "question": "Berapa banyak kata yang sudah bisa diucapkan oleh anak Anda saat ini?",
      "importanceScore": 0.8,
      "answer": ""
    },
    {
      "uuid": "d0e1f2a3-b4c5-6789-d0e1-f2a3b4c56789",
      "question": "Apakah anak Anda pernah mengalami keterlambatan perkembangan lainnya?",
      "importanceScore": 0.75,
      "answer": ""
    }
  ],
  "emotionalUrgency": "High Stress",
  "languageDetected": "id"
}
```

## Example 4: Mild Concern with Child Profile Data (English)

### Input
```json
{
  "transcript": "Emma has been scratching her skin a lot lately, especially at night. I noticed some small red bumps on her arms and legs.",
  "currentStructuredSpeech": "",
  "previousClarifyingQuestions": [],
  "languagePreference": "en",
  "childProfile": {
    "name": "Emma",
    "age": "4 years",
    "knownAllergies": ["peanuts", "dust mites"]
  }
}
```

### Output
```json
{
  "structuredSpeech": "Emma (4 years) has been **scratching her skin** a lot lately, especially at night. I noticed some small **red bumps** on her arms and legs. She has known allergies to peanuts and dust mites.",
  "clarifyingQuestions": [
    {
      "uuid": "d4e5f6a7-b8c9-0123-d4e5-f6a7b8c90123",
      "question": "When did you first notice the red bumps?",
      "importanceScore": 0.75,
      "answer": ""
    },
    {
      "uuid": "e5f6a7b8-c9d0-1234-e5f6-a7b8c9d01234",
      "question": "Have there been any changes in her environment recently (new bedding, soaps, detergents)?",
      "importanceScore": 0.8,
      "answer": ""
    },
    {
      "uuid": "f6a7b8c9-d0e1-2345-f6a7-b8c9d0e12345",
      "question": "Has she eaten any new foods in the past few days?",
      "importanceScore": 0.75,
      "answer": ""
    },
    {
      "uuid": "a7b8c9d0-e1f2-3456-a7b8-c9d0e1f23456",
      "question": "Does anyone else in the household have similar symptoms?",
      "importanceScore": 0.7,
      "answer": ""
    },
    {
      "uuid": "b8c9d0e1-f2a3-4567-b8c9-d0e1f2a34567",
      "question": "Has she had a fever or any other symptoms?",
      "importanceScore": 0.7,
      "answer": ""
    },
    {
      "uuid": "c9d0e1f2-a3b4-5678-c9d0-e1f2a3b45678",
      "question": "Have you tried any treatments for the rash so far?",
      "importanceScore": 0.6,
      "answer": ""
    },
    {
      "uuid": "d0e1f2a3-b4c5-6789-d0e1-f2a3b4c56789",
      "question": "Do the bumps appear to be spreading or changing in appearance?",
      "importanceScore": 0.8,
      "answer": ""
    }
  ],
  "emotionalUrgency": "",
  "languageDetected": "en"
}
```

## Testing Notes

The examples above demonstrate several key capabilities:

1. **Language Support** - Both Indonesian and English processing
2. **Dialect Normalization** - Converting informal dialect expressions to standard language
3. **Question Prioritization** - Higher importance scores for critical medical concerns
4. **Information Integration** - Merging existing structured text with new transcriptions
5. **Profile Data Inclusion** - Naturally incorporating child profile data when relevant
6. **Emotional Detection** - Correctly identifying high stress situations
7. **Answer Integration** - Incorporating previously answered questions into structured text

When reviewing prompt performance, check that:
- Original meaning is preserved with minimal rewording
- Critical symptoms are properly emphasized
- Questions are relevant to the specific health concern
- Previously answered questions are not repeated
- Language detection works across various dialects and accents

These examples should be used as benchmarks during implementation and future refinements of the Pediatric Anamnesis Refiner system. 