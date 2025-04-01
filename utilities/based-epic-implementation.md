# Implementation Plan

## Foundation (System Infrastructure)

- [x] Step 1: Initialize React Native project with Expo and TypeScript
  - **Task**: Set up a React Native project using Expo with TypeScript support, configure basic tooling, and establish folder structure.
  - **Files**:
    - `package.json`: Package dependencies
    - `app.config.js`: Expo configuration
    - `tsconfig.json`: TypeScript configuration
    - `App.tsx`: Root application component
    - `.gitignore`: Git ignore file
    - `README.md`: Project documentation
    - Basic `src/` structure (e.g., `Components`, `Screens`, `Navigation`, `Hooks`, `Utils`)
  - **Step Dependencies**: None
  - **User Instructions**: Project initialized using React Native with Expo and TypeScript.

- [x] Step 2: Set up Supabase integration
  - **Task**: Integrate Supabase client for authentication, database, and storage services
  - **Files**:
    - `src/lib/supabase.ts` or `src/Config/supabase.ts`: Supabase client configuration
    - `.env.local` or `.env`: Environment variables
    - `.env.example`: Example environment variables
    - `src/Types/supabase.ts`: Supabase type definitions (if generated)
  - **Step Dependencies**: Step 1
  - **User Instructions**:
    1. Create a Supabase account at https://supabase.com/
    2. Create a new project in Supabase dashboard
    3. Obtain API keys from the project settings
    4. Add the keys to your `.env` file
    5. Install Supabase client with `npm install @supabase/supabase-js`

- [ ] Step 3: Set up React Native core modules and components
  - **Task**: Configure and use built-in React Native components and styling system
  - **Files**:
    - `src/Config/theme.ts`: Theme constants for consistent styling
    - `App.tsx` or `src/providers.tsx`: Provider wrapper for app-wide configurations
    - `src/Components/UI/`: Directory for reusable custom UI components
  - **Step Dependencies**: Step 1
  - **User Instructions**: Use React Native's core components and styling system instead of external UI libraries

- [ ] Step 4: Set up database schema in Supabase
  - **Task**: Create database tables and relationships in Supabase as defined in the schema
  - **Files**:
    - `supabase/migrations/YYYYMMDDHHMMSS_create_schema.sql` or similar: SQL schema (using Supabase migrations)
  - **Step Dependencies**: Step 2
  - **User Instructions**:
    1. Use Supabase CLI migrations (`supabase migration new <migration_name>`, edit SQL file, `supabase db push`) or apply SQL via Supabase Studio SQL Editor.

- [ ] Step 5: Configure Row Level Security (RLS) policies
  - **Task**: Implement Row Level Security policies for database tables
  - **Files**:
    - `supabase/migrations/YYYYMMDDHHMMSS_add_rls.sql` or similar: SQL for RLS policies (using Supabase migrations)
  - **Step Dependencies**: Step 4
  - **User Instructions**:
    1. Use Supabase CLI migrations or apply SQL via Supabase Studio SQL Editor.

- [ ] Step 6: Set up storage buckets and policies
  - **Task**: Create Supabase storage buckets for voice notes, profile pictures, and receipts with appropriate access policies
  - **Files**:
    - `supabase/migrations/YYYYMMDDHHMMSS_setup_storage.sql` or similar: SQL for storage buckets and policies (using Supabase migrations)
  - **Step Dependencies**: Step 4
  - **User Instructions**:
    1. Use Supabase CLI migrations or apply SQL via Supabase Studio SQL Editor.
    2. Verify buckets are created in the Storage section of Supabase dashboard

- [ ] Step 7: Create base layout components and navigation
  - **Task**: Create layout components and set up main navigation structure (e.g., Stack, Tabs using React Navigation)
  - **Files**:
    - `src/Navigation/AppNavigator.tsx`: Main app navigator (example)
    - `src/Navigation/AuthNavigator.tsx`: Navigator for auth screens (example)
    - `src/Navigation/BottomTabNavigator.tsx`: Bottom tab navigator (example)
    - `App.tsx`: Root component integrating navigation
    - `src/Components/Layout/...`: Reusable layout components
  - **Step Dependencies**: Step 3 (React Native core components), Step 1 (Requires navigation library)
  - **User Instructions**: Install React Navigation libraries (`npm install @react-navigation/native @react-navigation/native-stack @react-navigation/bottom-tabs react-native-screens react-native-safe-area-context`)

