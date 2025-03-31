-- AhliAnak PostgreSQL Database Schema for Supabase
-- Secure schema with best practices for healthcare data

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pgjwt";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Schema for RLS (Row Level Security) policies
CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS private;
CREATE SCHEMA IF NOT EXISTS public;

-- Set appropriate search path
ALTER DATABASE postgres SET search_path TO public, auth, private;

----------------- USERS AND AUTHENTICATION -----------------

-- Users Table (extends Supabase auth.users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    phone_number TEXT UNIQUE,
    full_name TEXT NOT NULL,
    profile_photo_url TEXT,
    preferred_language VARCHAR(10) DEFAULT 'id' NOT NULL CHECK (preferred_language IN ('id', 'en')), -- id=Indonesian, en=English
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_login_at TIMESTAMPTZ,
    is_active BOOLEAN DEFAULT TRUE,
    push_notification_token TEXT,
    onboarding_completed BOOLEAN DEFAULT FALSE,
    verified_email BOOLEAN DEFAULT FALSE,
    verified_phone BOOLEAN DEFAULT FALSE,
    email_bounced BOOLEAN DEFAULT FALSE,
    email_bounce_reason TEXT,
    last_email_activity TIMESTAMPTZ
);

-- Add encryption for sensitive fields
CREATE OR REPLACE FUNCTION encrypt_phone() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.phone_number IS NOT NULL THEN
        NEW.phone_number = PGP_SYM_ENCRYPT(NEW.phone_number, current_setting('app.encryption_key'));
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER encrypt_user_phone_trigger
BEFORE INSERT OR UPDATE ON public.users
FOR EACH ROW EXECUTE FUNCTION encrypt_phone();

----------------- CHILD PROFILES -----------------

-- Child Profiles Table
CREATE TABLE public.child_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(1) CHECK (gender IN ('M', 'F')),
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Health information
    weight_kg DECIMAL(5,2),
    height_cm DECIMAL(5,2),
    blood_type VARCHAR(3) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    
    -- Add additional health info fields
    CONSTRAINT child_profiles_unique_per_user UNIQUE (user_id, name)
);

-- Child Medical Information
CREATE TABLE public.child_medical_info (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_id UUID NOT NULL REFERENCES public.child_profiles(id) ON DELETE CASCADE,
    allergies JSONB DEFAULT '[]',
    medical_conditions JSONB DEFAULT '[]',
    medications JSONB DEFAULT '[]',
    vaccination_records JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

----------------- DOCTORS -----------------

-- Doctors Table
CREATE TABLE public.doctors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name TEXT NOT NULL,
    specialization TEXT NOT NULL,
    years_experience INTEGER NOT NULL,
    photo_url TEXT,
    credentials JSONB NOT NULL,
    average_rating DECIMAL(3,2) DEFAULT 0,
    total_ratings INTEGER DEFAULT 0,
    avg_response_time_minutes INTEGER,
    is_available BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Doctor profile information
    bio TEXT,
    education JSONB DEFAULT '[]',
    practice_locations JSONB DEFAULT '[]'
);

-- Doctor Availability Schedules
CREATE TABLE public.doctor_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    doctor_id UUID NOT NULL REFERENCES public.doctors(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sunday, 6=Saturday
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_time_range CHECK (start_time < end_time)
);

-- Doctor Unavailable Dates (vacations, time off)
CREATE TABLE public.doctor_unavailable_dates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    doctor_id UUID NOT NULL REFERENCES public.doctors(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_date_range CHECK (start_date <= end_date)
);

----------------- CONSULTATION PACKAGES -----------------

-- Consultation Packages
CREATE TABLE public.consultation_packages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    price_idr INTEGER NOT NULL,
    is_unlimited BOOLEAN DEFAULT FALSE,
    max_replies INTEGER,
    duration_minutes INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Promotional Codes
