# Implementation Plan

## Setup & Configuration

- [ ] Step 1: Initialize Next.js project with TypeScript
  - **Task**: Create a new Next.js project with TypeScript support, configure ESLint, Prettier, and setup basic folder structure
  - **Files**:
    - `package.json`: Package dependencies
    - `tsconfig.json`: TypeScript configuration
    - `.eslintrc.js`: ESLint configuration
    - `.prettierrc`: Prettier configuration
    - `.editorconfig`: Editor configuration
    - `.gitignore`: Git ignore file
    - `next.config.js`: Next.js configuration
    - `README.md`: Project documentation
  - **Step Dependencies**: None
  - **User Instructions**: Run `npx create-next-app@latest ahlianak-web --typescript --eslint` and then set up the additional config files

- [ ] Step 2: Set up Supabase integration
  - **Task**: Integrate Supabase client for authentication, database, and storage services
  - **Files**:
    - `src/lib/supabase.ts`: Supabase client configuration
    - `.env.local`: Environment variables (sample)
    - `.env.example`: Example environment variables
    - `src/types/supabase.ts`: Supabase type definitions
  - **Step Dependencies**: Step 1
  - **User Instructions**: 
    1. Create a Supabase account at https://supabase.com/
    2. Create a new project in Supabase dashboard
    3. Obtain API keys from the project settings
    4. Add the keys to your `.env.local` file
    5. Install Supabase client with `npm install @supabase/supabase-js`

- [ ] Step 3: Set up React Native core modules and components
  - **Task**: Configure and set up essential React Native modules and components for the application
  - **Files**:
    - `src/styles/theme.ts`: Theme configuration for consistent styling
    - `src/app/providers.tsx`: Provider wrapper for app-wide configurations
    - `src/components/ui/`: Directory for reusable UI components
  - **Step Dependencies**: Step 1
  - **User Instructions**: Leverage React Native's built-in components and styling system

- [ ] Step 4: Configure internationalization with next-intl
  - **Task**: Set up internationalization support with next-intl for Bahasa Indonesia and English
  - **Files**:
    - `src/i18n/settings.ts`: Internationalization configuration
    - `src/i18n/messages/en.json`: English translations
    - `src/i18n/messages/id.json`: Indonesian translations
    - `src/middleware.ts`: Middleware for i18n routing
    - `next.config.js`: Update with i18n configuration
  - **Step Dependencies**: Step 1
  - **User Instructions**: Run `npm install next-intl`

## Database Setup

- [ ] Step 5: Set up database schema in Supabase
  - **Task**: Create database tables and relationships in Supabase as defined in the schema
  - **Files**:
    - `database/schema.sql`: SQL schema for Supabase
  - **Step Dependencies**: Step 2
  - **User Instructions**: 
    1. Go to the SQL Editor in Supabase dashboard
    2. Copy the contents of `database/schema.sql` 
    3. Execute the SQL in the Supabase SQL Editor

- [ ] Step 6: Configure Row Level Security (RLS) policies
  - **Task**: Implement Row Level Security policies for database tables
  - **Files**:
    - `database/rls-policies.sql`: SQL for RLS policies
  - **Step Dependencies**: Step 5
  - **User Instructions**: 
    1. Go to the SQL Editor in Supabase dashboard
    2. Copy the contents of `database/rls-policies.sql`
    3. Execute the SQL in the Supabase SQL Editor

- [ ] Step 7: Set up storage buckets and policies
  - **Task**: Create Supabase storage buckets for voice notes, profile pictures, and receipts with appropriate access policies
  - **Files**:
    - `database/storage-buckets.sql`: SQL for storage buckets and policies
  - **Step Dependencies**: Step 5
  - **User Instructions**: 
    1. Go to the SQL Editor in Supabase dashboard
    2. Copy the contents of `database/storage-buckets.sql`
    3. Execute the SQL in the Supabase SQL Editor
    4. Verify buckets are created in the Storage section of Supabase dashboard

## Authentication

