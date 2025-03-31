# Dashboard User Flow

```mermaid
flowchart TD
    %% Main entry points
    Login["Login - AUTH-US1"] --> AppStart["App Starts"]
    AppStart --> Beranda["Beranda (Dashboard) - DASH-US1"]
    
    %% Bottom Navbar Navigation
    AppStart --> Navbar["Bottom Navbar"]
    Navbar --> Beranda
    Navbar --> Anak["Anak (Children) - ENTR-US2"]
    Navbar --> Ahli["Ahli (Doctors) - DRIN-US1"]
    Navbar --> Riwayat["Riwayat (History) - HIST-US1"]
    Navbar --> Profil["Profil (Profile) - PRFL-US1"]
    
    %% Beranda Tab (Dashboard)
    Beranda --> ConsultHistory["Consultation Widget - CONSULT-US1"]
    Beranda --> ChildProfiles["Child Avatars - CHILD-US2"]
    Beranda --> BlogContent["Blog & FAQ Content - BLOG-US1, BLOGART-US1"]
    Beranda --> StartConsultBtn["Start New Consultation Button"]
    
    %% Anak Tab (Children)
    Anak --> ChildList["List/Grid of Children"]
    ChildList --> ViewChildProfile["View Child Profile Page - CHILD-AC6"]
    Anak --> AddNewChildBtn["Add New Child Button"]
    AddNewChildBtn --> AddChildFlow["Initiate Add Child Flow - CHILD-US1"]

    %% Ahli Tab (Doctors)
    Ahli --> DoctorList["Doctor List"]
    DoctorList --> SelectDoctorFlow["Select Doctor for New Consultation"]
    
    %% Riwayat Tab (History)
    Riwayat --> HistoryView["History View - HIST-AC1"]
    HistoryView --> SearchConsultations["Search Consultations - HIST-AC2"]
    HistoryView --> SelectHistConsult["Select Consultation from History"]
    SelectHistConsult --> ViewHistDetails["View Consultation Details"]
    ViewHistDetails --> RestartFromHistory["Restart Session Button"]
    RestartFromHistory --> CheckDoctorAvailable{"Doctor Available?"}
    
    %% Profil Tab (Profile)
    Profil --> ProfileView["Profile & Settings View"]
    ProfileView --> EditProfile["Edit Profile - PRFL-US1"]
    ProfileView --> Settings["Access Settings (Notifications, Language, etc.)"]
    
    %% Consultation paths (from Dashboard widget)
    ConsultHistory --> ActiveConsult["View Active Consultation - CONSULT-US2, CONSULT-US3"]
    ConsultHistory --> CompletedConsult["View Completed Consultation"]
    CompletedConsult --> RestartFromDashboard["Restart Session Button - CONSULT-US5"]
    RestartFromDashboard --> CheckDoctorAvailable
    ConsultHistory -- "No consultations" --> GuidancePrompts["Guidance Prompts - CONSULT-US4"]
    
    %% Starting a new consultation (from Dashboard button or other entry points)
    StartConsultBtn --> SelectDoctorFlow
    
    %% Restart Flow
    CheckDoctorAvailable -- "Yes" --> InitiateNewSession["Initiate New Session (Payment etc.) with Same Doctor"]
    CheckDoctorAvailable -- "No" --> NotifyUnavailable["Notify Doctor Unavailable"]
    NotifyUnavailable --> Ahli
    InitiateNewSession --> Payment["Complete Payment"]

    %% New Consultation Flow
    SelectDoctorFlow --> Payment
    Payment --> SelectConsultType["Select Consultation Type"]
    SelectConsultType --> ChildSpecific["Select Specific Child"]
    SelectConsultType --> GeneralParenting["General Parenting"]
    ChildSpecific --> RecordVoice["Record Voice Note"]
    GeneralParenting --> RecordVoice
    RecordVoice --> AIProcessing["AI Processes Voice Note"]
    AIProcessing --> ReviewSummary["Review AI-Generated Summary"]
    ReviewSummary --> EditSummary["Edit Summary if needed"]
    EditSummary --> SendToDoctor["Send to Doctor"]
    
    %% Child profile and timeline (Accessed from Anak tab or Dashboard avatars)
    ChildProfiles --> ViewChildProfile
    ViewChildProfile --> ChildInfo["View Child Information"]
    ViewChildProfile --> ChildTimeline["View Child's Consultation Timeline - CHILD-US3"]
    ChildTimeline --> SelectTimelineConsult["Select Specific Consultation from Timeline"]
    SelectTimelineConsult --> ViewConversation["View Complete Conversation"]
    
    %% History details Navigation
    ViewHistDetails --> ViewInChildProfile["View in Child Profile - HIST-AC4"]
    ViewInChildProfile --> ViewChildProfile
    
    %% Blog content
    BlogContent -- "No child" --> GenericFAQ["Generic Mom FAQs"]
    BlogContent -- "Has child" --> AgeSpecificFAQ["Age-Specific Child FAQs"]
    BlogContent -- "Multiple children" --> MultipleFAQs["Multiple Age-Specific FAQs"]
    
    %% Error handling paths
    Beranda -- "Error" --> FallbackDashboard["Fallback Dashboard - DASH-EDGE1"]
    ChildProfiles -- "Image fail" --> DefaultIcon["Default Icon - CHILD-EDGE3"] 
    AddChildFlow -- "Network error" --> RetryMessage["Error & Retry - CHILD-EDGE1"]
    BlogContent -- "Content error" --> FallbackArticle["Fallback Generic Article - BLOG-EDGE2"]
    RecordVoice -- "Microphone access issue" --> TextInput["Text Input Alternative - CONSULT-EDGE4"]
    CheckDoctorAvailable -- "Error Checking" --> ErrorNotify["Notify Error"]
    
    %% Styling
    classDef primary fill:#1f77b4,stroke:#333,stroke-width:1px,color:white;
    classDef secondary fill:#aec7e8,stroke:#333,stroke-width:1px;
    classDef error fill:#ff9896,stroke:#333,stroke-width:1px;
    classDef success fill:#98df8a,stroke:#333,stroke-width:1px;
    classDef nav fill:#f7f7f7,stroke:#ccc,stroke-width:1px;
    
    class Navbar,Beranda,Anak,Ahli,Riwayat,Profil nav;
    class ConsultHistory,ChildProfiles,BlogContent,DoctorList primary;
    class ActiveConsult,ViewChildProfile,AgeSpecificFAQ,StartConsultBtn,ChildTimeline,HistoryView primary;
    class FallbackDashboard,RetryMessage,DefaultIcon,FallbackArticle,TextInput,NotifyUnavailable,ErrorNotify error;
    class Payment,SendToDoctor,InitiateNewSession success;
```

