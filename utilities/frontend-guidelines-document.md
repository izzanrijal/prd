### AhliAnak Frontend Guidelines Document

This document describes the frontend architecture, design principles, styling and theming, component structure, state management, navigation, performance optimization, and testing practices for the AhliAnak mobile application. The goal is to ensure our frontend setup is scalable, maintainable, and provides an exceptional user experience for Indonesian mothers seeking pediatric healthcare consultations through our voice-first platform.

## 1. Frontend Architecture

Our frontend is built using a modern cross-platform stack designed for performance and native feel. We use **React Native** as our primary framework, providing near-native performance while maintaining a single codebase for both iOS and Android. The project leverages **Expo** for streamlined development, testing, and deployment, along with **TypeScript** for type safety and error prevention. This architecture follows a component-based paradigm, with reusable UI elements that support easier maintenance and scalability.

**Key Libraries and Integrations:**

- **React Native:** Provides cross-platform native UI components
- **Expo:** Simplifies development, testing, and deployment across platforms
- **TypeScript:** Ensures type safety and reduces runtime errors
- **React Native UI Components:** Built-in components enhanced with custom styling
- **React Navigation:** Handles stack, tab, and drawer navigation with native transitions
- **Markdown Rendering:** Custom implementation for structured chat interfaces
- **Voice Recording/Playback:** Native modules for high-quality audio processing

**Development Environment Configuration:**
- ESLint for code quality
- Prettier for code formatting
- EditorConfig for consistent editor settings
- Stylelint for style consistency
- VSCode snippets and settings for developer productivity

## 2. Design Principles

Our design is guided by these core principles:

- **Usability:** The interface is simple and intuitive, designed specifically for busy Indonesian mothers who need quick access to pediatric advice
- **Voice-First UX:** Core interactions prioritize voice input/output with text as support
- **Trust & Confidence:** Visual language conveys medical professionalism and emotional reassurance
- **Clarity:** Information hierarchy ensures important details stand out, especially in consultation summaries
- **Accessibility:** Support for various devices, network conditions, and user abilities
- **Responsive:** Adapts to different device sizes while maintaining optimal tap targets for one-handed use

These principles are reflected throughout our UI, ensuring that layouts, interactions, and animations serve both functional and emotional user needs.

## 3. Styling and Theming

Our styling approach uses React Native's StyleSheet system and custom theme providers to maintain visual consistency across the app.

**Color Palette:**