- [ ] Step 8: Create authentication context and hooks
  - **Task**: Create authentication context for managing user authentication state
  - **Files**:
    - `src/contexts/AuthContext.tsx`: Authentication context provider
    - `src/hooks/useAuth.ts`: Custom hook for auth operations
    - `src/types/auth.ts`: Authentication types
  - **Step Dependencies**: Step 2
  - **User Instructions**: None

- [ ] Step 9: Implement sign-up and sign-in components
  - **Task**: Create components for user registration and login with email/password and Google
  - **Files**:
    - `src/components/auth/SignUpForm.tsx`: User registration form
    - `src/components/auth/SignInForm.tsx`: User login form
    - `src/components/auth/GoogleAuthButton.tsx`: Google authentication button
    - `src/app/(auth)/sign-up/page.tsx`: Sign-up page
    - `src/app/(auth)/sign-in/page.tsx`: Sign-in page
  - **Step Dependencies**: Step 3, Step 8
  - **User Instructions**: 
    1. Enable Email/Password and Google providers in Supabase Auth settings
    2. Configure redirect URLs in Supabase Auth settings
    3. For Google auth, set up Google OAuth credentials and add them to Supabase

- [ ] Step 10: Implement password reset flow
  - **Task**: Create components and APIs for password reset functionality
  - **Files**:
    - `src/components/auth/ForgotPasswordForm.tsx`: Password reset request form
    - `src/components/auth/ResetPasswordForm.tsx`: New password form
    - `src/app/(auth)/forgot-password/page.tsx`: Forgot password page
    - `src/app/(auth)/reset-password/page.tsx`: Reset password page
  - **Step Dependencies**: Step 8, Step 9
  - **User Instructions**: Configure email templates in Supabase Auth settings for password reset

- [ ] Step 11: Implement auth middleware for protected routes
  - **Task**: Create middleware for route protection and redirection
  - **Files**:
    - `src/middleware.ts`: Update with auth protection
    - `src/app/api/auth/[...nextauth]/route.ts`: NextAuth API route
  - **Step Dependencies**: Step 8
  - **User Instructions**: None

## Core Layout and Navigation

- [ ] Step 12: Create base layout components and navigation
  - **Task**: Create layout components for the application structure
  - **Files**:
    - `src/components/layout/AppLayout.tsx`: Main app layout with navbar
    - `src/components/layout/AuthLayout.tsx`: Layout for auth pages
    - `src/components/layout/BottomNavbar.tsx`: Bottom navigation bar
    - `src/app/layout.tsx`: Root layout with providers
  - **Step Dependencies**: Step 3
  - **User Instructions**: Use React Native's core components for layouts and navigation

- [ ] Step 13: Implement bottom navigation bar
  - **Task**: Create the bottom navbar with 5 tabs as per the design
  - **Files**:
    - `src/components/layout/BottomNavbar.tsx`: Bottom navigation bar component
    - `src/components/layout/NavbarIcon.tsx`: Icon component for navigation items
    - `src/styles/navbar.css`: Navigation bar styles
  - **Step Dependencies**: Step 12
  - **User Instructions**: None

- [ ] Step 14: Create onboarding flow
  - **Task**: Implement the onboarding screens with intro carousel
  - **Files**:
    - `src/components/onboarding/OnboardingCarousel.tsx`: Onboarding carousel component
    - `src/components/onboarding/OnboardingScreen.tsx`: Individual onboarding screen
    - `src/app/(auth)/onboarding/page.tsx`: Onboarding page
  - **Step Dependencies**: Step 3, Step 4
  - **User Instructions**: None

## Profile Management

- [ ] Step 15: Implement user profile context and API
  - **Task**: Create context and API functions for user profile management
  - **Files**:
    - `src/contexts/ProfileContext.tsx`: Profile context provider
    - `src/hooks/useProfile.ts`: Custom hook for profile operations
    - `src/services/profile.ts`: Profile API service
    - `src/types/profile.ts`: Profile types
  - **Step Dependencies**: Step 2, Step 8
  - **User Instructions**: None