CREATE TABLE public.promo_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT UNIQUE NOT NULL,
    discount_percentage INTEGER,
    discount_fixed_amount INTEGER,
    valid_from TIMESTAMPTZ NOT NULL,
    valid_until TIMESTAMPTZ NOT NULL,
    max_uses INTEGER,
    current_uses INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK ((discount_percentage IS NULL AND discount_fixed_amount IS NOT NULL) OR 
           (discount_percentage IS NOT NULL AND discount_fixed_amount IS NULL))
);

----------------- CONSULTATIONS -----------------

-- Consultations Table
CREATE TABLE public.consultations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    child_id UUID REFERENCES public.child_profiles(id) ON DELETE SET NULL,
    doctor_id UUID NOT NULL REFERENCES public.doctors(id),
    package_id UUID NOT NULL REFERENCES public.consultation_packages(id),
    promo_code_id UUID REFERENCES public.promo_codes(id),
    
    status VARCHAR(20) NOT NULL CHECK (status IN (
        'pending_payment', 'active', 'awaiting_doctor', 
        'pending_clarification', 'completed', 'canceled'
    )),
    
    is_general_parenting BOOLEAN DEFAULT FALSE,
    ai_summary_title TEXT,
    emotional_urgency INTEGER CHECK (emotional_urgency BETWEEN 1 AND 5),
    start_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    end_time TIMESTAMPTZ,
    replies_used INTEGER DEFAULT 0,
    max_replies INTEGER,
    
    original_price_idr INTEGER NOT NULL,
    final_price_idr INTEGER NOT NULL,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Consultation Messages
CREATE TABLE public.consultation_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    consultation_id UUID NOT NULL REFERENCES public.consultations(id) ON DELETE CASCADE,
    sender_type VARCHAR(10) NOT NULL CHECK (sender_type IN ('user', 'doctor', 'system')),
    sender_id UUID NOT NULL,
    message_type VARCHAR(20) NOT NULL CHECK (message_type IN (
        'voice_note', 'text', 'clarification', 'final_answer', 'system_message'
    )),
    voice_url TEXT,
    voice_duration_seconds INTEGER,
    original_text TEXT,
    ai_processed_text TEXT,
    
    -- For markdown rendering and structure
    markdown_content TEXT,
    
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- AI Generated Clarification Questions
CREATE TABLE public.ai_clarification_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    consultation_id UUID NOT NULL REFERENCES public.consultations(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    is_answered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

----------------- PAYMENTS AND TRANSACTIONS -----------------

-- Payments Table
CREATE TABLE public.payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    consultation_id UUID NOT NULL REFERENCES public.consultations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id),
    amount_idr INTEGER NOT NULL,
    payment_method TEXT NOT NULL,
    flip_id TEXT UNIQUE,
    status VARCHAR(20) NOT NULL CHECK (status IN (
        'pending', 'processing', 'completed', 'failed', 'refunded'
    )),
    payment_date TIMESTAMPTZ,
    receipt_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Transactions History (for user-facing history)
CREATE TABLE public.transaction_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id),
    payment_id UUID NOT NULL REFERENCES public.payments(id),
    consultation_id UUID NOT NULL REFERENCES public.consultations(id),
    doctor_name TEXT NOT NULL,
    package_name TEXT NOT NULL,
    amount_idr INTEGER NOT NULL,
    transaction_date TIMESTAMPTZ NOT NULL,
    receipt_image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

----------------- FEEDBACK AND RATINGS -----------------

-- Consultation Feedback
CREATE TABLE public.consultation_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    consultation_id UUID UNIQUE NOT NULL REFERENCES public.consultations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id),
    doctor_id UUID NOT NULL REFERENCES public.doctors(id),
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    feedback_text TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- NPS Feedback
CREATE TABLE public.nps_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id),
    score INTEGER NOT NULL CHECK (score BETWEEN 1 AND 5),
    voice_feedback_url TEXT,
    transcript_text TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

----------------- BLOG CONTENT -----------------