## EPIC - Internationalization (INT)

- [ ] Step 8: Configure internationalization (e.g., with i18next)
  - **Task**: Set up internationalization support (e.g., using `i18next` and `react-i18next`) for Bahasa Indonesia and English
  - **Files**:
    - `src/i18n/config.ts`: i18n configuration
    - `src/i18n/locales/en.json`: English translations
    - `src/i18n/locales/id.json`: Indonesian translations
    - `App.tsx` or `src/providers.tsx`: Integration point for i18n provider
  - **Step Dependencies**: Step 1
  - **User Instructions**: Run `npm install i18next react-i18next expo-localization`

- [ ] Step 9: Implement language switcher component
  - **Task**: Create a language switcher component for the profile settings
  - **Files**:
    - `src/Components/Settings/LanguageSwitcher.tsx`: Language switcher component
    - `src/Hooks/useLanguage.ts`: Custom hook for language operations
  - **Step Dependencies**: Step 8
  - **User Instructions**: None

- [ ] Step 10: Create fallback mechanisms for missing translations
  - **Task**: Implement fallback mechanisms for missing translation keys within i18n config
  - **Files**:
    - `src/i18n/config.ts`: Update config with fallback language
    - `src/Utils/i18n-helpers.ts`: Helper functions for i18n (optional)
    - `src/Hooks/useTranslation.ts`: Enhanced translation hook (optional, depends on usage)
  - **Step Dependencies**: Step 8
  - **User Instructions**: None

## EPIC - Authentication & Login (AUTH)

- [x] Step 11: Create authentication context and hooks
  - **Task**: Create authentication context for managing user authentication state
  - **Files**:
    - `src/Contexts/AuthContext.tsx`: Authentication context provider (example path)
    - `src/Hooks/useAuth.ts`: Custom hook for auth operations
    - `src/Types/auth.ts`: Authentication types
  - **Step Dependencies**: Step 2
  - **User Instructions**: None

- [x] Step 12: Implement sign-up and sign-in components/screens
  - **Task**: Create components and screens for user registration and login with email/password and Google
  - **Files**:
    - `src/Components/Auth/SignUpForm.tsx`: User registration form component
    - `src/Components/Auth/SignInForm.tsx`: User login form component
    - `src/Components/Auth/GoogleAuthButton.tsx`: Google authentication button component
    - `src/Screens/Auth/SignUpScreen.tsx`: Sign-up screen (example path)
    - `src/Screens/Auth/SignInScreen.tsx`: Sign-in screen (example path)
  - **Step Dependencies**: Step 3, Step 11, Step 7 (Navigation)
  - **User Instructions**:
    1. Enable Email/Password and Google providers in Supabase Auth settings
    2. Configure redirect URLs / deep linking for native OAuth if needed (e.g., using `expo-web-browser` or `expo-auth-session`)
    3. For Google auth, set up Google OAuth credentials and add them to Supabase & Expo config (`app.config.js`)

- [x] Step 13: Implement password reset flow
  - **Task**: Create components and screens for password reset functionality
  - **Files**:
    - `src/Components/Auth/ForgotPasswordForm.tsx`: Password reset request form component
    - `src/Components/Auth/ResetPasswordForm.tsx`: New password form component
    - `src/Screens/Auth/ForgotPasswordScreen.tsx`: Forgot password screen (example path)
    - `src/Screens/Auth/ResetPasswordScreen.tsx`: Reset password screen (example path)
  - **Step Dependencies**: Step 11, Step 12
  - **User Instructions**: Configure email templates in Supabase Auth settings for password reset

- [ ] Step 14: Create onboarding flow components/screens
  - **Task**: Implement the onboarding screens with intro carousel
  - **Files**:
    - `src/Components/Onboarding/OnboardingCarousel.tsx`: Onboarding carousel component (e.g., using `react-native-swiper` or similar)
    - `src/Components/Onboarding/OnboardingSlide.tsx`: Individual onboarding slide component
    - `src/Screens/Onboarding/OnboardingScreen.tsx`: Onboarding screen holding the carousel (example path)
  - **Step Dependencies**: Step 3, Step 8 (if text is localized)
  - **User Instructions**: Install a carousel/swiper library if needed.