## Dashboard Section-Specific User Flows

### Consultation Flow

```mermaid
flowchart TD
    subgraph "New Consultation"
        Dashboard["Beranda Tab - DASH-US1"] --> NewConsultBtn["Start New Consultation Button"]
        NewConsultBtn --> AhliTab["Ahli Tab"]
        AhliTab --> DoctorSelection["Doctor Selection Screen"]
        DoctorSelection --> SelectNewDoctor["Select Doctor"]
        SelectNewDoctor --> PaymentProcess["Payment Process"]
    end

    subgraph "Restart Consultation"
        Dashboard --> CompletedConsultWidget["Completed Consultation Widget"]
        CompletedConsultWidget --> RestartBtnDash["Restart Session Button - CONSULT-US5"]
        RiwayatTab["Riwayat Tab"] --> CompletedConsultHist["Completed Consultation in History"]
        CompletedConsultHist --> RestartBtnHist["Restart Session Button - HIST-US1"]
        RestartBtnDash --> CheckAvail{"Check Doctor Availability"}
        RestartBtnHist --> CheckAvail
        CheckAvail -- "Yes" --> InitiateRestart["Initiate New Session with Same Doctor"]
        CheckAvail -- "No" --> NotifyUnavail["Notify Unavailable & Redirect"]
        NotifyUnavail --> AhliTab
        InitiateRestart --> PaymentProcess
    end

    PaymentProcess --> PaymentComplete{"Payment Complete?"}
    PaymentComplete -- "Yes" --> ConsultType["Select Consultation Type - CONSULT-AC8"]
    PaymentComplete -- "No" --> PaymentError["Payment Error"]
    
    ConsultType --> ChildOption["Select Specific Child"]
    ConsultType --> GeneralOption["General Parenting"]
    
    ChildOption --> VoiceRecording["Voice Recording - CONSULT-AC9"]
    GeneralOption --> VoiceRecording
    VoiceRecording -- "Access granted" --> RecordConcern["Record Health Concern"]
    VoiceRecording -- "Access denied" --> TextAlternative["Text Input Alternative - CONSULT-EDGE4"]
    
    RecordConcern --> AIProcess["AI Processing"]
    TextAlternative --> AIProcess
    AIProcess --> Summary["Review AI Summary"]
    Summary --> EditOption["Edit if needed"]
    EditOption --> SendToDoctor["Send to Doctor"]
    
    %% Styling
    classDef primary fill:#1f77b4,stroke:#333,stroke-width:1px,color:white;
    classDef secondary fill:#aec7e8,stroke:#333,stroke-width:1px;
    classDef error fill:#ff9896,stroke:#333,stroke-width:1px;
    classDef action fill:#ffbb78,stroke:#333,stroke-width:1px;
    classDef success fill:#98df8a,stroke:#333,stroke-width:1px;
    
    class Dashboard,DoctorSelection,RiwayatTab,AhliTab primary;
    class SelectNewDoctor,ConsultType,Summary,VoiceRecording secondary;
    class PaymentError,NotifyUnavail,TextAlternative error;
    class NewConsultBtn,RestartBtnDash,RestartBtnHist action;
    class PaymentComplete,SendToDoctor,InitiateRestart success;
```