-- Blog Articles
CREATE TABLE public.blog_articles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    thumbnail_url TEXT,
    author TEXT,
    target_age_min INTEGER,
    target_age_max INTEGER,
    is_faq BOOLEAN DEFAULT FALSE,
    is_published BOOLEAN DEFAULT TRUE,
    published_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

----------------- NOTIFICATIONS -----------------

-- Notifications
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN (
        'new_reply', 'clarification', 'payment', 'system', 'feedback_request'
    )),
    related_entity_id UUID,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    send_push BOOLEAN DEFAULT TRUE
);

----------------- INTERNATIONALIZATION -----------------

-- Language Resource Files
CREATE TABLE public.language_resources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    language_code VARCHAR(5) NOT NULL CHECK (language_code IN ('id', 'en', 'fr')),
    resource_key TEXT NOT NULL,
    resource_value TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_resource_keys UNIQUE (language_code, resource_key)
);

----------------- AUDIT AND LOGGING -----------------

-- Audit Log Table (for security and compliance)
CREATE TABLE private.audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    action VARCHAR(50) NOT NULL,
    table_name TEXT NOT NULL,
    record_id UUID,
    user_id UUID,
    old_data JSONB,
    new_data JSONB,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create a function to update audit logs
CREATE OR REPLACE FUNCTION private.audit_log_func() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO private.audit_logs (action, table_name, record_id, user_id, old_data, new_data)
        VALUES (TG_OP, TG_TABLE_NAME, OLD.id, auth.uid(), to_jsonb(OLD), NULL);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO private.audit_logs (action, table_name, record_id, user_id, old_data, new_data)
        VALUES (TG_OP, TG_TABLE_NAME, NEW.id, auth.uid(), to_jsonb(OLD), to_jsonb(NEW));
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO private.audit_logs (action, table_name, record_id, user_id, old_data, new_data)
        VALUES (TG_OP, TG_TABLE_NAME, NEW.id, auth.uid(), NULL, to_jsonb(NEW));
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

----------------- ROW LEVEL SECURITY POLICIES -----------------

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.child_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.child_medical_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.consultations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.consultation_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transaction_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.consultation_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nps_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- User profile policies
CREATE POLICY users_self_access ON public.users 
    USING (id = auth.uid());

-- Child profile policies
CREATE POLICY child_profiles_user_access ON public.child_profiles 
    USING (user_id = auth.uid());

-- Medical info policies
CREATE POLICY child_medical_info_user_access ON public.child_medical_info 
    USING (child_id IN (
        SELECT id FROM public.child_profiles WHERE user_id = auth.uid()
    ));

-- Doctor policies (public read access)
CREATE POLICY doctors_public_read ON public.doctors
    FOR SELECT USING (true);

-- Consultation policies
CREATE POLICY consultations_user_access ON public.consultations
    USING (user_id = auth.uid());

-- Create policy for doctors to see their consultations
CREATE POLICY consultations_doctor_access ON public.consultations
    USING (doctor_id = auth.uid());

-- Message policies
CREATE POLICY consultation_messages_user_access ON public.consultation_messages
    USING (consultation_id IN (
        SELECT id FROM public.consultations WHERE user_id = auth.uid()
    ));

-- Create policy for doctors to see their consultation messages
CREATE POLICY consultation_messages_doctor_access ON public.consultation_messages
    USING (consultation_id IN (
        SELECT id FROM public.consultations WHERE doctor_id = auth.uid()
    ));

-- Payment policies
CREATE POLICY payments_user_access ON public.payments
    USING (user_id = auth.uid());

-- Transaction history policies
CREATE POLICY transaction_history_user_access ON public.transaction_history
    USING (user_id = auth.uid());

-- Feedback policies
CREATE POLICY consultation_feedback_user_access ON public.consultation_feedback
    USING (user_id = auth.uid());

CREATE POLICY nps_feedback_user_access ON public.nps_feedback
    USING (user_id = auth.uid());

-- Notification policies
CREATE POLICY notifications_user_access ON public.notifications
    USING (user_id = auth.uid());