- [ ] Step 15: Implement auth logic for protected routes/screens
  - **Task**: Implement logic within navigation to handle route protection and redirection based on auth state
  - **Files**:
    - `src/Navigation/AppNavigator.tsx` or `src/Navigation/index.tsx`: Conditional rendering of Auth vs Main stacks based on `AuthContext`
    - `src/Contexts/AuthContext.tsx`: Expose authentication status
  - **Step Dependencies**: Step 7, Step 11
  - **User Instructions**: Structure navigators to separate authenticated and unauthenticated flows.

- [ ] Step 16: Implement post-signup profile completion
  - **Task**: Create components and screen for basic profile completion after signup
  - **Files**:
    - `src/Components/Profile/ProfileCompletionForm.tsx`: Profile completion form component
    - `src/Screens/Profile/CompleteProfileScreen.tsx`: Profile completion screen (example path)
  - **Step Dependencies**: Step 11, Step 7 (Navigation)
  - **User Instructions**: None

## EPIC - Dashboard (DASH)

- [ ] Step 17: Implement bottom navigation bar
  - **Task**: Create the bottom tab navigator with 5 tabs as per the design using React Navigation
  - **Files**:
    - `src/Navigation/BottomTabNavigator.tsx`: Bottom navigation bar implementation (example path)
    - `src/Components/Navigation/TabBarIcon.tsx`: Custom icon component for tabs (example)
  - **Step Dependencies**: Step 7
  - **User Instructions**: Configure screens and icons within the Bottom Tab Navigator.

- [ ] Step 18: Create dashboard context and API/Service
  - **Task**: Create context and service functions for fetching dashboard data from Supabase
  - **Files**:
    - `src/Contexts/DashboardContext.tsx`: Dashboard context provider (example path, optional)
    - `src/Hooks/useDashboard.ts`: Custom hook for dashboard data (optional)
    - `src/Services/dashboard.ts`: Dashboard service functions (fetching data from Supabase)
    - `src/Types/dashboard.ts`: Dashboard types
  - **Step Dependencies**: Step 2, Step 11
  - **User Instructions**: Define functions to query necessary Supabase tables (e.g., children, recent consultations).

- [ ] Step 19: Implement child avatars component
  - **Task**: Create component for displaying child avatars on the dashboard
  - **Files**:
    - `src/Components/Dashboard/ChildAvatars.tsx`: Child avatars component
    - `src/Hooks/useChildProfiles.ts` or fetch logic within component: Hook/logic for accessing child profiles data
  - **Step Dependencies**: Step 18, Step 23 (Child Data)
  - **User Instructions**: Fetch user's children profiles and display avatars.

- [ ] Step 20: Implement consultation widget
  - **Task**: Create component for displaying recent consultations on the dashboard
  - **Files**:
    - `src/Components/Dashboard/ConsultationWidget.tsx`: Recent consultations widget
    - `src/Components/Dashboard/ConsultationCard.tsx`: Consultation card component
  - **Step Dependencies**: Step 18, Step 33 (Consultation Data)
  - **User Instructions**: Fetch recent consultations and display them.

- [ ] Step 21: Implement blog content widget
  - **Task**: Create component for displaying blog content on the dashboard
  - **Files**:
    - `src/Components/Dashboard/BlogContent.tsx`: Blog content widget
    - `src/Components/Blog/BlogCard.tsx`: Blog card component
    - `src/Services/blog.ts`: Blog service functions (fetching data from Supabase/CMS)
  - **Step Dependencies**: Step 18
  - **User Instructions**: Fetch blog posts/articles from data source.

- [ ] Step 22: Create new consultation button
  - **Task**: Implement the button on the dashboard screen to initiate the new consultation flow
  - **Files**:
    - `src/Components/Dashboard/NewConsultationButton.tsx`: New consultation button component
    - `src/Screens/Dashboard/DashboardScreen.tsx`: Main dashboard screen (example path)
  - **Step Dependencies**: Step 20, Step 7 (Navigation)
  - **User Instructions**: Button should navigate to the start of the consultation flow (e.g., child selection or question input).

## EPIC - Entering Children (ENTR)

- [ ] Step 23: Create child profile context and API/Service
  - **Task**: Create context and service functions for child profile management (CRUD operations via Supabase)
  - **Files**:
    - `src/Contexts/ChildContext.tsx`: Child context provider (example path, optional)
    - `src/Hooks/useChild.ts`: Custom hook for child operations (optional)
    - `src/Services/child.ts`: Child service functions (CRUD operations via Supabase)
    - `src/Types/child.ts`: Child types
  - **Step Dependencies**: Step 2, Step 11
  - **User Instructions**: Define functions for creating, reading, updating, deleting child profiles in Supabase.