### Child Profile & Timeline Flow

```mermaid
flowchart TD
    Dashboard["Beranda Tab - DASH-US1"] --> ChildProfiles["Child Profiles Widget - CHILD-US2"]
    ChildProfiles --> AddNewChild["Add New Child - CHILD-US1"]
    ChildProfiles --> SelectChild["Select Existing Child Avatar"]
    
    AddNewChild --> ChildForm["Fill Child Profile Form"]
    ChildForm --> ValidateForm{"Form Valid?"}
    ValidateForm -- "Yes" --> SaveProfile["Save Profile - CHILD-AC2"]
    ValidateForm -- "No" --> ShowErrors["Show Error Messages - CHILD-AC3"]
    SaveProfile --> ConfirmMessage["Show Confirmation - CHILD-AC4"]
    ConfirmMessage --> UpdateDashboard["Update Dashboard with New Child - CHILD-AC5"]
    
    SelectChild --> ChildProfilePage["Child Profile Page - CHILD-AC6"]
    ChildProfilePage --> ViewChildInfo["View Child Information"]
    ChildProfilePage --> ChildTimeline["View Child's Consultation Timeline - CHILD-US3"]
    
    ChildTimeline --> TimelineEmpty{"Has Consultations?"}
    TimelineEmpty -- "Yes" --> ViewConsultations["View Past Consultations - CHILD-AC7"]
    TimelineEmpty -- "No" --> EmptyTimeline["Show Empty State - CHILD-EDGE4"]
    
    ViewConsultations --> SelectConsultation["Select Specific Consultation - CHILD-AC8"]
    SelectConsultation --> ViewDetails["View Consultation Details"]
    
    %% Error paths
    ChildForm -- "Network error" --> RetrySubmit["Show Error & Retry - CHILD-EDGE1"]
    ChildForm -- "Invalid format" --> FormatError["Show Format Error - CHILD-EDGE2"]
    ChildProfiles -- "Image load fail" --> DefaultAvatar["Show Default Avatar - CHILD-EDGE3"]
    
    %% Styling
    classDef primary fill:#1f77b4,stroke:#333,stroke-width:1px,color:white;
    classDef secondary fill:#aec7e8,stroke:#333,stroke-width:1px;
    classDef error fill:#ff9896,stroke:#333,stroke-width:1px;
    classDef success fill:#98df8a,stroke:#333,stroke-width:1px;
    
    class Dashboard,ChildProfiles,ChildProfilePage,ChildTimeline primary;
    class AddNewChild,SelectChild,ViewChildInfo,ViewConsultations secondary;
    class RetrySubmit,FormatError,DefaultAvatar,EmptyTimeline error;
    class SaveProfile,ConfirmMessage,UpdateDashboard success;
```

### History Interface Flow

```mermaid
flowchart TD
    Dashboard["Beranda Tab - DASH-US1"] --> HistoryTab["History Tab - HIST-US1"]
    
    HistoryTab --> CheckConsults{"Has Consultations?"}
    CheckConsults -- "Yes" --> AllConsultations["All Consultations View - HIST-AC1"]
    CheckConsults -- "No" --> EmptyState["Empty State - HIST-EDGE1"]
    
    AllConsultations --> SearchBar["Search Functionality - HIST-AC2"]
    SearchBar --> PerformSearch["Enter Search Terms"]
    PerformSearch --> SearchResults{"Results Found?"}
    SearchResults -- "Yes" --> FilteredConsults["Filtered Consultations"]
    SearchResults -- "No" --> NoResults["No Results Message - HIST-EDGE2"]
    
    AllConsultations --> SelectConsult["Select Consultation - HIST-AC3"]
    FilteredConsults --> SelectConsult
    SelectConsult --> ViewDetails["View Full Consultation Details"]
    
    ViewDetails --> ViewInProfile["View in Child's Profile - HIST-AC4"]
    ViewInProfile --> ChildProfile["Navigate to Child Profile Timeline"]
    
    %% Error path
    HistoryTab -- "Load error" --> LoadError["Show Error & Retry - HIST-EDGE3"]
    
    %% Styling
    classDef primary fill:#1f77b4,stroke:#333,stroke-width:1px,color:white;
    classDef secondary fill:#aec7e8,stroke:#333,stroke-width:1px;
    classDef error fill:#ff9896,stroke:#333,stroke-width:1px;
    
    class Dashboard,HistoryTab,AllConsultations primary;
    class SearchBar,FilteredConsults,ViewDetails secondary;
    class EmptyState,NoResults,LoadError error;
```