- [ ] Step 16: Create user profile completion components
  - **Task**: Create components for completing user profile after registration
  - **Files**:
    - `src/components/profile/ProfileCompletionForm.tsx`: Profile completion form
    - `src/app/(auth)/complete-profile/page.tsx`: Profile completion page
  - **Step Dependencies**: Step 15
  - **User Instructions**: None

- [ ] Step 17: Implement child profile management components
  - **Task**: Create components for adding and managing child profiles
  - **Files**:
    - `src/components/child/ChildProfileForm.tsx`: Child profile form
    - `src/components/child/ChildProfileCard.tsx`: Child profile card
    - `src/components/child/ChildProfileList.tsx`: List of child profiles
    - `src/app/(protected)/anak/page.tsx`: Children page
    - `src/app/(protected)/anak/[id]/page.tsx`: Child detail page
    - `src/app/(protected)/anak/add/page.tsx`: Add child page
    - `src/app/(protected)/anak/[id]/edit/page.tsx`: Edit child page
  - **Step Dependencies**: Step 15
  - **User Instructions**: None

## Dashboard (Beranda)

- [ ] Step 18: Create dashboard context and API
  - **Task**: Create context and API functions for dashboard data
  - **Files**:
    - `src/contexts/DashboardContext.tsx`: Dashboard context provider
    - `src/hooks/useDashboard.ts`: Custom hook for dashboard data
    - `src/services/dashboard.ts`: Dashboard API service
    - `src/types/dashboard.ts`: Dashboard types
  - **Step Dependencies**: Step 2, Step 8
  - **User Instructions**: None

- [ ] Step 19: Implement dashboard components
  - **Task**: Create components for the dashboard (Beranda) page
  - **Files**:
    - `src/components/dashboard/ChildAvatars.tsx`: Child avatars component
    - `src/components/dashboard/ConsultationWidget.tsx`: Recent consultations widget
    - `src/components/dashboard/BlogContent.tsx`: Blog content widget
    - `src/components/dashboard/NewConsultationButton.tsx`: New consultation button
    - `src/app/(protected)/page.tsx`: Dashboard page (root route)
  - **Step Dependencies**: Step 18
  - **User Instructions**: None

- [ ] Step 20: Create blog article components
  - **Task**: Create components for displaying blog articles
  - **Files**:
    - `src/components/blog/BlogCard.tsx`: Blog card component
    - `src/components/blog/BlogList.tsx`: Blog list component
    - `src/app/(protected)/blog/[id]/page.tsx`: Blog article page
  - **Step Dependencies**: Step 19
  - **User Instructions**: None

## Doctor Discovery (Ahli)

- [ ] Step 21: Create doctor discovery context and API
  - **Task**: Create context and API functions for doctor discovery
  - **Files**:
    - `src/contexts/DoctorContext.tsx`: Doctor context provider
    - `src/hooks/useDoctor.ts`: Custom hook for doctor operations
    - `src/services/doctor.ts`: Doctor API service
    - `src/types/doctor.ts`: Doctor types
  - **Step Dependencies**: Step 2, Step 8
  - **User Instructions**: None

- [ ] Step 22: Implement doctor discovery components
  - **Task**: Create components for the doctor discovery (Ahli) page
  - **Files**:
    - `src/components/doctor/DoctorCard.tsx`: Doctor card component
    - `src/components/doctor/DoctorList.tsx`: Doctor list component
    - `src/components/doctor/SpecialtyFilter.tsx`: Filter component for specialties
    - `src/app/(protected)/ahli/page.tsx`: Doctor discovery page
    - `src/app/(protected)/ahli/[id]/page.tsx`: Doctor detail page
  - **Step Dependencies**: Step 21
  - **User Instructions**: None

## Consultation Management