- [ ] Step 24: Implement child profile form component
  - **Task**: Create form component for adding and editing child profiles (using e.g., `react-hook-form` or `formik`)
  - **Files**:
    - `src/Components/Child/ChildProfileForm.tsx`: Child profile form component
    - `src/Utils/validators/childProfile.ts`: Validators for child profile data (e.g., using `zod`)
  - **Step Dependencies**: Step 23
  - **User Instructions**: Implement form fields and validation logic.

- [ ] Step 25: Create child profile card and list components/screen
  - **Task**: Create components for displaying child profiles and a screen to list them
  - **Files**:
    - `src/Components/Child/ChildProfileCard.tsx`: Child profile card component
    - `src/Components/Child/ChildProfileList.tsx`: List component for child profiles
    - `src/Screens/Anak/AnakListScreen.tsx`: Screen displaying the list of children (example path)
  - **Step Dependencies**: Step 23
  - **User Instructions**: Fetch and display the list of children associated with the user.

- [ ] Step 26: Implement child profile detail screen
  - **Task**: Create the detail screen for viewing a child's profile and their consultation history
  - **Files**:
    - `src/Screens/Anak/AnakDetailScreen.tsx`: Child detail screen (example path)
    - `src/Components/Child/ChildProfileDetail.tsx`: Component showing child details
    - `src/Components/Child/ChildConsultationTimeline.tsx`: Component showing child consultation timeline
  - **Step Dependencies**: Step 24, Step 25, Step 33 (Consultation Data)
  - **User Instructions**: Fetch specific child details and related consultations.

- [ ] Step 27: Create child profile management screens (Add/Edit)
  - **Task**: Create screens for adding and editing child profiles, utilizing the `ChildProfileForm`
  - **Files**:
    - `src/Screens/Anak/AddAnakScreen.tsx`: Add child screen (example path)
    - `src/Screens/Anak/EditAnakScreen.tsx`: Edit child screen (example path)
  - **Step Dependencies**: Step 24, Step 7 (Navigation)
  - **User Instructions**: Integrate the form component into dedicated screens for add/edit actions.

## EPIC - Doctor and Initiate Consultation (DRIN)

- [ ] Step 28: Create doctor discovery context and API/Service
  - **Task**: Create context and service functions for fetching doctor information from Supabase
  - **Files**:
    - `src/Contexts/DoctorContext.tsx`: Doctor context provider (example path, optional)
    - `src/Hooks/useDoctor.ts`: Custom hook for doctor operations (optional)
    - `src/Services/doctor.ts`: Doctor service functions (fetching data from Supabase)
    - `src/Types/doctor.ts`: Doctor types
  - **Step Dependencies**: Step 2, Step 11
  - **User Instructions**: Define functions to query doctor profiles based on criteria.

- [ ] Step 29: Implement doctor card and list components/screen
  - **Task**: Create components for displaying doctors and a screen for the discovery list
  - **Files**:
    - `src/Components/Doctor/DoctorCard.tsx`: Doctor card component
    - `src/Components/Doctor/DoctorList.tsx`: Doctor list component
    - `src/Screens/Ahli/AhliListScreen.tsx`: Doctor discovery screen (example path)
  - **Step Dependencies**: Step 28
  - **User Instructions**: Fetch and display available doctors.

- [ ] Step 30: Create doctor filtering components
  - **Task**: Implement components for filtering doctors by specialty, availability, and search term
  - **Files**:
    - `src/Components/Doctor/SpecialtyFilter.tsx`: Filter component for specialties
    - `src/Components/Doctor/AvailabilityFilter.tsx`: Filter component for availability
    - `src/Components/Doctor/DoctorSearchInput.tsx`: Search input for doctors
  - **Step Dependencies**: Step 28
  - **User Instructions**: Integrate filtering components with the doctor list fetching logic.

- [ ] Step 31: Implement doctor detail screen
  - **Task**: Create the detail screen for viewing a specific doctor's profile
  - **Files**:
    - `src/Screens/Ahli/AhliDetailScreen.tsx`: Doctor detail screen (example path)
    - `src/Components/Doctor/DoctorDetail.tsx`: Component showing doctor details
    - `src/Components/Doctor/DoctorCredentials.tsx`: Component showing doctor credentials
  - **Step Dependencies**: Step 29
  - **User Instructions**: Fetch and display detailed information for a selected doctor.

