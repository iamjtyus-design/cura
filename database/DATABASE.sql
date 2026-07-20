-- CURA Supabase starter schema
-- Temporary-processing architecture for the V1 mobile beta.
-- Review all policies and retention behavior in a development project before production.

create extension if not exists "pgcrypto";
create extension if not exists "vector";

create type public.processing_mode as enum ('private', 'smart', 'sync_future');

create type public.processing_session_status as enum (
  'draft',
  'preparing',
  'uploading',
  'queued',
  'processing',
  'partially_complete',
  'completed',
  'failed',
  'cancelled',
  'deleting',
  'deleted',
  'expired'
);

create type public.processing_source_type as enum (
  'audio_recording',
  'audio_file',
  'video_recording',
  'video_file',
  'photo',
  'screenshot',
  'pdf',
  'web_page',
  'youtube_url',
  'social_url',
  'text_note'
);

create type public.processing_job_status as enum (
  'queued',
  'running',
  'succeeded',
  'failed',
  'cancelled',
  'expired'
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  preferred_language text not null default 'en',
  timezone text,
  accepted_terms_version text,
  accepted_privacy_version text,
  recording_notice_acknowledged_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.processing_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  client_session_id uuid not null,
  title text not null default 'Untitled Session',
  mode text not null default 'unselected'
    check (mode in ('learn', 'create', 'work', 'unselected')),
  processing_mode public.processing_mode not null default 'smart',
  output_language text not null default 'en',
  requested_output_keys text[] not null default '{}',
  status public.processing_session_status not null default 'draft',
  error_code text,
  error_message text,
  result_expires_at timestamptz,
  results_retrieved_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, client_session_id)
);

create index processing_sessions_user_created_idx
  on public.processing_sessions(user_id, created_at desc);

create table public.processing_sources (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  processing_session_id uuid not null
    references public.processing_sessions(id) on delete cascade,
  client_source_id uuid not null,
  source_type public.processing_source_type not null,
  original_filename text,
  mime_type text,
  file_size_bytes bigint,
  duration_seconds numeric,
  page_count integer,
  source_url text,
  transcript_origin text
    check (
      transcript_origin is null or transcript_origin in (
        'speech_to_text',
        'official_caption',
        'authorized_caption',
        'gemini_reconstruction',
        'ocr',
        'manual',
        'imported_text'
      )
    ),
  temporary_storage_path text,
  upload_completed_at timestamptz,
  processing_completed_at timestamptz,
  temporary_deleted_at timestamptz,
  created_at timestamptz not null default now(),
  unique(user_id, client_source_id)
);

create index processing_sources_session_idx
  on public.processing_sources(processing_session_id, created_at);

create table public.processing_jobs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  processing_session_id uuid not null
    references public.processing_sessions(id) on delete cascade,
  processing_source_id uuid
    references public.processing_sources(id) on delete cascade,
  job_type text not null,
  stage text not null,
  status public.processing_job_status not null default 'queued',
  attempt integer not null default 0,
  max_attempts integer not null default 3,
  idempotency_key text not null,
  provider text,
  model text,
  request_id text,
  usage jsonb not null default '{}'::jsonb,
  error_code text,
  error_message text,
  started_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  unique(user_id, idempotency_key)
);

create index processing_jobs_session_idx
  on public.processing_jobs(processing_session_id, created_at);

create table public.processing_results (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  processing_session_id uuid not null
    references public.processing_sessions(id) on delete cascade,
  result_type text not null
    check (result_type in (
      'transcript',
      'source_observations',
      'curated_note',
      'output_pack',
      'visual_brief',
      'export_manifest'
    )),
  schema_version text not null,
  prompt_version text,
  provider text,
  model text,
  payload jsonb not null,
  expires_at timestamptz not null,
  retrieved_at timestamptz,
  deleted_at timestamptz,
  created_at timestamptz not null default now()
);

create index processing_results_session_idx
  on public.processing_results(processing_session_id, result_type, created_at desc);

create table public.temporary_objects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  processing_session_id uuid
    references public.processing_sessions(id) on delete cascade,
  processing_source_id uuid
    references public.processing_sources(id) on delete cascade,
  bucket text not null,
  object_path text not null,
  object_type text not null,
  size_bytes bigint,
  expires_at timestamptz not null,
  deleted_at timestamptz,
  deletion_attempts integer not null default 0,
  last_deletion_error text,
  created_at timestamptz not null default now(),
  unique(bucket, object_path)
);

