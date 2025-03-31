## Project Requirements Document (PRD)

### 1. Project Overview

AhliAnak is a mobile platform designed to help Indonesian mothers become more confident, informed, and proactive in managing their children's health. Built with a voice-first interface, the app allows moms to express their concerns through voice notes, which are intelligently structured into readable summaries using AI. Certified pediatricians then respond asynchronously via voice, and these responses are again transformed into clear, digestible text, keeping moms informed without overwhelming them.

The mobile app is specifically crafted for modern Indonesian moms—tech-savvy, mobile-native, and often balancing multiple responsibilities. Key features include an intuitive child profile system, async consultation chat with markdown-based rendering, an AI-powered voice-to-text pipeline, a pediatrician discovery engine, and structured feedback collection. Success is defined by high NPS, increased repeat consultations, and emotional trust built through clarity, consistency, and responsiveness.

---

### 2. In-Scope vs. Out-of-Scope

#### In-Scope

- **Voice-to-AI Consultation Interface**:
    - Moms submit voice notes, transcribed and structured by AI.
    - AI prompts clarification questions to improve medical context.
    - Manual edit option before submission.
- **Asynchronous Pediatrician Communication**:
    - Doctors respond with voice; AI generates structured summaries.
    - Markdown-rendered chat interface with labeled replies (e.g., Final vs Clarification).
    - Reply quota tracked by consultation type.
- **Child Profile Management**:
    - Create and manage multiple children with health context (age, allergies, etc.).
    - Profile switching in dashboard and chat interface.
    - Child-specific consultation timeline within each child's profile.
- **Consultation Packages & Payments**:
    - Two clear packages: Rp 50,000 unlimited (30 min), Rp 20,000 limited topic.
    - Input promotional code to get discounted fee before consultation
    - Flip.id integration with payment confirmation before chat opens.
- **Doctor Discovery & Filtering**:
    - Categorized by specialty, availability, proximity, and response speed.
    - Clear fees and credential visibility.
- **Dashboard & History Views**:
    - Personalized dashboard with ongoing consultations, blog content, child avatars.
    - Dashboard shows 1-2 recent consultations for quick access.
    - Separate history tab with keyword search and consultation records across all children.
    - "Restart Session" button on completed consultations to initiate a *new* paid session pre-selecting the same doctor (if available).
- **Notification System**:
    - Push + in-app notifications for replies, clarifications, feedback requests.
- **Feedback & Rating**:
    - In-session feedback prompts.
    - NPS after multiple sessions.
    - Transaction summary + downloadable receipts.

#### Out-of-Scope

- Real-time or video consultations.
- Offline-first capabilities.
- Growth milestone charts or diagnostic tools (Phase 2+).
- Multi-parent (e.g. shared profile) support in this MVP.

---

### 3. User Flow

A first-time user downloads the AhliAnak app and goes through 3–5 onboarding screens introducing the app. She creates an account via Gmail or email/password and is guided to create her first child's profile. 

The primary navigation is handled by a bottom navbar with five tabs: Beranda (Dashboard), Anak (Children Profiles), Ahli (Doctor Discovery), Riwayat (Consultation History), and Profil (User Profile & Settings).

From the Beranda (Dashboard), users can view 1-2 recent consultations (or all active consultation) and can start a new consultation for the recent non-active one. To begin a new consultation, the user is directed to the Ahli (Doctor Discovery) screen to select a pediatrician based on their specialty, availability, and other filters. After selecting a doctor, she proceeds to payment via Flip.id. 

Once payment is confirmed, the user is asked whether this consultation is regarding a specific child (and must select which child) or if it's about general parenting. Then she can record a voice note describing her health concern.

The system uses AI to generate a structured summary and follow-up questions, which the mom can confirm and edit before sending to the doctor. The async chat opens with markdown-rendered messages. The mom receives push notifications when doctors respond, and at the end of the session, she is prompted for feedback and rating. 

Within each child's profile (accessible via the Anak tab or dashboard avatars), there is a dedicated consultation timeline specific to that child. For a general history view across all children, the mom can access the separate Riwayat (History) tab. From the dashboard widget showing recent completed consultations or from the Riwayat tab, she can use the "Restart Session" button. If the original doctor is available, this initiates a new consultation purchase flow (payment, question type selection, voice note recording) pre-selecting that doctor. If the doctor is unavailable, the user is notified and directed to the Ahli tab to choose a different doctor. The Profil tab allows access to user settings and profile management.

---

### 4. Core Features

#### Navigation
- Bottom Navbar with 5 Tabs: Beranda (Dashboard), Anak (Children), Ahli (Doctors), Riwayat (History), Profil (Profile).