## EPIC - Starting Question and Chatting (CHAT)

- [ ] Step 32: Set up OpenAI and ElevenLabs API integration (via Backend)
  - **Task**: Create service functions (calling backend/Supabase Functions) for AI integrations
  - **Files**:
    - `src/Services/ai.ts`: AI service functions (calling backend)
    - `supabase/functions/openai-handler/index.ts`: Example Supabase Function for OpenAI calls (securely handles API key)
    - `supabase/functions/elevenlabs-handler/index.ts`: Example Supabase Function for ElevenLabs calls (securely handles API key)
    - `src/Types/ai.ts`: AI types
  - **Step Dependencies**: Step 1
  - **User Instructions**:
    1. Register for OpenAI API access at https://openai.com/
    2. Register for ElevenLabs API access at https://elevenlabs.io/
    3. Obtain API keys and add them securely as Supabase secrets (`supabase secrets set OPENAI_API_KEY=...`)
    4. Deploy Supabase Functions (`supabase functions deploy <function_name>`)

- [ ] Step 33: Create consultation context and API/Service
  - **Task**: Create context and service functions for consultation management (CRUD via Supabase)
  - **Files**:
    - `src/Contexts/ConsultationContext.tsx`: Consultation context provider (example path, optional)
    - `src/Hooks/useConsultation.ts`: Custom hook for consultation operations (optional)
    - `src/Services/consultation.ts`: Consultation service functions (CRUD via Supabase)
    - `src/Types/consultation.ts`: Consultation types
  - **Step Dependencies**: Step 2, Step 11
  - **User Instructions**: Define functions for creating, fetching, updating consultations in Supabase.

- [ ] Step 34: Create voice recording components
  - **Task**: Create components for voice recording and playback using `expo-av`
  - **Files**:
    - `src/Components/Voice/VoiceRecorder.tsx`: Voice recording component
    - `src/Components/Voice/VoicePlayer.tsx`: Voice playback component
    - `src/Components/Voice/WaveformVisualizer.tsx`: Audio waveform visualization (optional, might require extra library like `react-native-waveform-js`)
    - `src/Hooks/useAudioRecording.ts`: Custom hook for audio recording logic (using `expo-av`)
    - `src/Hooks/useAudioPlayback.ts`: Custom hook for audio playback logic (using `expo-av`)
  - **Step Dependencies**: Step 1 (needs `expo-av`)
  - **User Instructions**: Install Expo AV: `npx expo install expo-av`. Request microphone permissions.

- [ ] Step 35: Implement transcription and AI summary components/screens
  - **Task**: Create components/screens for voice input, transcription display/edit, and AI summary review
  - **Files**:
    - `src/Components/Consultation/TranscriptionEditor.tsx`: Transcription editor component
    - `src/Components/Consultation/AISummary.tsx`: AI summary display component
    - `src/Components/Consultation/ClarifyingQuestions.tsx`: Follow-up questions component
    - `src/Screens/Consultation/New/QuestionScreen.tsx`: Screen for voice recording & initial processing (example path)
    - `src/Screens/Consultation/New/ReviewScreen.tsx`: Screen for reviewing summary & transcription (example path)
  - **Step Dependencies**: Step 33, Step 34, Step 32 (AI Services)
  - **User Instructions**: Integrate recording, playback, and calls to backend AI services.

- [ ] Step 36: Create chat context and API/Service (using Supabase Realtime)
  - **Task**: Create context and service functions for real-time chat functionality using Supabase
  - **Files**:
    - `src/Contexts/ChatContext.tsx`: Chat context provider (example path, manages subscription)
    - `src/Hooks/useChat.ts`: Custom hook for chat operations (sending messages, subscribing to changes)
    - `src/Services/chat.ts`: Chat service functions (inserting messages into Supabase)
    - `src/Types/chat.ts`: Chat types
  - **Step Dependencies**: Step 2, Step 11, Step 33 (Consultation ID)
  - **User Instructions**: Enable Supabase Realtime for the chat messages table. Set up RLS policies for chat messages.