- [ ] Step 23: Create consultation context and API
  - **Task**: Create context and API functions for consultation management
  - **Files**:
    - `src/contexts/ConsultationContext.tsx`: Consultation context provider
    - `src/hooks/useConsultation.ts`: Custom hook for consultation operations
    - `src/services/consultation.ts`: Consultation API service
    - `src/types/consultation.ts`: Consultation types
  - **Step Dependencies**: Step 2, Step 8
  - **User Instructions**: None

- [ ] Step 24: Implement consultation history components
  - **Task**: Create components for viewing consultation history
  - **Files**:
    - `src/components/consultation/ConsultationHistoryItem.tsx`: History item component
    - `src/components/consultation/ConsultationHistoryList.tsx`: History list component
    - `src/components/consultation/ConsultationSearch.tsx`: Search component
    - `src/app/(protected)/riwayat/page.tsx`: History page
    - `src/app/(protected)/riwayat/[id]/page.tsx`: Consultation detail page
  - **Step Dependencies**: Step 23
  - **User Instructions**: None

- [ ] Step 25: Implement consultation flow - Package selection
  - **Task**: Create components for selecting consultation package
  - **Files**:
    - `src/components/consultation/PackageSelector.tsx`: Package selection component
    - `src/components/consultation/PromoCodeInput.tsx`: Promo code input component
    - `src/app/(protected)/consultations/new/packages/page.tsx`: Package selection page
  - **Step Dependencies**: Step 23
  - **User Instructions**: None

## Payment Integration

- [ ] Step 26: Create payment context and API
  - **Task**: Create context and API functions for payment processing
  - **Files**:
    - `src/contexts/PaymentContext.tsx`: Payment context provider
    - `src/hooks/usePayment.ts`: Custom hook for payment operations
    - `src/services/payment.ts`: Payment API service
    - `src/types/payment.ts`: Payment types
  - **Step Dependencies**: Step 2, Step 8
  - **User Instructions**: None

- [ ] Step 27: Implement Flip.id payment integration
  - **Task**: Create components and API routes for Flip.id payment integration
  - **Files**:
    - `src/components/payment/PaymentInitiator.tsx`: Payment initiation component
    - `src/components/payment/PaymentConfirmation.tsx`: Payment confirmation component
    - `src/app/api/payments/initiate/route.ts`: Payment initiation API
    - `src/app/api/payments/callback/route.ts`: Payment callback API
    - `src/app/(protected)/consultations/new/payment/page.tsx`: Payment page
    - `src/app/(protected)/consultations/new/payment/success/page.tsx`: Payment success page
    - `src/app/(protected)/consultations/new/payment/failure/page.tsx`: Payment failure page
  - **Step Dependencies**: Step 26
  - **User Instructions**: 
    1. Register for a Flip.id developer account
    2. Obtain API keys from Flip.id dashboard
    3. Add the keys to your `.env.local` file
    4. Configure webhook URLs in Flip.id dashboard

- [ ] Step 28: Implement transaction history components
  - **Task**: Create components for viewing transaction history
  - **Files**:
    - `src/components/payment/TransactionItem.tsx`: Transaction item component
    - `src/components/payment/TransactionList.tsx`: Transaction list component
    - `src/components/payment/ReceiptDownload.tsx`: Receipt download component
    - `src/app/(protected)/profile/transactions/page.tsx`: Transaction history page
    - `src/app/(protected)/profile/transactions/[id]/page.tsx`: Transaction detail page
  - **Step Dependencies**: Step 26
  - **User Instructions**: None

## Voice Recording and AI Integration

- [ ] Step 29: Set up OpenAI and ElevenLabs API integration
  - **Task**: Create API client and service functions for AI integrations
  - **Files**:
    - `src/lib/openai.ts`: OpenAI client configuration
    - `src/lib/elevenlabs.ts`: ElevenLabs client configuration
    - `src/services/ai.ts`: AI service functions
    - `src/types/ai.ts`: AI types
  - **Step Dependencies**: Step 1
  - **User Instructions**: 
    1. Register for OpenAI API access at https://openai.com/
    2. Register for ElevenLabs API access at https://elevenlabs.io/
    3. Obtain API keys and add them to your `.env.local` file