----------------- INDEXES FOR PERFORMANCE -----------------

-- User indexes
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_preferred_language ON public.users(preferred_language);

-- Child profile indexes
CREATE INDEX idx_child_profiles_user_id ON public.child_profiles(user_id);
CREATE INDEX idx_child_profiles_date_of_birth ON public.child_profiles(date_of_birth);

-- Doctor indexes
CREATE INDEX idx_doctors_specialization ON public.doctors(specialization);
CREATE INDEX idx_doctors_is_available ON public.doctors(is_available);
CREATE INDEX idx_doctors_rating ON public.doctors(average_rating);

-- Consultation indexes
CREATE INDEX idx_consultations_user_id ON public.consultations(user_id);
CREATE INDEX idx_consultations_doctor_id ON public.consultations(doctor_id);
CREATE INDEX idx_consultations_child_id ON public.consultations(child_id);
CREATE INDEX idx_consultations_status ON public.consultations(status);
CREATE INDEX idx_consultations_start_time ON public.consultations(start_time);

-- Message indexes
CREATE INDEX idx_consultation_messages_consultation_id ON public.consultation_messages(consultation_id);
CREATE INDEX idx_consultation_messages_sender_id ON public.consultation_messages(sender_id);
CREATE INDEX idx_consultation_messages_created_at ON public.consultation_messages(created_at);

-- Payment indexes
CREATE INDEX idx_payments_consultation_id ON public.payments(consultation_id);
CREATE INDEX idx_payments_user_id ON public.payments(user_id);
CREATE INDEX idx_payments_status ON public.payments(status);
CREATE INDEX idx_payments_payment_date ON public.payments(payment_date);

-- Add full-text search capabilities for consultation history
CREATE INDEX idx_consultation_messages_text_search ON public.consultation_messages
    USING gin(to_tsvector('english', COALESCE(original_text, '') || ' ' || COALESCE(ai_processed_text, '')));

-- Add index for blog content age filtering
CREATE INDEX idx_blog_articles_age_range ON public.blog_articles(target_age_min, target_age_max);

----------------- TRIGGERS AND FUNCTIONS -----------------

-- Trigger to update timestamps
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to all tables with updated_at column
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'updated_at' AND table_schema = 'public'
    LOOP
        EXECUTE format('CREATE TRIGGER update_timestamp BEFORE UPDATE ON public.%I FOR EACH ROW EXECUTE FUNCTION update_timestamp()', t);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Apply audit log triggers to key tables
CREATE TRIGGER audit_users_trigger AFTER INSERT OR UPDATE OR DELETE ON public.users 
    FOR EACH ROW EXECUTE FUNCTION private.audit_log_func();

CREATE TRIGGER audit_consultations_trigger AFTER INSERT OR UPDATE OR DELETE ON public.consultations 
    FOR EACH ROW EXECUTE FUNCTION private.audit_log_func();

CREATE TRIGGER audit_payments_trigger AFTER INSERT OR UPDATE OR DELETE ON public.payments 
    FOR EACH ROW EXECUTE FUNCTION private.audit_log_func();

-- Trigger to auto-update doctor ratings when feedback is submitted
CREATE OR REPLACE FUNCTION update_doctor_rating() RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.doctors
    SET 
        average_rating = (
            SELECT COALESCE(AVG(rating), 0) 
            FROM public.consultation_feedback 
            WHERE doctor_id = NEW.doctor_id
        ),
        total_ratings = (
            SELECT COUNT(*) 
            FROM public.consultation_feedback 
            WHERE doctor_id = NEW.doctor_id
        ),
        updated_at = NOW()
    WHERE id = NEW.doctor_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_doctor_rating_trigger
AFTER INSERT OR UPDATE ON public.consultation_feedback
FOR EACH ROW EXECUTE FUNCTION update_doctor_rating();