- [ ] Step 37: Implement consultation chat components/screen
  - **Task**: Create components for the consultation chat interface (e.g., using `react-native-gifted-chat` or custom build)
  - **Files**:
    - `src/Components/Chat/ChatUI.tsx`: Chat container component (using library or custom)
    - `src/Components/Chat/MessageBubble.tsx`: Custom chat bubble component (if not using library)
    - `src/Screens/Consultation/ChatScreen.tsx`: Consultation chat screen (example path)
  - **Step Dependencies**: Step 36
  - **User Instructions**: Install chat UI library if desired (`npm install react-native-gifted-chat`). Connect UI to chat context/hooks.

## EPIC - Payment (PAYM)

- [ ] Step 38: Create payment context and API/Service (Backend Integration)
  - **Task**: Create context and service functions for payment processing (calling backend/Supabase Functions)
  - **Files**:
    - `src/Contexts/PaymentContext.tsx`: Payment context provider (example path, optional)
    - `src/Hooks/usePayment.ts`: Custom hook for payment operations (optional)
    - `src/Services/payment.ts`: Payment service functions (calling backend)
    - `src/Types/payment.ts`: Payment types
  - **Step Dependencies**: Step 2, Step 11
  - **User Instructions**: Define frontend functions to trigger backend payment initiation.

- [ ] Step 39: Implement consultation package selection components/screen
  - **Task**: Create components for selecting a consultation package and applying promo codes
  - **Files**:
    - `src/Components/Consultation/PackageSelector.tsx`: Package selection component
    - `src/Components/Consultation/PromoCodeInput.tsx`: Promo code input component
    - `src/Screens/Consultation/New/PackagesScreen.tsx`: Package selection screen (example path)
  - **Step Dependencies**: Step 33, Step 38
  - **User Instructions**: Fetch available packages/prices.

- [ ] Step 40: Implement Flip.id payment integration (via Backend & WebView/Linking)
  - **Task**: Create components, screens, and backend functions for Flip.id payment integration
  - **Files**:
    - `src/Components/Payment/PaymentGateway.tsx`: Component to handle payment interaction (e.g., opening WebView or deeplink)
    - `supabase/functions/initiate-payment/index.ts`: Example Supabase Function for payment initiation API (returns payment URL/token)
    - `supabase/functions/payment-callback/index.ts`: Example Supabase Function for handling Flip.id webhook callbacks
    - `src/Screens/Consultation/New/PaymentScreen.tsx`: Screen hosting the payment gateway component (example path)
    - `src/Screens/Consultation/New/PaymentStatusScreen.tsx`: Screen to show after payment attempt (success/failure, listens for updates) (example path)
  - **Step Dependencies**: Step 38
  - **User Instructions**:
    1. Register for a Flip.id developer account
    2. Obtain API keys from Flip.id dashboard
    3. Add keys securely as Supabase secrets
    4. Configure webhook URLs in Flip.id dashboard to point to your callback function
    5. Handle opening payment URLs (e.g., `expo-web-browser`) and potentially deep linking back to the app.

- [ ] Step 41: Implement transaction history components/screens
  - **Task**: Create components and screens for viewing user's transaction history
  - **Files**:
    - `src/Components/Payment/TransactionItem.tsx`: Transaction item component
    - `src/Components/Payment/TransactionList.tsx`: Transaction list component
    - `src/Screens/Profile/TransactionsScreen.tsx`: Transaction history screen (example path)
    - `src/Screens/Profile/TransactionDetailScreen.tsx`: Transaction detail screen (example path)
  - **Step Dependencies**: Step 38 (Data Source)
  - **User Instructions**: Fetch transaction records associated with the user from Supabase.

## EPIC - History (HIST)

- [ ] Step 42: Implement consultation history components/screen
  - **Task**: Create components for viewing the list of past consultations
  - **Files**:
    - `src/Components/Consultation/ConsultationHistoryItem.tsx`: History item component
    - `src/Components/Consultation/ConsultationHistoryList.tsx`: History list component
    - `src/Screens/Riwayat/RiwayatListScreen.tsx`: History list screen (example path)
  - **Step Dependencies**: Step 33 (Data Source)
  - **User Instructions**: Fetch past consultations for the user from Supabase.

- [ ] Step 43: Create consultation search component
  - **Task**: Implement search functionality for consultations within the history screen
  - **Files**:
    - `src/Components/Consultation/ConsultationSearch.tsx`: Search input component
    - `src/Hooks/useConsultationSearch.ts`: Hook handling search logic (filters fetched data or queries Supabase)
  - **Step Dependencies**: Step 42
  - **User Instructions**: Add search input and wire it to filter the history list.

