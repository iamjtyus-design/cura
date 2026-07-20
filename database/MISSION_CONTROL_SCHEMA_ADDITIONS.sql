-- Future Mission Control schema additions.
-- Do not deploy as part of the temporary-processing-only V1 unless persistent
-- cloud sync is intentionally enabled and covered by updated privacy terms.

create table public.capture_sessions (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  mode text not null,
  folder_id uuid,
  is_favorite boolean not null default false,
  processing_mode text not null,
  output_language text not null default 'en',
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz
);

create table public.knowledge_entities (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  capture_session_id uuid not null
    references public.capture_sessions(id) on delete cascade,
  entity_type text not null
    check (entity_type in (
      'idea',
      'decision',
      'action_item',
      'commitment',
      'person',
      'organization',
      'project',
      'risk',
      'knowledge_topic',
      'content_opportunity'
    )),
  title text not null,
  payload jsonb not null default '{}'::jsonb,
  confidence numeric,
  evidence_references jsonb not null default '[]'::jsonb,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table public.entity_links (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  source_entity_id uuid not null
    references public.knowledge_entities(id) on delete cascade,
  target_entity_id uuid not null
    references public.knowledge_entities(id) on delete cascade,
  relationship text not null,
  confidence numeric,
  evidence_references jsonb not null default '[]'::jsonb,
  created_at timestamptz not null,
  unique(source_entity_id, target_entity_id, relationship)
);

alter table public.capture_sessions enable row level security;
alter table public.knowledge_entities enable row level security;
alter table public.entity_links enable row level security;

create policy "capture_sessions_own"
on public.capture_sessions for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "knowledge_entities_own"
on public.knowledge_entities for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "entity_links_own"
on public.entity_links for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create index knowledge_entities_session_idx
  on public.knowledge_entities(capture_session_id, entity_type);

create index entity_links_source_idx
  on public.entity_links(source_entity_id);

create index entity_links_target_idx
  on public.entity_links(target_entity_id);