- **Primary Color:**
  - Purple (#7E22CE) - Our main brand color used for primary actions, important UI elements, and to convey trust and professionalism
  - Light Purple (#F5F3FF) - For backgrounds, selected states, and subtle highlights

- **Secondary Colors:**
  - Blue (#2563EB) - For secondary elements and alternative visual hierarchy
  - Pink (#EC4899) - For tertiary elements and accent highlights

- **Neutrals:**
  - White (#FFFFFF) - Primary background for cards, modals, and content areas
  - Light Gray (#F3F4F6) - For subtle backgrounds, inactive states, and dividers
  - Medium Gray (#6B7280) - For secondary text and icons
  - Dark Gray/Black (#000000) - For primary text

- **Functional Colors:**
  - Success: #10B981 – For confirmed actions or positive states
  - Warning: #F59E0B – For caution messages and alerts
  - Error: #EF4444 – For errors or destructive actions

**Typography:**
- Font Family: Poppins
- Font Weights: Regular (400), Medium (500), SemiBold (600), Bold (700)
- Type Scale:
  - Headings:
    - H1: 24px, Bold
    - H2: 20px, SemiBold
    - H3: 16px, Medium
  - Body:
    - Regular: 14px, Regular
    - Small: 12px, Regular
  - Labels/Buttons:
    - 14px, Medium

**Spacing System:**
- Base unit: 4px
- Common spacing values: 4px, 8px, 12px, 16px, 24px, 32px, 40px
- Content padding: 24px (standard)
- Element spacing: 16px (standard)

**UI Elements:**

- **Modals:**
  - Background: White (#FFFFFF)
  - Border radius: 24px
  - Padding: 24px
  - Drop shadow: 0 4px 20px rgba(0, 0, 0, 0.1)
  - Centered icon at top: 48px diameter, brand color

- **Buttons:**
  - Primary:
    - Background: Purple (#7E22CE)
    - Text: White
    - Border radius: 100px (fully rounded)
    - Height: 56px
    - Font: 14px Medium
  - Secondary:
    - Background: Light Gray (#F3F4F6)
    - Text: Black
    - Border radius: 100px
    - Height: 56px
    - Font: 14px Medium

- **Cards:**
  - Background: White
  - Border radius: 16px
  - Border: 1px solid #E5E7EB (optional)
  - Padding: 16px
  - Drop shadow: 0 2px 10px rgba(0, 0, 0, 0.05)

- **Input Fields:**
  - Background: White
  - Border: 1px solid #E5E7EB
  - Border radius: 16px
  - Height: 56px
  - Padding: 16px
  - Focus state: Border color changes to primary color

- **Selection Elements:**
  - Selected state:
    - Border: 1px solid primary color
    - Background: Light purple (#F5F3FF)
    - Checkmark icon in primary color

- **Icons:**
  - Size: 24px (standard)
  - Color: Matches text color or specific semantic meaning
  - Touch target: Minimum 44x44px

**Component Styling Configuration:**
- Custom theme using React Native's StyleSheet
- Component variants defined in central theme constants
- Custom component configurations stored in a centralized theme file

## 4. Component Structure

The AhliAnak frontend is organized in a modular, component-based architecture with special consideration for the voice-first interaction model and medical consultation flow.

**Project Structure:**

```
/src
  /@core                  # Core utilities and components
    /components           # Shared UI components
    /scss                 # Global styling
    /utils                # Helper functions
  /@layouts               # Layout components and configuration
  /assets                 # Static assets
    /images               # Images and icons
    /styles               # Global styles
  /components             # App-specific components
  /layouts                # Page layouts
  /screens                # Main screen containers
    /auth                 # Authentication screens
    /dashboard            # Dashboard screens
    /child-profiles       # Child profile screens
    /doctors              # Doctor discovery screens
    /consultations        # Consultation flow screens
    /history              # History & records screens
    /profile              # User profile & settings
  /hooks                  # Custom React hooks
  /context                # Global state providers
  /services               # API/backend service integrations
  /utils                  # Helper functions
  /constants              # App constants and enums
  /i18n                   # Internationalization
```

**Component Hierarchy:**

1. **Atomic Components:** Basic UI elements using React Native core components (View, Text, Pressable)
2. **Composite Components:** Combinations of atomic components (ProfileCard, ConsultationItem)
3. **Feature Components:** Complex components with business logic (VoiceRecorder, DoctorList)
4. **Screen Components:** Full screens containing multiple feature components

**Key Components:**

- **Voice Interface Components:**
  - VoiceRecorder (with visualization and transcription preview)
  - VoicePlayer (for doctor responses)
  - TranscriptionEditor (for editing AI summaries)

- **Consultation Components:**
  - StructuredChatBubble (supporting Markdown for medical formatting)
  - FollowUpQuestions (AI-generated clarifications)
  - DoctorResponseCard (with voice playback and text summary)

- **Profile Components:**
  - ChildProfileCard (with avatar, key health data, and selection state)
  - HealthTimelineItem (consultation history item)
  - ProfileEditor (for adding/editing child profiles)

- **Doctor Discovery Components:**
  - DoctorCard (with credentials, availability, and specialization tags)
  - SpecialtyFilter (for filtering doctor list)
  - DoctorDetail (expanded view with credentials and availability)

- **Payment Components:**
  - PackageSelector (for choosing consultation package)
  - PaymentSummary (order details)
  - PromoCodeInput (for discount codes)

## 5. State Management

For managing the application state, we use a combination of React Context API for global state and local component state for component-specific data.

**Global State (Context API):**

- **AuthContext:** User authentication state and methods
- **ProfileContext:** Current child profile selection and management
- **ConsultationContext:** Active consultation state and methods
- **NotificationContext:** Notification management
- **ThemeContext:** Theme preferences and toggles

**Local State:**

- Component-specific UI states (loading, expanded, etc.)
- Form inputs and validations
- Animation controllers

**Data Persistence:**

- Secure storage for authentication tokens (Expo SecureStore)
- AsyncStorage for non-sensitive user preferences
- Supabase for primary data sync

**State Management Best Practices:**

- Use Context selectively for truly global state
- Prefer component composition over prop drilling
- Implement memoization for expensive computations
- Use reducers for complex state logic
- Keep state changes predictable and debuggable

## 6. Navigation

Navigation in AhliAnak is handled by React Navigation, providing a native feeling navigation experience with a mix of stack, tab, and modal navigation patterns.

**Navigation Structure:**

- **Authentication Stack:** Login, Register, ForgotPassword
- **Onboarding Stack:** App intro, child profile creation
- **Main Tab Navigator:**
  - Beranda (Dashboard) Stack
  - Anak (Children) Stack
  - Ahli (Doctors) Stack
  - Riwayat (History) Stack
  - Profil (Settings) Stack
- **Modal Stacks:**
  - Consultation Flow
  - Payment Flow
  - Voice Recording
  - Feedback and Rating

**Navigation Pattern:**
- Tab bar with 5 main sections
- Simple, recognizable icons
- Text labels under icons
- Active state in primary color (Purple #7E22CE)
- Inactive state in medium gray (#6B7280)

**Navigation Best Practices:**

- Maintain shallow navigation depth (max 3 levels)
- Provide clear back navigation and escape hatches
- Use consistent transition animations
- Pre-load critical screens for perceived performance
- Implement deep linking for notification-driven navigation
- Handle authentication state changes gracefully
- Support gesture navigation (swipe back)
- Optimize header configurations for each screen

## 7. UI Patterns

### Modal Pattern
- Full-screen dimmed overlay (rgba(0, 0, 0, 0.5))
- Centered white modal with 24px border radius
- Close button (X) in top-right corner
- Back button (←) in top-left corner when applicable
- Title centered or left-aligned based on content
- Primary action button at bottom, full width
- Maximum width of 335px on mobile

### Selection Pattern
- Clear visual distinction for selected items
- Border color change and background tint
- Checkmark icon for confirmation
- Adequate spacing between options
- Full-width touch targets

### Form Pattern
- Single input per screen when possible
- Clear, concise labels
- Placeholder text for guidance
- Inline validation
- Progressive disclosure
- Keyboard-appropriate input types

### Status Indicators
- Clear visual distinction between states
- Color-coding for quick recognition
- Text labels to reinforce meaning
- Icons to enhance visual cues

## 8. Screen Architecture

### Modal Screens
- Focused on a single task
- Clear title describing the purpose
- Minimal UI elements
- Primary action at bottom
- Escape routes (back/close) always available

### List Screens
- Clean, card-based items
- Adequate spacing between items
- Clear visual hierarchy within items
- Pull-to-refresh functionality
- Empty states with helpful guidance

### Detail Screens
- Prominent header with key information
- Organized sections with clear headings
- Action buttons contextually placed
- Related items in horizontal scrolling containers
- Back navigation always available

### Dashboard Screens
- Quick access to key functions
- Card-based content organization
- Clear section headings
- Personalized elements prominently displayed
- Quick action buttons for common tasks

## 9. Interaction Principles

### Touch Feedback
- Subtle scale reduction on press (transform: scale(0.98))
- Color change for state indication
- Haptic feedback for important actions
- Minimum touch target size of 44x44px

### Transitions
- Simple, quick transitions (200-300ms)
- Ease-in-out timing function
- Consistent direction for hierarchical navigation
- Modal presentations with fade and slight scale

### Voice Interface
- Clear recording state indicators
- Waveform visualization during recording
- Prominent, accessible record button
- Transcription display in readable format
- Simple playback controls

### Loading States
- Inline loading indicators where possible
- Skeleton screens for content loading
- Maintain context during loading
- Cancelable operations where appropriate

## 10. Voice Interface Patterns

Since AhliAnak is built with a voice-first approach, we follow these specific patterns for voice interactions:

- **Clear Recording States:** Visual feedback during recording (waveform visualization)
- **Chunked Processing:** Process long voice notes in chunks with progress indicators
- **Transcription Preview:** Show real-time transcription when possible
- **Fallback Mechanisms:** Always provide text input alternatives
- **Error Recovery:** Graceful handling of voice processing failures
- **Playback Controls:** Consistent controls for reviewing voice notes and doctor responses
- **Voice Feedback:** Subtle audio cues for recording start/stop
- **Permission Handling:** Clear permission requests with context
- **Background Processing:** Handle voice processing in background when possible
- **Acoustic Environment Adaptation:** Adjust sensitivity based on ambient noise

## 11. Performance Optimization

To ensure exceptional performance on a wide range of devices, especially considering voice processing and medical consultation needs:

**Rendering Optimization:**

- Use `React.memo()` for pure components
- Implement virtualized lists (FlatList, SectionList) for long scrollable content
- Lazy load non-critical screens and components
- Minimize re-renders using careful prop management
- Leverage React Native's optimized core components

**Asset Optimization:**

- Properly sized and compressed images
- Vector icons where possible
- Sound file compression for voice notes
- Use Expo's asset management system

**Network Optimization:**

- Implement request caching strategies
- Support offline mode for drafted voice notes
- Progressive loading patterns for doctor lists and chat history
- Background uploads for voice notes with progress indicators
- Implement retry mechanisms for failed requests
- Use connection-aware components

**Memory Management:**

- Properly release audio resources when not in use
- Optimize large list rendering with recycling
- Clear unused resources in background
- Monitor and optimize bundle size
- Use performance profiling tools

## 12. Implementation Guidelines

### Component Structure
- Atomic design methodology
- Composition over inheritance
- Props for configuration
- Consistent naming conventions
- Self-contained styling

### Accessibility
- Semantic HTML structure
- WCAG AA compliance minimum
- Screen reader support
- Keyboard navigation
- Color contrast requirements
- Touch target sizing

### Performance
- Lazy loading for off-screen content
- Image optimization
- Virtualized lists for long content
- Memoization for expensive components
- Efficient re-rendering strategies

### Responsive Design
- Mobile-first approach
- Flexible layouts using percentages and auto
- Strategic breakpoints for tablet/desktop
- Maintain touch targets across device sizes
- Consistent visual hierarchy across screen sizes

## 13. Testing Practices

To ensure our application is reliable and delivers a consistent experience:

- **Unit Testing:** Individual components with Jest and React Native Testing Library
- **Component Testing:** Isolated component behavior verification
- **Integration Testing:** Cross-component workflows and screen transitions
- **End-to-End Testing:** Key user flows tested on real devices using Detox
- **Performance Testing:** Voice processing timing, navigation smoothness, startup time
- **Network Testing:** Various connection scenarios including intermittent connectivity
- **Accessibility Testing:** VoiceOver/TalkBack compatibility and minimum tap target sizing
- **Localization Testing:** Verify text displays correctly in all supported languages
- **Device Testing:** Test on representative range of devices and OS versions

**Testing Priorities:**

1. Critical health data accuracy
2. Voice recording/playback reliability
3. Payment flow integrity
4. Consultation persistence
5. Navigation and deep linking correctness

## 14. Accessibility Considerations

To ensure AhliAnak is usable by all Indonesian mothers, including those with accessibility needs:

- **Screen Reader Support:** TalkBack (Android) and VoiceOver (iOS) compatible components
- **Text Scaling:** Support dynamic text sizes without breaking layouts
- **Color Contrast:** WCAG AA standard minimum for text elements
- **Touch Targets:** Minimum 44×44 points for interactive elements
- **Alternative Input Methods:** Support for external keyboards and assistive devices
- **Reduced Motion:** Optional animations reduction
- **Voice Alternative:** Text alternatives for all voice functionality
- **Semantic Structure:** Proper heading levels and screen landmarks
- **Focus Management:** Clear focus indicators and logical tab order
- **Error Identification:** Clear error messages with suggestions

## 15. Internationalization and Localization

While our primary target is Indonesian mothers, we implement proper internationalization:

- String externalization using i18n-js
- Right-to-left (RTL) layout support for future language expansion
- Culturally appropriate imagery and iconography
- Date/time/number formatting following Indonesian conventions
- Support for language switching (Indonesian/English initially)
- Translation management workflow
- Runtime language switching without app restart
- Placeholder management for translated content
- Format string handling for complex translations

## 16. Security Practices

For handling sensitive health information in the frontend:

- Secure storage for auth tokens (Expo SecureStore)
- Automatic session timeouts
- Secure input for sensitive information
- Camera/microphone permission handling
- Biometric authentication option
- Visual privacy features (blur sensitive data in screenshots)
- Secure payment form handling
- Input validation and sanitization
- Protection against common mobile vulnerabilities
- Secure deep linking implementation
- Debug/production environment separation

## 17. Deployment and CI/CD

Our deployment process ensures consistent quality across releases:

- Expo EAS Build for managed native builds
- Automated testing in CI pipeline
- Version management with semantic versioning
- Staged rollouts for critical updates
- Over-the-air updates for minor changes
- Pre-release testing protocols
- Rollback capabilities
- Release notes generation
- Monitoring and analytics integration

## 18. Conclusion

The AhliAnak frontend is designed to deliver a voice-first, trusted mobile experience for Indonesian mothers seeking pediatric healthcare advice. By following these guidelines and leveraging React Native's core components for our UI system, we ensure our application remains:

- Performant across a wide range of devices
- Trustworthy for handling sensitive health information
- Intuitive for our primary users (busy mothers)
- Consistent in its visual language and interactions with our purple-based color palette
- Accessible through both voice and touch interfaces
- Structured with clear UI patterns and screen architectures
- Maintainable as our team and feature set grows

These guidelines help align our technical implementation with our core mission: empowering Indonesian mothers with accessible, trusted pediatric healthcare guidance. 