-- Function for handling notifications
CREATE OR REPLACE FUNCTION create_notification(
    p_user_id UUID, 
    p_title TEXT, 
    p_body TEXT, 
    p_type TEXT, 
    p_related_entity_id UUID,
    p_send_push BOOLEAN DEFAULT TRUE
) RETURNS UUID AS $$
DECLARE
    new_notification_id UUID;
BEGIN
    INSERT INTO public.notifications (
        user_id, title, body, type, related_entity_id, send_push
    ) VALUES (
        p_user_id, p_title, p_body, p_type, p_related_entity_id, p_send_push
    )
    RETURNING id INTO new_notification_id;
    
    -- Here you would add code to send push notification
    -- through your notification service
    
    RETURN new_notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update consultation status when doctor replies
CREATE OR REPLACE FUNCTION update_consultation_on_reply() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.sender_type = 'doctor' THEN
        IF NEW.message_type = 'final_answer' THEN
            UPDATE public.consultations
            SET 
                status = 'completed',
                end_time = NOW()
            WHERE id = NEW.consultation_id AND status != 'completed';
        ELSIF NEW.message_type = 'clarification' THEN
            UPDATE public.consultations
            SET status = 'pending_clarification'
            WHERE id = NEW.consultation_id AND status = 'awaiting_doctor';
        END IF;
        
        -- Update replies counter
        UPDATE public.consultations
        SET replies_used = replies_used + 1
        WHERE id = NEW.consultation_id;
        
        -- Create notification for user
        PERFORM create_notification(
            (SELECT user_id FROM public.consultations WHERE id = NEW.consultation_id),
            'New doctor response',
            'Doctor has replied to your consultation',
            'new_reply',
            NEW.consultation_id,
            TRUE
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_consultation_on_reply_trigger
AFTER INSERT ON public.consultation_messages
FOR EACH ROW
WHEN (NEW.sender_type = 'doctor')
EXECUTE FUNCTION update_consultation_on_reply();

-- Initial data for packages
INSERT INTO public.consultation_packages (name, description, price_idr, is_unlimited, max_replies, duration_minutes)
VALUES 
    ('Comprehensive Consultation', 'Unlimited topics for 30 minutes', 50000, true, NULL, 30),
    ('Focused Topic', 'Single topic consultation', 20000, false, 3, NULL);

-- Insert default language resources
INSERT INTO public.language_resources (language_code, resource_key, resource_value)
VALUES
    ('en', 'app.welcome', 'Welcome to AhliAnak'),
    ('id', 'app.welcome', 'Selamat datang di AhliAnak'),
    ('en', 'app.login', 'Login'),
    ('id', 'app.login', 'Masuk');

-- Comment explaining security measures
COMMENT ON DATABASE postgres IS 'AhliAnak secure database with Row Level Security, encryption for sensitive data, and audit logging';

----------------- EMAIL SYSTEM -----------------

-- Email Templates Table
CREATE TABLE public.email_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_name VARCHAR(100) UNIQUE NOT NULL,
    subject TEXT NOT NULL,
    html_content TEXT NOT NULL,
    text_content TEXT NOT NULL,
    language_code VARCHAR(5) NOT NULL CHECK (language_code IN ('id', 'en')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Email Log Table
CREATE TABLE private.email_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    email_address TEXT NOT NULL,
    template_name VARCHAR(100) REFERENCES public.email_templates(template_name),
    subject TEXT NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('queued', 'sent', 'delivered', 'failed', 'bounced', 'opened', 'clicked')),
    resend_message_id TEXT,
    related_entity_type VARCHAR(20),
    related_entity_id UUID,
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    ip_address TEXT,
    user_agent TEXT,
    sent_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Email Preferences Table
CREATE TABLE public.email_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    account_emails BOOLEAN DEFAULT TRUE,
    consultation_emails BOOLEAN DEFAULT TRUE,
    payment_emails BOOLEAN DEFAULT TRUE,
    feedback_emails BOOLEAN DEFAULT TRUE,
    marketing_emails BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_user_email_preferences UNIQUE (user_id)
);

