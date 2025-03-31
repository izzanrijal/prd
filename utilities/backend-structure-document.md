# Backend Structure Document for AhliAnak

This document outlines the backend structure for AhliAnak, a mobile platform designed to help Indonesian mothers become more confident, informed, and proactive in managing their children's health. The following sections detail the backend architecture, database management, API design, hosting, infrastructure components, security measures, monitoring and maintenance practices, and an overall summary.

## 1. Backend Architecture

The backend of AhliAnak is designed to support scalability, maintainability, and optimal performance for a mobile-first application. Key elements include:

- **Modular Design:** The system is divided into components such as authentication, child profile management, consultation workflows, payment processing, doctor discovery, and notification management. Each component is loosely coupled to ensure ease of updates and maintenance.

- **Frameworks & Services:**
  - **Supabase:** Serves as the comprehensive backend solution providing database, authentication, storage, and real-time capabilities.
  - **AI Integration:**
    - OpenAI API for generating structured summaries from voice inputs and health concerns.
    - ElevenLabs API for voice-to-text transcription in the consultation workflow.
  - **External Services:**
    - Flip.id for payment gateway integration.

- **Design Patterns:**
  - The backend uses RESTful API principles through Supabase's API layer.
  - Real-time updates for chat and notifications using Supabase's real-time subscriptions.
  - Serverless functions for complex business logic and third-party API integrations.

## 2. Database Management

AhliAnak leverages Supabase's PostgreSQL database for reliable, scalable data management:

- **Database Technology:**
  - **PostgreSQL:** Utilized through Supabase for structured data storage with powerful relational capabilities.
  - **Supabase Storage:** For voice notes, doctor responses, and other media content.

- **Data Storage & Access:**
  - Row-level security (RLS) policies to enforce data access controls based on user roles.
  - Optimized schema design for fast querying of consultation histories and child profiles.
  - Real-time subscription capabilities for chat interfaces and notifications.

- **Management Practices:**
  - Regular automated backups through Supabase.
  - Proper indexing strategies for frequently queried fields (consultation history, doctor search).
  - Versioned database migrations for controlled schema evolution.

## 3. Database Schema

The database schema, designed using PostgreSQL within Supabase, is organized as follows:

- **Users Table:** Contains user information, authentication details, and basic profile data.
  
- **Children Table:** Stores child profiles including age, weight, allergies, medical history, and other health-related information. Each child is linked to a parent user.
  
- **Doctors Table:** Contains doctor profiles including specialties, credentials, availability schedules, and response time metrics.
  
- **Consultations Table:** Tracks ongoing and completed consultations, linking children, parents, and doctors. Includes consultation type, payment status, and metadata.
  
- **Messages Table:** Stores all communication within consultations, including AI-processed voice transcripts, doctor responses, and clarification questions.
  
- **Payments Table:** Records payment transactions, including package type, amount, status, and Flip.id transaction references.
  
- **Notifications Table:** Manages push notifications and in-app alerts for doctor replies, payment confirmations, and system messages.

For a SQL view, a simplified PostgreSQL schema is as follows:

```sql
-- Users table (parents/mothers)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_id TEXT UNIQUE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  profile_picture_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  preferred_language TEXT DEFAULT 'id'
);

-- Children profiles
CREATE TABLE children (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  name TEXT NOT NULL,
  date_of_birth DATE,
  gender TEXT,
  weight DECIMAL,
  height DECIMAL,
  allergies TEXT[],
  medical_history TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Doctors profiles
CREATE TABLE doctors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_id TEXT UNIQUE,
  full_name TEXT NOT NULL,
  specialties TEXT[],
  credentials TEXT,
  profile_picture_url TEXT,
  availability_status BOOLEAN DEFAULT TRUE,
  response_time_minutes INTEGER,
  location TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Consultation sessions
CREATE TABLE consultations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  child_id UUID REFERENCES children(id),
  doctor_id UUID REFERENCES doctors(id),
  consultation_type TEXT NOT NULL, -- 'unlimited' or 'limited'
  status TEXT DEFAULT 'pending', -- 'pending', 'active', 'completed', 'canceled'
  payment_status TEXT DEFAULT 'pending', -- 'pending', 'paid', 'failed', 'refunded'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);

-- Messages within consultations
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  consultation_id UUID REFERENCES consultations(id),
  sender_type TEXT NOT NULL, -- 'parent', 'doctor', 'system'
  message_type TEXT NOT NULL, -- 'voice', 'text', 'ai_summary', 'clarification', 'final_answer'
  content TEXT,
  voice_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Payment transactions
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  consultation_id UUID REFERENCES consultations(id),
  user_id UUID REFERENCES users(id),
  amount DECIMAL NOT NULL,
  package_type TEXT NOT NULL, -- 'unlimited', 'limited'
  transaction_id TEXT, -- Reference to Flip.id transaction
  status TEXT DEFAULT 'pending', -- 'pending', 'completed', 'failed', 'refunded'
  receipt_url TEXT,
  promo_code TEXT,
  discount_amount DECIMAL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL, -- 'doctor_reply', 'payment_confirmation', 'system'
  consultation_id UUID REFERENCES consultations(id),
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Feedback and ratings
CREATE TABLE feedback (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  consultation_id UUID REFERENCES consultations(id),
  user_id UUID REFERENCES users(id),
  doctor_id UUID REFERENCES doctors(id),
  rating INTEGER,
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 4. API Design and Endpoints

The AhliAnak backend exposes a comprehensive set of API endpoints through Supabase:

- **Authentication APIs:**
  - User registration and login (email/password and Google Sign-In)
  - Password reset and account recovery
  - Session management

- **Profile Management APIs:**
  - User profile CRUD operations
  - Child profile creation, reading, updating, and deletion

- **Consultation APIs:**
  - Initiate consultation sessions
  - Record and transcribe voice notes via ElevenLabs API
  - Process and structure health concerns using OpenAI API
  - Retrieve consultation history for specific children

- **Doctor Discovery APIs:**
  - List and filter doctors by specialty, availability, and response time
  - View doctor profiles and credentials
  - Check doctor availability for new consultations

- **Payment Integration APIs:**
  - Initiate payment through Flip.id
  - Verify payment status and confirm transactions
  - Retrieve transaction history and generate receipts

- **Notification APIs:**
  - Manage push notifications for doctor replies
  - Handle in-app notification delivery and status
  - Configure notification preferences

## 5. Supabase Implementation Details

The AhliAnak backend leverages key Supabase features for efficient implementation:

- **Authentication:** Using Supabase Auth with custom email templates for verification and password reset flows.

- **Database:** PostgreSQL database with Row Level Security (RLS) policies to enforce data access controls based on authenticated users.

- **Storage:** Supabase Storage buckets for voice notes, profile pictures, and downloadable receipts.

- **Real-time:** Supabase's real-time subscriptions for the chat interface ensuring mothers receive immediate updates when doctors respond.

- **Edge Functions:** Serverless functions for complex business logic like AI processing of voice inputs and integration with ElevenLabs and OpenAI.

## 6. Security Measures

AhliAnak implements robust security measures appropriate for a mobile health application:

- **Authentication Security:**
  - JWT-based authentication through Supabase Auth
  - Secure password policies with minimum complexity requirements
  - Multi-factor authentication option for sensitive accounts
  - Token expiration and refresh mechanisms

- **Data Protection:**
  - Row Level Security (RLS) policies in PostgreSQL to enforce granular access controls
  - Encryption of sensitive data both in transit (HTTPS/TLS) and at rest
  - Secure storage of API keys for external services

- **Mobile Application Security:**
  - Certificate pinning for API communications
  - Secure local storage for sensitive data with proper encryption
  - Session timeout mechanisms for idle users
  - Biometric authentication support (fingerprint/face ID)

- **API Protection:**
  - Rate limiting to prevent abuse
  - Input validation and sanitization to prevent injection attacks
  - CORS policies properly configured

- **Compliance Considerations:**
  - Data privacy compliance with Indonesian regulations
  - Proper consent handling for health data
  - Audit logging for sensitive operations

## 7. Integration with External Services

The AhliAnak backend integrates with several external services:

- **OpenAI API Integration:**
  - Secure API key management
  - Prompt engineering for health context summarization
  - Error handling and fallback mechanisms
  - Response processing and formatting

- **ElevenLabs API Integration:**
  - Voice-to-text transcription pipeline
  - Audio quality optimization for mobile devices
  - Error handling for poor audio quality scenarios

- **Flip.id Payment Gateway:**
  - Secure payment initiation flow
  - Webhook handling for payment status updates
  - Transaction reconciliation and receipt generation
  - Error handling for failed or interrupted payments

- **Resend API for Transactional Emails:**
  - Email service implementation for transactional communications
  - HTML email template rendering with dynamic content
  - Email delivery status tracking and error handling
  - Webhook integration for email event processing (opens, clicks, bounces)
  - Localization support for email content in multiple languages
  - Email sending queue with retry mechanism for failed deliveries

## 8. Monitoring and Maintenance

The AhliAnak backend includes comprehensive monitoring and maintenance protocols:

- **Performance Monitoring:**
  - Supabase dashboard metrics for database performance
  - API endpoint response time tracking
  - Error rate monitoring and alerting

- **Resource Utilization:**
  - Database connection pool monitoring
  - Storage utilization tracking
  - API rate limit usage monitoring

- **Maintenance Procedures:**
  - Scheduled database backups and restoration testing
  - Regular security updates and patches
  - Database optimization (query performance, indexing)
  - Scheduled downtime management with user notifications

- **Error Handling:**
  - Standardized error responses across all endpoints
  - Comprehensive error logging with context
  - Critical error alerting system
  - Email delivery failure monitoring and recovery processes

## 9. Conclusion and Overall Backend Summary

The AhliAnak backend is thoughtfully structured to support a mobile platform that helps Indonesian mothers manage their children's health through voice-first interactions with certified pediatricians. Key highlights include:

- **Supabase-centric architecture** providing a comprehensive backend solution with authentication, database, storage, and real-time capabilities.
- **Sophisticated AI integration** with OpenAI for summarization and ElevenLabs for voice-to-text transcription.
- **Robust database schema** designed to efficiently manage user profiles, child health data, consultations, and payments.
- **Secure payment processing** via Flip.id with proper transaction reconciliation.
- **Reliable email communications system** via Resend API for transactional emails and user engagement.
- **Comprehensive security measures** appropriate for a healthcare application handling sensitive information.
- **Real-time capabilities** enabling responsive chat interfaces for mother-doctor interactions.
- **Monitoring and maintenance protocols** ensuring reliable operation and performance.

This backend structure aligns with AhliAnak's goal of creating a trusted platform where mothers can confidently engage with pediatricians about their children's health through an intuitive, voice-first interface. 