- [ ] Step 30: Create voice recording components
  - **Task**: Create components for voice recording and playback
  - **Files**:
    - `src/components/voice/VoiceRecorder.tsx`: Voice recording component
    - `src/components/voice/VoicePlayer.tsx`: Voice playback component
    - `src/components/voice/WaveformVisualizer.tsx`: Audio waveform visualization
    - `src/hooks/useAudioRecording.ts`: Custom hook for audio recording
    - `src/hooks/useAudioPlayback.ts`: Custom hook for audio playback
  - **Step Dependencies**: Step 29
  - **User Instructions**: None

- [ ] Step 31: Implement transcription and AI summary components
  - **Task**: Create components for transcription and AI summary generation
  - **Files**:
    - `src/components/consultation/TranscriptionEditor.tsx`: Transcription editor component
    - `src/components/consultation/AISummary.tsx`: AI summary component
    - `src/components/consultation/ClarifyingQuestions.tsx`: Follow-up questions component
    - `src/app/(protected)/consultations/new/question/page.tsx`: Voice recording page
    - `src/app/(protected)/consultations/new/review/page.tsx`: Summary review page
  - **Step Dependencies**: Step 30
  - **User Instructions**: None

## Chat Interface

- [ ] Step 32: Create chat context and API
  - **Task**: Create context and API functions for chat functionality
  - **Files**:
    - `src/contexts/ChatContext.tsx`: Chat context provider
    - `src/hooks/useChat.ts`: Custom hook for chat operations
    - `src/services/chat.ts`: Chat API service
    - `src/types/chat.ts`: Chat types
  - **Step Dependencies**: Step 2, Step 8
  - **User Instructions**: None

- [ ] Step 33: Implement consultation chat components
  - **Task**: Create components for the consultation chat interface
  - **Files**:
    - `src/components/chat/ChatContainer.tsx`: Chat container component
    - `src/components/chat/StructuredChatBubble.tsx`: Markdown chat bubble component
    - `src/components/chat/DoctorResponseCard.tsx`: Doctor response component
    - `src/lib/markdown.ts`: Markdown rendering utilities
    - `src/app/(protected)/consultations/[id]/page.tsx`: Consultation chat page
  - **Step Dependencies**: Step 32
  - **User Instructions**: Install markdown parser with `npm install react-markdown remark-gfm`

- [ ] Step 34: Implement restart session functionality
  - **Task**: Create components and logic for restarting a completed consultation
  - **Files**:
    - `src/components/consultation/RestartSessionButton.tsx`: Restart session button
    - `src/services/consultation.ts`: Update with restart session function
    - `src/app/api/consultations/restart/route.ts`: Restart session API
  - **Step Dependencies**: Step 33
  - **User Instructions**: None

## Notifications

- [ ] Step 35: Create notification context and API
  - **Task**: Create context and API functions for notifications
  - **Files**:
    - `src/contexts/NotificationContext.tsx`: Notification context provider
    - `src/hooks/useNotification.ts`: Custom hook for notification operations
    - `src/services/notification.ts`: Notification API service
    - `src/types/notification.ts`: Notification types
  - **Step Dependencies**: Step 2, Step 8
  - **User Instructions**: None

- [ ] Step 36: Implement in-app notification components
  - **Task**: Create components for displaying in-app notifications
  - **Files**:
    - `src/components/notification/NotificationBadge.tsx`: Notification badge component
    - `src/components/notification/NotificationItem.tsx`: Notification item component
    - `src/components/notification/NotificationList.tsx`: Notification list component
    - `src/app/(protected)/profile/notifications/page.tsx`: Notifications page
  - **Step Dependencies**: Step 35
  - **User Instructions**: None