#### Voice-to-AI Consultation Interface

- Record voice → Structured AI summary
- Auto-generated follow-up questions
- Manual edit option for summary
- "Emotional urgency" tagging

#### Pediatrician Discovery

- Doctor list with filters: specialty, proximity, availability
- Response time estimate + credentials
- "Quick consult" for previous doctors
- Greyed-out unavailable doctors

#### Consultation Chat (Async)

- Markdown-rendered chat interface
- Labels for "Doctor Clarification" vs "Final Answer"
- AI summarizes doctor voice reply
- Tracks quota (if limited topic package)

#### Child Profile Management

- Add/edit multiple children
- Avatars, quick switching, dedicated health timeline
- Key info: age, allergies, history

#### Dashboard & History

- Personalized dashboard (Beranda Tab): active consults, blog, avatars
- Age-personalized blog widget
- Child profile management (Anak Tab & Profile Tab)
- Doctor Discovery (Ahli Tab)
- Searchable consultation history (Riwayat Tab)
- "Restart Session" CTA for past completed chats (initiates a *new* paid consultation, pre-selecting the same doctor if available)

#### Payment Integration

- Flip.id integration
- Two clear packages (Rp 50k / Rp 20k)
- Input promotional code to get discounted fee before consultation
- In-session blocking until payment confirmed
- Transaction history + receipt download

#### Notifications

- Push & in-app for doctor replies, clarifications
- Email notifications via Resend API for critical updates
- Feedback reminders
- Smart sorting (relevance + timestamp)

#### Feedback & NPS

- Feedback form after session
- In-app NPS after ≥2 sessions
- Optional text feedback to improve trust

---

### 5. Tech Stack & Tools

#### Frontend

- React Native (mobile app)
- Expo (build & deployment)

#### Backend

- Supabase (auth, DB, storage)
- Flip.id (payment gateway)
- Resend API (transactional email service)

#### AI Integration

- OpenAI API (transcription, summarization, clarifications)
- Real-time processing of structured speech using ElevenLabs API

#### Chat Interface

- Markdown-rendered async chat (React Native plugin)

#### Search Engine

- Elasticsearch (consultation history & doctor filtering)

---

### 6. Non-Functional Requirements

#### Performance

- App launches <2 seconds
- Consultation summary generated in <10 seconds
- Elastic search responses <1 second

#### Security

- Auth via Supabase
- Secure Flip.id payment redirection
- User data encrypted at rest and in transit

#### Usability & Accessibility

- Bahasa Indonesia as default
- Simple UI, tap-to-record, intuitive prompts
- Clear language switcher

#### Scalability & Reliability

- Built for async scale (voice note queueing)
- Handles high concurrency for doctor inbox & consults

---

### 7. Constraints & Assumptions

- Requires stable internet connection for key flows.
- AI-generated summaries may need manual correction in edge cases.
- Doctors must be pre-vetted and onboarded manually.
- Async reply window depends on doctor availability (max 12 hours SLA).
- Flip.id supports mobile redirect and webhook callback confirmation.

---

### 8. Known Issues & Potential Pitfalls

#### AI Quality Gaps

- Transcription errors (e.g., in noisy environments)
- Incorrect summary tagging (e.g., missed emotional urgency)

#### Payment Edge Cases

- Network failure during Flip.id payment redirect
- User closes app before confirmation returned

#### Voice Note Upload Errors

- Large files or bad network may fail uploads
- Retry system and offline drafts must be supported

#### Clarification Overload

- AI may generate too many clarifications
- Cap on number of follow-ups per consultation to avoid fatigue

### 9. Emailing System

#### Transactional Emails

- **Account Verification and Password Reset**:
  - Verification emails for new account registration
  - Secure password reset links with expiration
  - Branded email templates with localization support

- **Consultation Updates**:
  - Email notifications for doctor responses
  - Receipt and payment confirmation emails
  - Consultation summary emails

- **Engagement Emails**:
  - Follow-up emails for abandoned consultations
  - Reminder emails for pending feedback
  - Periodic health tips based on child age

#### Implementation

- **Resend API Integration**:
  - Reliable delivery with tracking capabilities
  - HTML templates with responsive design
  - Dynamic content insertion for personalization
  - Support for both Bahasa Indonesia and English

- **Email Preferences**:
  - Granular control over email notification types
  - Opt-out options for marketing vs. essential emails
  - Email frequency management

#### Edge Cases & Error Handling

- Email delivery failure tracking and retry mechanisms
- Fallback to in-app notifications when email delivery fails
- Handling of invalid or changed email addresses