- [ ] Step 44: Implement consultation detail screen (from history)
  - **Task**: Create the detail screen for viewing a past consultation (likely reusing ChatScreen components)
  - **Files**:
    - `src/Screens/Riwayat/RiwayatDetailScreen.tsx`: Past consultation detail screen (example path, might navigate to ChatScreen with specific data/mode)
    - `src/Components/Consultation/ConsultationSummary.tsx`: Component showing consultation summary/details
  - **Step Dependencies**: Step 42, Step 37 (Chat Components)
  - **User Instructions**: Allow users to view the details and chat history of a past consultation.

- [ ] Step 45: Implement restart session functionality (via Backend)
  - **Task**: Create UI elements and backend logic for restarting a completed consultation flow
  - **Files**:
    - `src/Components/Consultation/RestartSessionButton.tsx`: Button displayed on history items/details
    - `src/Services/consultation.ts`: Add function to call restart endpoint
    - `supabase/functions/restart-consultation/index.ts`: Example Supabase Function containing logic to create a new consultation based on an old one
  - **Step Dependencies**: Step 33, Step 42
  - **User Instructions**: Implement button and backend logic for session restart.

## EPIC - Notification (NTFC)

- [x] Step 46: Set up Resend API for email notifications (via Backend)
  - **Task**: Integrate Resend API for sending transactional emails via Supabase Functions
  - **Files**:
    - `src/Services/email.ts`: Service function (calling backend, optional)
    - `supabase/functions/send-email/index.ts`: Example Supabase Function for sending email via Resend
  - **Step Dependencies**: Step 1
  - **User Instructions**:
    1. Register for Resend API access at https://resend.com/
    2. Obtain API key and add it securely as a Supabase secret
    3. Trigger email function from other backend logic (e.g., after signup, payment confirmation).

- [ ] Step 47: Create notification context and API/Service
  - **Task**: Create context and service functions for managing (fetching, marking read) in-app notifications stored in Supabase
  - **Files**:
    - `src/Contexts/NotificationContext.tsx`: Notification context provider (example path, optional)
    - `src/Hooks/useNotification.ts`: Custom hook for notification operations (optional)
    - `src/Services/notification.ts`: Notification service functions (CRUD via Supabase)
    - `src/Types/notification.ts`: Notification types
  - **Step Dependencies**: Step 2, Step 11
  - **User Instructions**: Define functions to manage notification records in Supabase.

- [ ] Step 48: Implement in-app notification components/screen
  - **Task**: Create components for displaying in-app notifications (badge, list) and a dedicated screen
  - **Files**:
    - `src/Components/Notification/NotificationBadge.tsx`: Notification badge component (e.g., on profile/tab icon)
    - `src/Components/Notification/NotificationItem.tsx`: Notification item component
    - `src/Components/Notification/NotificationList.tsx`: Notification list component
    - `src/Screens/Profile/NotificationsScreen.tsx`: Notifications screen (example path)
  - **Step Dependencies**: Step 47
  - **User Instructions**: Fetch notifications using the service/hook and display them. Implement logic for marking as read.

- [ ] Step 49: Implement push notification integration (Expo Push Notifications via Backend)
  - **Task**: Integrate Expo Push Notifications triggered by backend events (e.g., doctor reply)
  - **Files**:
    - `src/Services/pushNotification.ts`: Service for registering device token and handling received notifications (using `expo-notifications`)
    - `supabase/functions/send-push-notification/index.ts`: Example Supabase Function to trigger push notifications via Expo's push API
  - **Step Dependencies**: Step 47 (To know *what* notification to send)
  - **User Instructions**:
      1. Set up Expo Push Notification credentials (FCM/APNS) via EAS CLI (`eas credentials`).
      2. Install `expo-notifications`: `npx expo install expo-notifications`.
      3. Implement logic to get push token from device and store it (e.g., in user profile).
      4. Trigger backend function to send push notifications when needed.

## EPIC - Profile Tab and Settings (PRFL)