- [ ] Step 37: Set up Resend API for email notifications
  - **Task**: Integrate Resend API for sending transactional emails
  - **Files**:
    - `src/lib/resend.ts`: Resend client configuration
    - `src/services/email.ts`: Email service functions
    - `src/app/api/emails/send/route.ts`: Email sending API
    - `src/app/api/emails/templates/[template]/route.ts`: Email template API
  - **Step Dependencies**: Step 1
  - **User Instructions**: 
    1. Register for Resend API access at https://resend.com/
    2. Obtain API key and add it to your `.env.local` file
    3. Create email templates in Resend dashboard

## Settings and User Profile

- [ ] Step 38: Implement user profile components
  - **Task**: Create components for viewing and editing user profile
  - **Files**:
    - `src/components/profile/UserProfileForm.tsx`: User profile form
    - `src/components/profile/ProfilePhotoUpload.tsx`: Profile photo upload component
    - `src/app/(protected)/profile/page.tsx`: Profile page
    - `src/app/(protected)/profile/edit/page.tsx`: Edit profile page
  - **Step Dependencies**: Step 15
  - **User Instructions**: None

- [ ] Step 39: Implement settings components
  - **Task**: Create components for application settings
  - **Files**:
    - `src/components/settings/LanguageSwitcher.tsx`: Language switcher component
    - `src/components/settings/NotificationSettings.tsx`: Notification settings component
    - `src/components/settings/PasswordChangeForm.tsx`: Password change form
    - `src/app/(protected)/profile/settings/page.tsx`: Settings page
  - **Step Dependencies**: Step 4, Step 35
  - **User Instructions**: None

- [ ] Step 40: Implement feedback and rating components
  - **Task**: Create components for collecting user feedback and ratings
  - **Files**:
    - `src/components/feedback/FeedbackForm.tsx`: Feedback form component
    - `src/components/feedback/RatingStars.tsx`: Rating stars component
    - `src/components/feedback/NPSFeedback.tsx`: NPS feedback component
    - `src/app/(protected)/consultations/[id]/feedback/page.tsx`: Consultation feedback page
  - **Step Dependencies**: Step 23
  - **User Instructions**: None

## Testing

- [ ] Step 41: Set up testing framework
  - **Task**: Configure Jest and React Testing Library for testing
  - **Files**:
    - `jest.config.js`: Jest configuration
    - `src/utils/test-utils.tsx`: Test utilities
    - `.github/workflows/test.yml`: GitHub Actions workflow for testing
  - **Step Dependencies**: Step 1
  - **User Instructions**: Run `npm install --save-dev jest @testing-library/react @testing-library/jest-dom`

- [ ] Step 42: Create unit tests for core components
  - **Task**: Write unit tests for core components and utilities
  - **Files**:
    - `src/components/auth/__tests__/SignInForm.test.tsx`: Sign-in form tests
    - `src/components/auth/__tests__/SignUpForm.test.tsx`: Sign-up form tests
    - `src/hooks/__tests__/useAuth.test.ts`: Auth hook tests
    - `src/utils/__tests__/validation.test.ts`: Validation utility tests
  - **Step Dependencies**: Step 41
  - **User Instructions**: None

- [ ] Step 43: Create integration tests for key flows
  - **Task**: Write integration tests for key user flows
  - **Files**:
    - `src/integration-tests/auth-flow.test.tsx`: Authentication flow tests
    - `src/integration-tests/consultation-flow.test.tsx`: Consultation flow tests
    - `src/integration-tests/payment-flow.test.tsx`: Payment flow tests
  - **Step Dependencies**: Step 41
  - **User Instructions**: None

## Deployment

- [ ] Step 44: Configure deployment to Vercel
  - **Task**: Set up deployment configuration for Vercel
  - **Files**:
    - `vercel.json`: Vercel configuration
    - `.github/workflows/deploy.yml`: GitHub Actions workflow for deployment
  - **Step Dependencies**: All previous steps
  - **User Instructions**: 
    1. Create a Vercel account at https://vercel.com/
    2. Connect your GitHub repository to Vercel
    3. Configure environment variables in Vercel dashboard
    4. Deploy the application