create index temporary_objects_expiration_idx
  on public.temporary_objects(expires_at)
  where deleted_at is null;

create table public.usage_ledger (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  processing_session_id uuid
    references public.processing_sessions(id) on delete set null,
  processing_source_id uuid
    references public.processing_sources(id) on delete set null,
  event_type text not null,
  quantity numeric not null,
  unit text not null,
  provider text,
  model text,
  estimated_cost_usd numeric,
  idempotency_key text not null,
  created_at timestamptz not null default now(),
  unique(user_id, idempotency_key)
);

create index usage_ledger_user_created_idx
  on public.usage_ledger(user_id, created_at desc);

create table public.user_entitlements (
  user_id uuid primary key references auth.users(id) on delete cascade,
  entitlement text not null default 'free',
  product_id text,
  status text not null default 'inactive',
  expires_at timestamptz,
  revenuecat_customer_id text,
  updated_at timestamptz not null default now()
);

create table public.subscription_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  provider_event_id text not null unique,
  event_type text not null,
  payload jsonb not null,
  processed_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.deletion_jobs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  processing_session_id uuid
    references public.processing_sessions(id) on delete cascade,
  deletion_type text not null
    check (deletion_type in ('temporary_objects', 'processing_session', 'account')),
  status text not null default 'queued'
    check (status in ('queued', 'running', 'succeeded', 'failed')),
  attempt integer not null default 0,
  error_message text,
  started_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.provider_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  processing_session_id uuid
    references public.processing_sessions(id) on delete set null,
  provider text not null,
  request_id text,
  stage text,
  status text,
  latency_ms integer,
  input_units numeric,
  output_units numeric,
  error_code text,
  created_at timestamptz not null default now()
);

create table public.beta_waitlist (
  id uuid primary key default gen_random_uuid(),
  email text not null,
  first_name text,
  primary_mode text
    check (primary_mode is null or primary_mode in ('learn', 'create', 'work', 'several')),
  main_capture_type text,
  is_iphone_user boolean,
  use_case text,
  consent_to_updates boolean not null default false,
  consented_at timestamptz,
  source_campaign text,
  created_at timestamptz not null default now()
);

create unique index beta_waitlist_email_unique_idx
  on public.beta_waitlist(lower(email));

alter table public.profiles enable row level security;
alter table public.processing_sessions enable row level security;
alter table public.processing_sources enable row level security;
alter table public.processing_jobs enable row level security;
alter table public.processing_results enable row level security;
alter table public.temporary_objects enable row level security;
alter table public.usage_ledger enable row level security;
alter table public.user_entitlements enable row level security;
alter table public.subscription_events enable row level security;
alter table public.deletion_jobs enable row level security;
alter table public.provider_events enable row level security;
alter table public.beta_waitlist enable row level security;

create policy "profiles_select_own"
on public.profiles for select
using (auth.uid() = id);

create policy "profiles_update_own"
on public.profiles for update
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "processing_sessions_select_own"
on public.processing_sessions for select
using (auth.uid() = user_id);

create policy "processing_sessions_insert_own"
on public.processing_sessions for insert
with check (auth.uid() = user_id);

create policy "processing_sessions_update_own"
on public.processing_sessions for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "processing_sessions_delete_own"
on public.processing_sessions for delete
using (auth.uid() = user_id);

create policy "processing_sources_select_own"
on public.processing_sources for select
using (auth.uid() = user_id);

create policy "processing_sources_insert_own"
on public.processing_sources for insert
with check (auth.uid() = user_id);

create policy "processing_sources_update_own"
on public.processing_sources for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "processing_results_select_own"
on public.processing_results for select
using (auth.uid() = user_id);

create policy "usage_ledger_select_own"
on public.usage_ledger for select
using (auth.uid() = user_id);

create policy "user_entitlements_select_own"
on public.user_entitlements for select
using (auth.uid() = user_id);

-- processing_jobs, temporary_objects, subscription_events, deletion_jobs,
-- and provider_events should normally be written through trusted server functions.
-- Add narrowly scoped policies only after the production call paths are defined.

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create trigger processing_sessions_set_updated_at
before update on public.processing_sessions
for each row execute function public.set_updated_at();

-- Storage buckets should be private:
-- temporary-source
-- temporary-derived
-- temporary-exports
--
-- Create user-scoped storage policies and test cross-user denial before production.