- [x] Step 50: Implement user profile components/screens
  - **Task**: Create components and screens for viewing and editing user profile information
  - **Files**:
    - `src/Components/Profile/UserProfileForm.tsx`: User profile form component
    - `src/Components/Profile/ProfilePhotoUpload.tsx`: Profile photo upload component (using `expo-image-picker`)
    - `src/Screens/Profile/ProfileScreen.tsx`: Profile screen displaying user info (example path)
    - `src/Screens/Profile/EditProfileScreen.tsx`: Screen for editing profile info using the form (example path)
  - **Step Dependencies**: Step 11, Step 6 (Storage for photos), Step 2 (Database for profile data)
  - **User Instructions**: Install image picker: `npx expo install expo-image-picker`. Request permissions. Handle image upload to Supabase Storage.

- [ ] Step 51: Implement settings components/screen
  - **Task**: Create components and a screen for application settings (Notifications, Password Change, Language)
  - **Files**:
    - `src/Components/Settings/NotificationSettings.tsx`: Notification settings component (if applicable)
    - `src/Components/Settings/PasswordChangeForm.tsx`: Password change form component
    - `src/Screens/Profile/SettingsScreen.tsx`: Settings screen (example path, links to other settings like Language - Step 9)
  - **Step Dependencies**: Step 8 (Language), Step 47 (Notifications), Step 11 (Auth for password change)
  - **User Instructions**: Group various settings options on one screen.

- [ ] Step 52: Implement feedback and rating components/screen
  - **Task**: Create components and screen for collecting user feedback and ratings post-consultation
  - **Files**:
    - `src/Components/Feedback/FeedbackForm.tsx`: Feedback form component
    - `src/Components/Feedback/RatingStars.tsx`: Rating stars component
    - `src/Screens/Consultation/FeedbackScreen.tsx`: Consultation feedback screen (shown after consultation ends) (example path)
  - **Step Dependencies**: Step 33 (To link feedback to a consultation)
  - **User Instructions**: Implement UI for feedback collection and logic to save it to Supabase.

## Testing

- [ ] Step 53: Set up testing framework (Jest + React Native Testing Library)
  - **Task**: Configure Jest and React Native Testing Library for unit and integration testing
  - **Files**:
    - `jest.config.js`: Jest configuration (Expo SDK usually includes a base config)
    - `src/Utils/test-utils.tsx`: Test utilities (custom render function with providers)
    - `.github/workflows/test.yml`: GitHub Actions workflow for running tests
  - **Step Dependencies**: Step 1
  - **User Instructions**: Install testing libraries: `npm install --save-dev jest @testing-library/react-native @testing-library/jest-native jest-expo`. Follow Expo/RNTL setup guides.

- [ ] Step 54: Create unit tests for core components, hooks, and services
  - **Task**: Write unit tests for individual components, hooks, and utility/service functions
  - **Files**:
    - `src/Components/Auth/__tests__/SignInForm.test.tsx`: Example test file
    - `src/Hooks/__tests__/useAuth.test.ts`: Example test file
    - `src/Services/__tests__/child.test.ts`: Example test file (mocking Supabase client)
  - **Step Dependencies**: Step 53
  - **User Instructions**: Focus on testing component rendering, hook logic, and service function behavior in isolation. Run tests using `npm test` or `yarn test`.

- [ ] Step 55: Create integration tests for key flows
  - **Task**: Write integration tests for key user flows (e.g., Auth, New Consultation) using React Native Testing Library
  - **Files**:
    - `src/__integration_tests__/auth-flow.test.tsx`: Example integration test file
    - `src/__integration_tests__/consultation-flow.test.tsx`: Example integration test file
  - **Step Dependencies**: Step 53
  - **User Instructions**: Structure tests to simulate user interaction across multiple components/screens within the testing environment.

## Deployment

- [ ] Step 56: Configure deployment via EAS (Expo Application Services)
  - **Task**: Set up Expo Application Services (EAS) for building and submitting the app to stores
  - **Files**:
    - `eas.json`: EAS configuration file (build profiles, credentials)
    - `.github/workflows/deploy.yml`: GitHub Actions workflow for triggering EAS builds/submits (optional)
  - **Step Dependencies**: All previous steps
  - **User Instructions**:
    1. Install EAS CLI: `npm install -g eas-cli`
    2. Log in: `eas login`
    3. Configure project: `eas init`, `eas configure` (select platforms, set up credentials)
    4. Build app: `eas build --platform [android|ios|all] --profile <profile_name>`
    5. Submit to stores: `eas submit --platform [android|ios] --latest` or `--id <build_id>`
    6. Configure environment variables securely using EAS Secrets (`eas secret:create`, `eas secret:list`).