-- Add email bounce tracking to users table
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS email_bounced BOOLEAN DEFAULT FALSE;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS email_bounce_reason TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS last_email_activity TIMESTAMPTZ;

-- Function to log email sending
CREATE OR REPLACE FUNCTION log_email_sent(
    p_user_id UUID,
    p_email_address TEXT,
    p_template_name VARCHAR(100),
    p_subject TEXT,
    p_resend_message_id TEXT,
    p_related_entity_type VARCHAR(20),
    p_related_entity_id UUID
) RETURNS UUID AS $$
DECLARE
    new_log_id UUID;
BEGIN
    INSERT INTO private.email_logs (
        user_id, email_address, template_name, subject, status, 
        resend_message_id, related_entity_type, related_entity_id, sent_at
    ) VALUES (
        p_user_id, p_email_address, p_template_name, p_subject, 'sent',
        p_resend_message_id, p_related_entity_type, p_related_entity_id, NOW()
    )
    RETURNING id INTO new_log_id;
    
    -- Update last email activity timestamp
    IF p_user_id IS NOT NULL THEN
        UPDATE public.users
        SET last_email_activity = NOW()
        WHERE id = p_user_id;
    END IF;
    
    RETURN new_log_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update email status
CREATE OR REPLACE FUNCTION update_email_status(
    p_resend_message_id TEXT,
    p_status VARCHAR(20),
    p_error_message TEXT DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
    affected_user_id UUID;
BEGIN
    UPDATE private.email_logs
    SET 
        status = p_status,
        error_message = COALESCE(p_error_message, error_message),
        updated_at = NOW()
    WHERE resend_message_id = p_resend_message_id
    RETURNING user_id INTO affected_user_id;
    
    -- Handle bounces or failures
    IF p_status IN ('bounced', 'failed') AND affected_user_id IS NOT NULL THEN
        UPDATE public.users
        SET 
            email_bounced = TRUE,
            email_bounce_reason = p_error_message,
            updated_at = NOW()
        WHERE id = affected_user_id;
    END IF;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create default email preferences for new users
CREATE OR REPLACE FUNCTION create_default_email_preferences() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.email_preferences (user_id)
    VALUES (NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_default_email_preferences_trigger
AFTER INSERT ON public.users
FOR EACH ROW EXECUTE FUNCTION create_default_email_preferences();

-- Create RLS policies for email preferences
ALTER TABLE public.email_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY email_templates_read_only ON public.email_templates
    FOR SELECT USING (true);

CREATE POLICY email_preferences_user_access ON public.email_preferences
    USING (user_id = auth.uid());

-- Create indexes for email-related tables
CREATE INDEX idx_email_logs_user_id ON private.email_logs(user_id);
CREATE INDEX idx_email_logs_status ON private.email_logs(status);
CREATE INDEX idx_email_logs_resend_message_id ON private.email_logs(resend_message_id);
CREATE INDEX idx_email_logs_created_at ON private.email_logs(created_at);

-- Insert default email templates
INSERT INTO public.email_templates (template_name, subject, html_content, text_content, language_code)
VALUES 
    ('account_verification_en', 'Verify Your AhliAnak Account', '<h1>Welcome to AhliAnak!</h1><p>Please verify your account by clicking the button below:</p><p><a href="{{verificationLink}}">Verify Account</a></p>', 'Welcome to AhliAnak! Please verify your account by visiting this link: {{verificationLink}}', 'en'),
    ('account_verification_id', 'Verifikasi Akun AhliAnak Anda', '<h1>Selamat Datang di AhliAnak!</h1><p>Silakan verifikasi akun Anda dengan mengklik tombol di bawah ini:</p><p><a href="{{verificationLink}}">Verifikasi Akun</a></p>', 'Selamat Datang di AhliAnak! Silakan verifikasi akun Anda dengan mengunjungi tautan ini: {{verificationLink}}', 'id'),
    ('password_reset_en', 'Reset Your AhliAnak Password', '<h1>Password Reset Request</h1><p>Click the button below to reset your password:</p><p><a href="{{resetLink}}">Reset Password</a></p><p>If you did not request this, please ignore this email.</p>', 'Password Reset Request. Click this link to reset your password: {{resetLink}}. If you did not request this, please ignore this email.', 'en'),
    ('password_reset_id', 'Reset Kata Sandi AhliAnak Anda', '<h1>Permintaan Reset Kata Sandi</h1><p>Klik tombol di bawah ini untuk mereset kata sandi Anda:</p><p><a href="{{resetLink}}">Reset Kata Sandi</a></p><p>Jika Anda tidak meminta ini, abaikan email ini.</p>', 'Permintaan Reset Kata Sandi. Klik tautan ini untuk mereset kata sandi Anda: {{resetLink}}. Jika Anda tidak meminta ini, abaikan email ini.', 'id'),
    ('doctor_reply_en', 'New Doctor Response on AhliAnak', '<h1>Your Doctor Has Responded</h1><p>The doctor has responded to your consultation. Click below to view:</p><p><a href="{{consultationLink}}">View Consultation</a></p>', 'Your doctor has responded to your consultation. Visit this link to view: {{consultationLink}}', 'en'),
    ('doctor_reply_id', 'Respon Baru dari Dokter di AhliAnak', '<h1>Dokter Anda Telah Merespon</h1><p>Dokter telah merespon konsultasi Anda. Klik di bawah untuk melihat:</p><p><a href="{{consultationLink}}">Lihat Konsultasi</a></p>', 'Dokter Anda telah merespon konsultasi Anda. Kunjungi tautan ini untuk melihat: {{consultationLink}}', 'id'),
    ('payment_confirmation_en', 'Payment Confirmation - AhliAnak', '<h1>Payment Confirmed</h1><p>Your payment of {{amount}} has been confirmed. Your consultation is now active.</p><p><a href="{{consultationLink}}">Start Consultation</a></p>', 'Your payment of {{amount}} has been confirmed. Your consultation is now active. Start consultation: {{consultationLink}}', 'en'),
    ('payment_confirmation_id', 'Konfirmasi Pembayaran - AhliAnak', '<h1>Pembayaran Dikonfirmasi</h1><p>Pembayaran Anda sebesar {{amount}} telah dikonfirmasi. Konsultasi Anda sekarang aktif.</p><p><a href="{{consultationLink}}">Mulai Konsultasi</a></p>', 'Pembayaran Anda sebesar {{amount}} telah dikonfirmasi. Konsultasi Anda sekarang aktif. Mulai konsultasi: {{consultationLink}}', 'id'),
    ('feedback_request_en', 'Please Share Your Feedback - AhliAnak', '<h1>How Was Your Consultation?</h1><p>We would love to hear about your experience. Please take a moment to provide feedback:</p><p><a href="{{feedbackLink}}">Share Feedback</a></p>', 'How was your consultation? We would love to hear about your experience. Please share your feedback: {{feedbackLink}}', 'en'),
    ('feedback_request_id', 'Mohon Bagikan Umpan Balik Anda - AhliAnak', '<h1>Bagaimana Konsultasi Anda?</h1><p>Kami ingin mendengar tentang pengalaman Anda. Mohon luangkan waktu untuk memberikan umpan balik:</p><p><a href="{{feedbackLink}}">Bagikan Umpan Balik</a></p>', 'Bagaimana konsultasi Anda? Kami ingin mendengar tentang pengalaman Anda. Mohon bagikan umpan balik Anda: {{feedbackLink}}', 'id');

-- Comment explaining email system
COMMENT ON TABLE public.email_templates IS 'Stores templates for transactional emails sent via Resend API';
COMMENT ON TABLE private.email_logs IS 'Logs all email sending activity, delivery status, and tracking for audit and troubleshooting';
COMMENT ON TABLE public.email_preferences IS 'Stores user preferences for different types of emails';
