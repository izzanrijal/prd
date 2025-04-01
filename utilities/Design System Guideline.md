# AhliAnak Frontend Guidelines

## 1. Design System

### Color Palette

- **Primary Color:**
  - Purple #7E22CE - Our main brand color used for primary actions, important UI elements, and to convey trust and professionalism
  - Light Purple (#F5F3FF) - For backgrounds, selected states, and subtle highlights

- **Secondary Colors:**
  - Blue #2563EB - For secondary elements and alternative visual hierarchy
  - Pink #EC4899 - For tertiary elements and accent highlights

- **Neutrals:**
  - White #FFFFFF - Primary background for cards, modals, and content areas
  - Light Gray #F3F4F6 - For subtle backgrounds, inactive states, and dividers
  - Medium Gray #6B7280 - For secondary text and icons
  - Dark Gray/Black #000000 - For primary text

- **Functional Colors:**
  - Success: #10B981 – For confirmed actions or positive states
  - Warning: #F59E0B – For caution messages and alerts
  - Error: #EF4444 – For errors or destructive actions

### Typography

- **Font Family:** Poppins
- **Font Weights:** Regular (400), Medium (500), SemiBold (600), Bold (700)
- **Type Scale:**
  - Headings:
    - H1: 24px, Bold
    - H2: 20px, SemiBold
    - H3: 16px, Medium
  - Body:
    - Regular: 14px, Regular
    - Small: 12px, Regular
  - Labels/Buttons:
    - 14px, Medium

### Spacing System

- Base unit: 4px
- Common spacing values: 4px, 8px, 12px, 16px, 24px, 32px, 40px
- Content padding: 24px (standard)
- Element spacing: 16px (standard)

### UI Elements

#### Modals
- Background: White (#FFFFFF)
- Border radius: 24px
- Padding: 24px
- Drop shadow: 0 4px 20px rgba(0, 0, 0, 0.1)
- Centered icon at top: 48px diameter, brand color

#### Buttons
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

#### Cards
- Background: White
- Border radius: 16px
- Border: 1px solid #E5E7EB (optional)
- Padding: 16px
- Drop shadow: 0 2px 10px rgba(0, 0, 0, 0.05)

#### Input Fields
- Background: White
- Border: 1px solid #E5E7EB
- Border radius: 16px
- Height: 56px
- Padding: 16px
- Focus state: Border color changes to primary color

#### Selection Elements
- Selected state:
  - Border: 1px solid primary color
  - Background: Light purple (#F5F3FF)
  - Checkmark icon in primary color

#### Icons
- Size: 24px (standard)
- Color: Matches text color or specific semantic meaning
- Touch target: Minimum 44x44px

## 2. UI Patterns

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

### Navigation Pattern
- Tab bar with 5 main sections
- Simple, recognizable icons
- Text labels under icons
- Active state in primary color
- Inactive state in medium gray

### Status Indicators
- Clear visual distinction between states
- Color-coding for quick recognition
- Text labels to reinforce meaning
- Icons to enhance visual cues

## 3. Screen Architecture

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

## 4. Interaction Principles

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

## 5. Implementation Guidelines

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
- Consistent visual hierarchy across screen sizes# AhliAnak Frontend Guidelines

## 1. Design System

### Color Palette

- **Primary Color:**
  - Purple #7E22CE - Our main brand color used for primary actions, important UI elements, and to convey trust and professionalism
  - Light Purple (#F5F3FF) - For backgrounds, selected states, and subtle highlights

- **Secondary Colors:**
  - Blue #2563EB - For secondary elements and alternative visual hierarchy
  - Pink #EC4899 - For tertiary elements and accent highlights

- **Neutrals:**
  - White #FFFFFF - Primary background for cards, modals, and content areas
  - Light Gray #F3F4F6 - For subtle backgrounds, inactive states, and dividers
  - Medium Gray #6B7280 - For secondary text and icons
  - Dark Gray/Black #000000 - For primary text

- **Functional Colors:**
  - Success: #10B981 – For confirmed actions or positive states
  - Warning: #F59E0B – For caution messages and alerts
  - Error: #EF4444 – For errors or destructive actions

### Typography

- **Font Family:** Poppins
- **Font Weights:** Regular (400), Medium (500), SemiBold (600), Bold (700)
- **Type Scale:**
  - Headings:
    - H1: 24px, Bold
    - H2: 20px, SemiBold
    - H3: 16px, Medium
  - Body:
    - Regular: 14px, Regular
    - Small: 12px, Regular
  - Labels/Buttons:
    - 14px, Medium

### Spacing System

- Base unit: 4px
- Common spacing values: 4px, 8px, 12px, 16px, 24px, 32px, 40px
- Content padding: 24px (standard)
- Element spacing: 16px (standard)

### UI Elements

#### Modals
- Background: White (#FFFFFF)
- Border radius: 24px
- Padding: 24px
- Drop shadow: 0 4px 20px rgba(0, 0, 0, 0.1)
- Centered icon at top: 48px diameter, brand color

#### Buttons
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

#### Cards
- Background: White
- Border radius: 16px
- Border: 1px solid #E5E7EB (optional)
- Padding: 16px
- Drop shadow: 0 2px 10px rgba(0, 0, 0, 0.05)

#### Input Fields
- Background: White
- Border: 1px solid #E5E7EB
- Border radius: 16px
- Height: 56px
- Padding: 16px
- Focus state: Border color changes to primary color

#### Selection Elements
- Selected state:
  - Border: 1px solid primary color
  - Background: Light purple (#F5F3FF)
  - Checkmark icon in primary color

#### Icons
- Size: 24px (standard)
- Color: Matches text color or specific semantic meaning
- Touch target: Minimum 44x44px

## 2. UI Patterns

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

### Navigation Pattern
- Tab bar with 5 main sections
- Simple, recognizable icons
- Text labels under icons
- Active state in primary color
- Inactive state in medium gray

### Status Indicators
- Clear visual distinction between states
- Color-coding for quick recognition
- Text labels to reinforce meaning
- Icons to enhance visual cues

## 3. Screen Architecture

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

## 4. Interaction Principles

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

## 5. Implementation Guidelines

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