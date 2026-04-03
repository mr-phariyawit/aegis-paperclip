-- Paperclip database backup
-- Created: 2026-04-03T08:05:33.781Z

BEGIN;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
SET LOCAL session_replication_role = replica;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
SET LOCAL client_min_messages = warning;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Sequences
DROP SEQUENCE IF EXISTS "public"."heartbeat_run_events_id_seq" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE SEQUENCE "public"."heartbeat_run_events_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 NO CYCLE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.account
DROP TABLE IF EXISTS "public"."account" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."account" (
  "id" text NOT NULL,
  "account_id" text NOT NULL,
  "provider_id" text NOT NULL,
  "user_id" text NOT NULL,
  "access_token" text,
  "refresh_token" text,
  "id_token" text,
  "access_token_expires_at" timestamp with time zone,
  "refresh_token_expires_at" timestamp with time zone,
  "scope" text,
  "password" text,
  "created_at" timestamp with time zone NOT NULL,
  "updated_at" timestamp with time zone NOT NULL,
  CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.activity_log
DROP TABLE IF EXISTS "public"."activity_log" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."activity_log" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "actor_type" text DEFAULT 'system'::text NOT NULL,
  "actor_id" text NOT NULL,
  "action" text NOT NULL,
  "entity_type" text NOT NULL,
  "entity_id" text NOT NULL,
  "agent_id" uuid,
  "details" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "run_id" uuid,
  CONSTRAINT "activity_log_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_api_keys
DROP TABLE IF EXISTS "public"."agent_api_keys" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_api_keys" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "agent_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "name" text NOT NULL,
  "key_hash" text NOT NULL,
  "last_used_at" timestamp with time zone,
  "revoked_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_api_keys_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_config_revisions
DROP TABLE IF EXISTS "public"."agent_config_revisions" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_config_revisions" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "source" text DEFAULT 'patch'::text NOT NULL,
  "rolled_back_from_revision_id" uuid,
  "changed_keys" jsonb DEFAULT '[]'::jsonb NOT NULL,
  "before_config" jsonb NOT NULL,
  "after_config" jsonb NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_config_revisions_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_runtime_state
DROP TABLE IF EXISTS "public"."agent_runtime_state" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_runtime_state" (
  "agent_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "adapter_type" text NOT NULL,
  "session_id" text,
  "state_json" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "last_run_id" uuid,
  "last_run_status" text,
  "total_input_tokens" bigint DEFAULT 0 NOT NULL,
  "total_output_tokens" bigint DEFAULT 0 NOT NULL,
  "total_cached_input_tokens" bigint DEFAULT 0 NOT NULL,
  "total_cost_cents" bigint DEFAULT 0 NOT NULL,
  "last_error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_runtime_state_pkey" PRIMARY KEY ("agent_id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_task_sessions
DROP TABLE IF EXISTS "public"."agent_task_sessions" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_task_sessions" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "adapter_type" text NOT NULL,
  "task_key" text NOT NULL,
  "session_params_json" jsonb,
  "session_display_id" text,
  "last_run_id" uuid,
  "last_error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_task_sessions_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_wakeup_requests
DROP TABLE IF EXISTS "public"."agent_wakeup_requests" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_wakeup_requests" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "source" text NOT NULL,
  "trigger_detail" text,
  "reason" text,
  "payload" jsonb,
  "status" text DEFAULT 'queued'::text NOT NULL,
  "coalesced_count" integer DEFAULT 0 NOT NULL,
  "requested_by_actor_type" text,
  "requested_by_actor_id" text,
  "idempotency_key" text,
  "run_id" uuid,
  "requested_at" timestamp with time zone DEFAULT now() NOT NULL,
  "claimed_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_wakeup_requests_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agents
DROP TABLE IF EXISTS "public"."agents" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agents" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "name" text NOT NULL,
  "role" text DEFAULT 'general'::text NOT NULL,
  "title" text,
  "status" text DEFAULT 'idle'::text NOT NULL,
  "reports_to" uuid,
  "capabilities" text,
  "adapter_type" text DEFAULT 'process'::text NOT NULL,
  "adapter_config" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "budget_monthly_cents" integer DEFAULT 0 NOT NULL,
  "spent_monthly_cents" integer DEFAULT 0 NOT NULL,
  "last_heartbeat_at" timestamp with time zone,
  "metadata" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "runtime_config" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "permissions" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "icon" text,
  "pause_reason" text,
  "paused_at" timestamp with time zone,
  CONSTRAINT "agents_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.approval_comments
DROP TABLE IF EXISTS "public"."approval_comments" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."approval_comments" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "approval_id" uuid NOT NULL,
  "author_agent_id" uuid,
  "author_user_id" text,
  "body" text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "approval_comments_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.approvals
DROP TABLE IF EXISTS "public"."approvals" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."approvals" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "type" text NOT NULL,
  "requested_by_agent_id" uuid,
  "requested_by_user_id" text,
  "status" text DEFAULT 'pending'::text NOT NULL,
  "payload" jsonb NOT NULL,
  "decision_note" text,
  "decided_by_user_id" text,
  "decided_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "approvals_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.assets
DROP TABLE IF EXISTS "public"."assets" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."assets" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "provider" text NOT NULL,
  "object_key" text NOT NULL,
  "content_type" text NOT NULL,
  "byte_size" integer NOT NULL,
  "sha256" text NOT NULL,
  "original_filename" text,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "assets_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.board_api_keys
DROP TABLE IF EXISTS "public"."board_api_keys" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."board_api_keys" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "user_id" text NOT NULL,
  "name" text NOT NULL,
  "key_hash" text NOT NULL,
  "last_used_at" timestamp with time zone,
  "revoked_at" timestamp with time zone,
  "expires_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "board_api_keys_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.budget_incidents
DROP TABLE IF EXISTS "public"."budget_incidents" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."budget_incidents" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "policy_id" uuid NOT NULL,
  "scope_type" text NOT NULL,
  "scope_id" uuid NOT NULL,
  "metric" text NOT NULL,
  "window_kind" text NOT NULL,
  "window_start" timestamp with time zone NOT NULL,
  "window_end" timestamp with time zone NOT NULL,
  "threshold_type" text NOT NULL,
  "amount_limit" integer NOT NULL,
  "amount_observed" integer NOT NULL,
  "status" text DEFAULT 'open'::text NOT NULL,
  "approval_id" uuid,
  "resolved_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "budget_incidents_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.budget_policies
DROP TABLE IF EXISTS "public"."budget_policies" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."budget_policies" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "scope_type" text NOT NULL,
  "scope_id" uuid NOT NULL,
  "metric" text DEFAULT 'billed_cents'::text NOT NULL,
  "window_kind" text NOT NULL,
  "amount" integer DEFAULT 0 NOT NULL,
  "warn_percent" integer DEFAULT 80 NOT NULL,
  "hard_stop_enabled" boolean DEFAULT true NOT NULL,
  "notify_enabled" boolean DEFAULT true NOT NULL,
  "is_active" boolean DEFAULT true NOT NULL,
  "created_by_user_id" text,
  "updated_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "budget_policies_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.cli_auth_challenges
DROP TABLE IF EXISTS "public"."cli_auth_challenges" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."cli_auth_challenges" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "secret_hash" text NOT NULL,
  "command" text NOT NULL,
  "client_name" text,
  "requested_access" text DEFAULT 'board'::text NOT NULL,
  "requested_company_id" uuid,
  "pending_key_hash" text NOT NULL,
  "pending_key_name" text NOT NULL,
  "approved_by_user_id" text,
  "board_api_key_id" uuid,
  "approved_at" timestamp with time zone,
  "cancelled_at" timestamp with time zone,
  "expires_at" timestamp with time zone NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "cli_auth_challenges_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.companies
DROP TABLE IF EXISTS "public"."companies" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."companies" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "name" text NOT NULL,
  "description" text,
  "status" text DEFAULT 'active'::text NOT NULL,
  "budget_monthly_cents" integer DEFAULT 0 NOT NULL,
  "spent_monthly_cents" integer DEFAULT 0 NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "issue_prefix" text DEFAULT 'PAP'::text NOT NULL,
  "issue_counter" integer DEFAULT 0 NOT NULL,
  "require_board_approval_for_new_agents" boolean DEFAULT true NOT NULL,
  "brand_color" text,
  "pause_reason" text,
  "paused_at" timestamp with time zone,
  "feedback_data_sharing_enabled" boolean DEFAULT false NOT NULL,
  "feedback_data_sharing_consent_at" timestamp with time zone,
  "feedback_data_sharing_consent_by_user_id" text,
  "feedback_data_sharing_terms_version" text,
  CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_logos
DROP TABLE IF EXISTS "public"."company_logos" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_logos" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "asset_id" uuid NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "company_logos_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_memberships
DROP TABLE IF EXISTS "public"."company_memberships" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_memberships" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "principal_type" text NOT NULL,
  "principal_id" text NOT NULL,
  "status" text DEFAULT 'active'::text NOT NULL,
  "membership_role" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "company_memberships_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_secret_versions
DROP TABLE IF EXISTS "public"."company_secret_versions" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_secret_versions" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "secret_id" uuid NOT NULL,
  "version" integer NOT NULL,
  "material" jsonb NOT NULL,
  "value_sha256" text NOT NULL,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "revoked_at" timestamp with time zone,
  CONSTRAINT "company_secret_versions_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_secrets
DROP TABLE IF EXISTS "public"."company_secrets" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_secrets" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "name" text NOT NULL,
  "provider" text DEFAULT 'local_encrypted'::text NOT NULL,
  "external_ref" text,
  "latest_version" integer DEFAULT 1 NOT NULL,
  "description" text,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "company_secrets_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_skills
DROP TABLE IF EXISTS "public"."company_skills" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_skills" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "key" text NOT NULL,
  "slug" text NOT NULL,
  "name" text NOT NULL,
  "description" text,
  "markdown" text NOT NULL,
  "source_type" text DEFAULT 'local_path'::text NOT NULL,
  "source_locator" text,
  "source_ref" text,
  "trust_level" text DEFAULT 'markdown_only'::text NOT NULL,
  "compatibility" text DEFAULT 'compatible'::text NOT NULL,
  "file_inventory" jsonb DEFAULT '[]'::jsonb NOT NULL,
  "metadata" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "company_skills_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.cost_events
DROP TABLE IF EXISTS "public"."cost_events" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."cost_events" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "issue_id" uuid,
  "project_id" uuid,
  "goal_id" uuid,
  "billing_code" text,
  "provider" text NOT NULL,
  "model" text NOT NULL,
  "input_tokens" integer DEFAULT 0 NOT NULL,
  "output_tokens" integer DEFAULT 0 NOT NULL,
  "cost_cents" integer NOT NULL,
  "occurred_at" timestamp with time zone NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "heartbeat_run_id" uuid,
  "biller" text DEFAULT 'unknown'::text NOT NULL,
  "billing_type" text DEFAULT 'unknown'::text NOT NULL,
  "cached_input_tokens" integer DEFAULT 0 NOT NULL,
  CONSTRAINT "cost_events_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.document_revisions
DROP TABLE IF EXISTS "public"."document_revisions" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."document_revisions" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "document_id" uuid NOT NULL,
  "revision_number" integer NOT NULL,
  "body" text NOT NULL,
  "change_summary" text,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "title" text,
  "format" text DEFAULT 'markdown'::text NOT NULL,
  "created_by_run_id" uuid,
  CONSTRAINT "document_revisions_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.documents
DROP TABLE IF EXISTS "public"."documents" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."documents" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "title" text,
  "format" text DEFAULT 'markdown'::text NOT NULL,
  "latest_body" text NOT NULL,
  "latest_revision_id" uuid,
  "latest_revision_number" integer DEFAULT 1 NOT NULL,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "updated_by_agent_id" uuid,
  "updated_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.execution_workspaces
DROP TABLE IF EXISTS "public"."execution_workspaces" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."execution_workspaces" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid NOT NULL,
  "project_workspace_id" uuid,
  "source_issue_id" uuid,
  "mode" text NOT NULL,
  "strategy_type" text NOT NULL,
  "name" text NOT NULL,
  "status" text DEFAULT 'active'::text NOT NULL,
  "cwd" text,
  "repo_url" text,
  "base_ref" text,
  "branch_name" text,
  "provider_type" text DEFAULT 'local_fs'::text NOT NULL,
  "provider_ref" text,
  "derived_from_execution_workspace_id" uuid,
  "last_used_at" timestamp with time zone DEFAULT now() NOT NULL,
  "opened_at" timestamp with time zone DEFAULT now() NOT NULL,
  "closed_at" timestamp with time zone,
  "cleanup_eligible_at" timestamp with time zone,
  "cleanup_reason" text,
  "metadata" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "execution_workspaces_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.feedback_exports
DROP TABLE IF EXISTS "public"."feedback_exports" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."feedback_exports" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "feedback_vote_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "project_id" uuid,
  "author_user_id" text NOT NULL,
  "target_type" text NOT NULL,
  "target_id" text NOT NULL,
  "vote" text NOT NULL,
  "status" text DEFAULT 'local_only'::text NOT NULL,
  "destination" text,
  "export_id" text,
  "consent_version" text,
  "schema_version" text DEFAULT 'paperclip-feedback-envelope-v2'::text NOT NULL,
  "bundle_version" text DEFAULT 'paperclip-feedback-bundle-v2'::text NOT NULL,
  "payload_version" text DEFAULT 'paperclip-feedback-v1'::text NOT NULL,
  "payload_digest" text,
  "payload_snapshot" jsonb,
  "target_summary" jsonb NOT NULL,
  "redaction_summary" jsonb,
  "attempt_count" integer DEFAULT 0 NOT NULL,
  "last_attempted_at" timestamp with time zone,
  "exported_at" timestamp with time zone,
  "failure_reason" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "feedback_exports_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.feedback_votes
DROP TABLE IF EXISTS "public"."feedback_votes" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."feedback_votes" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "target_type" text NOT NULL,
  "target_id" text NOT NULL,
  "author_user_id" text NOT NULL,
  "vote" text NOT NULL,
  "reason" text,
  "shared_with_labs" boolean DEFAULT false NOT NULL,
  "shared_at" timestamp with time zone,
  "consent_version" text,
  "redaction_summary" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "feedback_votes_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.finance_events
DROP TABLE IF EXISTS "public"."finance_events" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."finance_events" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid,
  "issue_id" uuid,
  "project_id" uuid,
  "goal_id" uuid,
  "heartbeat_run_id" uuid,
  "cost_event_id" uuid,
  "billing_code" text,
  "description" text,
  "event_kind" text NOT NULL,
  "direction" text DEFAULT 'debit'::text NOT NULL,
  "biller" text NOT NULL,
  "provider" text,
  "execution_adapter_type" text,
  "pricing_tier" text,
  "region" text,
  "model" text,
  "quantity" integer,
  "unit" text,
  "amount_cents" integer NOT NULL,
  "currency" text DEFAULT 'USD'::text NOT NULL,
  "estimated" boolean DEFAULT false NOT NULL,
  "external_invoice_id" text,
  "metadata_json" jsonb,
  "occurred_at" timestamp with time zone NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "finance_events_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.goals
DROP TABLE IF EXISTS "public"."goals" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."goals" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "title" text NOT NULL,
  "description" text,
  "level" text DEFAULT 'task'::text NOT NULL,
  "status" text DEFAULT 'planned'::text NOT NULL,
  "parent_id" uuid,
  "owner_agent_id" uuid,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "goals_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.heartbeat_run_events
DROP TABLE IF EXISTS "public"."heartbeat_run_events" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."heartbeat_run_events" (
  "id" bigint DEFAULT nextval('heartbeat_run_events_id_seq'::regclass) NOT NULL,
  "company_id" uuid NOT NULL,
  "run_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "seq" integer NOT NULL,
  "event_type" text NOT NULL,
  "stream" text,
  "level" text,
  "color" text,
  "message" text,
  "payload" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "heartbeat_run_events_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.heartbeat_runs
DROP TABLE IF EXISTS "public"."heartbeat_runs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."heartbeat_runs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "invocation_source" text DEFAULT 'on_demand'::text NOT NULL,
  "status" text DEFAULT 'queued'::text NOT NULL,
  "started_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "error" text,
  "external_run_id" text,
  "context_snapshot" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "trigger_detail" text,
  "wakeup_request_id" uuid,
  "exit_code" integer,
  "signal" text,
  "usage_json" jsonb,
  "result_json" jsonb,
  "session_id_before" text,
  "session_id_after" text,
  "log_store" text,
  "log_ref" text,
  "log_bytes" bigint,
  "log_sha256" text,
  "log_compressed" boolean DEFAULT false NOT NULL,
  "stdout_excerpt" text,
  "stderr_excerpt" text,
  "error_code" text,
  "process_pid" integer,
  "process_started_at" timestamp with time zone,
  "retry_of_run_id" uuid,
  "process_loss_retry_count" integer DEFAULT 0 NOT NULL,
  CONSTRAINT "heartbeat_runs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.instance_settings
DROP TABLE IF EXISTS "public"."instance_settings" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."instance_settings" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "singleton_key" text DEFAULT 'default'::text NOT NULL,
  "experimental" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "general" jsonb DEFAULT '{}'::jsonb NOT NULL,
  CONSTRAINT "instance_settings_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.instance_user_roles
DROP TABLE IF EXISTS "public"."instance_user_roles" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."instance_user_roles" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "user_id" text NOT NULL,
  "role" text DEFAULT 'instance_admin'::text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "instance_user_roles_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.invites
DROP TABLE IF EXISTS "public"."invites" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."invites" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid,
  "invite_type" text DEFAULT 'company_join'::text NOT NULL,
  "token_hash" text NOT NULL,
  "allowed_join_types" text DEFAULT 'both'::text NOT NULL,
  "defaults_payload" jsonb,
  "expires_at" timestamp with time zone NOT NULL,
  "invited_by_user_id" text,
  "revoked_at" timestamp with time zone,
  "accepted_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "invites_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_approvals
DROP TABLE IF EXISTS "public"."issue_approvals" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_approvals" (
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "approval_id" uuid NOT NULL,
  "linked_by_agent_id" uuid,
  "linked_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_approvals_pk" PRIMARY KEY ("issue_id", "approval_id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_attachments
DROP TABLE IF EXISTS "public"."issue_attachments" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_attachments" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "asset_id" uuid NOT NULL,
  "issue_comment_id" uuid,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_attachments_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_comments
DROP TABLE IF EXISTS "public"."issue_comments" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_comments" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "author_agent_id" uuid,
  "author_user_id" text,
  "body" text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "created_by_run_id" uuid,
  CONSTRAINT "issue_comments_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_documents
DROP TABLE IF EXISTS "public"."issue_documents" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_documents" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "document_id" uuid NOT NULL,
  "key" text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_documents_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_inbox_archives
DROP TABLE IF EXISTS "public"."issue_inbox_archives" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_inbox_archives" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "user_id" text NOT NULL,
  "archived_at" timestamp with time zone DEFAULT now() NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_inbox_archives_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_labels
DROP TABLE IF EXISTS "public"."issue_labels" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_labels" (
  "issue_id" uuid NOT NULL,
  "label_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_labels_pk" PRIMARY KEY ("issue_id", "label_id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_read_states
DROP TABLE IF EXISTS "public"."issue_read_states" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_read_states" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "user_id" text NOT NULL,
  "last_read_at" timestamp with time zone DEFAULT now() NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_read_states_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_work_products
DROP TABLE IF EXISTS "public"."issue_work_products" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_work_products" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid,
  "issue_id" uuid NOT NULL,
  "execution_workspace_id" uuid,
  "runtime_service_id" uuid,
  "type" text NOT NULL,
  "provider" text NOT NULL,
  "external_id" text,
  "title" text NOT NULL,
  "url" text,
  "status" text NOT NULL,
  "review_state" text DEFAULT 'none'::text NOT NULL,
  "is_primary" boolean DEFAULT false NOT NULL,
  "health_status" text DEFAULT 'unknown'::text NOT NULL,
  "summary" text,
  "metadata" jsonb,
  "created_by_run_id" uuid,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_work_products_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issues
DROP TABLE IF EXISTS "public"."issues" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issues" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid,
  "goal_id" uuid,
  "parent_id" uuid,
  "title" text NOT NULL,
  "description" text,
  "status" text DEFAULT 'backlog'::text NOT NULL,
  "priority" text DEFAULT 'medium'::text NOT NULL,
  "assignee_agent_id" uuid,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "request_depth" integer DEFAULT 0 NOT NULL,
  "billing_code" text,
  "started_at" timestamp with time zone,
  "completed_at" timestamp with time zone,
  "cancelled_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "issue_number" integer,
  "identifier" text,
  "hidden_at" timestamp with time zone,
  "checkout_run_id" uuid,
  "execution_run_id" uuid,
  "execution_agent_name_key" text,
  "execution_locked_at" timestamp with time zone,
  "assignee_user_id" text,
  "assignee_adapter_overrides" jsonb,
  "execution_workspace_settings" jsonb,
  "project_workspace_id" uuid,
  "execution_workspace_id" uuid,
  "execution_workspace_preference" text,
  "origin_kind" text DEFAULT 'manual'::text NOT NULL,
  "origin_id" text,
  "origin_run_id" text,
  CONSTRAINT "issues_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.join_requests
DROP TABLE IF EXISTS "public"."join_requests" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."join_requests" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "invite_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "request_type" text NOT NULL,
  "status" text DEFAULT 'pending_approval'::text NOT NULL,
  "request_ip" text NOT NULL,
  "requesting_user_id" text,
  "request_email_snapshot" text,
  "agent_name" text,
  "adapter_type" text,
  "capabilities" text,
  "agent_defaults_payload" jsonb,
  "created_agent_id" uuid,
  "approved_by_user_id" text,
  "approved_at" timestamp with time zone,
  "rejected_by_user_id" text,
  "rejected_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "claim_secret_hash" text,
  "claim_secret_expires_at" timestamp with time zone,
  "claim_secret_consumed_at" timestamp with time zone,
  CONSTRAINT "join_requests_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.labels
DROP TABLE IF EXISTS "public"."labels" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."labels" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "name" text NOT NULL,
  "color" text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "labels_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_company_settings
DROP TABLE IF EXISTS "public"."plugin_company_settings" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_company_settings" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "plugin_id" uuid NOT NULL,
  "settings_json" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "last_error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "enabled" boolean DEFAULT true NOT NULL,
  CONSTRAINT "plugin_company_settings_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_config
DROP TABLE IF EXISTS "public"."plugin_config" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_config" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "config_json" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "last_error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_config_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_entities
DROP TABLE IF EXISTS "public"."plugin_entities" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_entities" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "entity_type" text NOT NULL,
  "scope_kind" text NOT NULL,
  "scope_id" text,
  "external_id" text,
  "title" text,
  "status" text,
  "data" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_entities_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_job_runs
DROP TABLE IF EXISTS "public"."plugin_job_runs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_job_runs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "job_id" uuid NOT NULL,
  "plugin_id" uuid NOT NULL,
  "trigger" text NOT NULL,
  "status" text DEFAULT 'pending'::text NOT NULL,
  "duration_ms" integer,
  "error" text,
  "logs" jsonb DEFAULT '[]'::jsonb NOT NULL,
  "started_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_job_runs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_jobs
DROP TABLE IF EXISTS "public"."plugin_jobs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_jobs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "job_key" text NOT NULL,
  "schedule" text NOT NULL,
  "status" text DEFAULT 'active'::text NOT NULL,
  "last_run_at" timestamp with time zone,
  "next_run_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_jobs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_logs
DROP TABLE IF EXISTS "public"."plugin_logs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_logs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "level" text DEFAULT 'info'::text NOT NULL,
  "message" text NOT NULL,
  "meta" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_logs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_state
DROP TABLE IF EXISTS "public"."plugin_state" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_state" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "scope_kind" text NOT NULL,
  "scope_id" text,
  "namespace" text DEFAULT 'default'::text NOT NULL,
  "state_key" text NOT NULL,
  "value_json" jsonb NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_state_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_webhook_deliveries
DROP TABLE IF EXISTS "public"."plugin_webhook_deliveries" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_webhook_deliveries" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "webhook_key" text NOT NULL,
  "external_id" text,
  "status" text DEFAULT 'pending'::text NOT NULL,
  "duration_ms" integer,
  "error" text,
  "payload" jsonb NOT NULL,
  "headers" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "started_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_webhook_deliveries_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugins
DROP TABLE IF EXISTS "public"."plugins" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugins" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_key" text NOT NULL,
  "package_name" text NOT NULL,
  "package_path" text,
  "version" text NOT NULL,
  "api_version" integer DEFAULT 1 NOT NULL,
  "categories" jsonb DEFAULT '[]'::jsonb NOT NULL,
  "manifest_json" jsonb NOT NULL,
  "status" text DEFAULT 'installed'::text NOT NULL,
  "install_order" integer,
  "last_error" text,
  "installed_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugins_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.principal_permission_grants
DROP TABLE IF EXISTS "public"."principal_permission_grants" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."principal_permission_grants" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "principal_type" text NOT NULL,
  "principal_id" text NOT NULL,
  "permission_key" text NOT NULL,
  "scope" jsonb,
  "granted_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "principal_permission_grants_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.project_goals
DROP TABLE IF EXISTS "public"."project_goals" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."project_goals" (
  "project_id" uuid NOT NULL,
  "goal_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "project_goals_project_id_goal_id_pk" PRIMARY KEY ("project_id", "goal_id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.project_workspaces
DROP TABLE IF EXISTS "public"."project_workspaces" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."project_workspaces" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid NOT NULL,
  "name" text NOT NULL,
  "cwd" text,
  "repo_url" text,
  "repo_ref" text,
  "metadata" jsonb,
  "is_primary" boolean DEFAULT false NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "source_type" text DEFAULT 'local_path'::text NOT NULL,
  "default_ref" text,
  "visibility" text DEFAULT 'default'::text NOT NULL,
  "setup_command" text,
  "cleanup_command" text,
  "remote_provider" text,
  "remote_workspace_ref" text,
  "shared_workspace_key" text,
  CONSTRAINT "project_workspaces_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.projects
DROP TABLE IF EXISTS "public"."projects" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."projects" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "goal_id" uuid,
  "name" text NOT NULL,
  "description" text,
  "status" text DEFAULT 'backlog'::text NOT NULL,
  "lead_agent_id" uuid,
  "target_date" date,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "color" text,
  "archived_at" timestamp with time zone,
  "execution_workspace_policy" jsonb,
  "pause_reason" text,
  "paused_at" timestamp with time zone,
  CONSTRAINT "projects_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.routine_runs
DROP TABLE IF EXISTS "public"."routine_runs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."routine_runs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "routine_id" uuid NOT NULL,
  "trigger_id" uuid,
  "source" text NOT NULL,
  "status" text DEFAULT 'received'::text NOT NULL,
  "triggered_at" timestamp with time zone DEFAULT now() NOT NULL,
  "idempotency_key" text,
  "trigger_payload" jsonb,
  "linked_issue_id" uuid,
  "coalesced_into_run_id" uuid,
  "failure_reason" text,
  "completed_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "routine_runs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.routine_triggers
DROP TABLE IF EXISTS "public"."routine_triggers" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."routine_triggers" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "routine_id" uuid NOT NULL,
  "kind" text NOT NULL,
  "label" text,
  "enabled" boolean DEFAULT true NOT NULL,
  "cron_expression" text,
  "timezone" text,
  "next_run_at" timestamp with time zone,
  "last_fired_at" timestamp with time zone,
  "public_id" text,
  "secret_id" uuid,
  "signing_mode" text,
  "replay_window_sec" integer,
  "last_rotated_at" timestamp with time zone,
  "last_result" text,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "updated_by_agent_id" uuid,
  "updated_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "routine_triggers_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.routines
DROP TABLE IF EXISTS "public"."routines" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."routines" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid NOT NULL,
  "goal_id" uuid,
  "parent_issue_id" uuid,
  "title" text NOT NULL,
  "description" text,
  "assignee_agent_id" uuid NOT NULL,
  "priority" text DEFAULT 'medium'::text NOT NULL,
  "status" text DEFAULT 'active'::text NOT NULL,
  "concurrency_policy" text DEFAULT 'coalesce_if_active'::text NOT NULL,
  "catch_up_policy" text DEFAULT 'skip_missed'::text NOT NULL,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "updated_by_agent_id" uuid,
  "updated_by_user_id" text,
  "last_triggered_at" timestamp with time zone,
  "last_enqueued_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "variables" jsonb DEFAULT '[]'::jsonb NOT NULL,
  CONSTRAINT "routines_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.session
DROP TABLE IF EXISTS "public"."session" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."session" (
  "id" text NOT NULL,
  "expires_at" timestamp with time zone NOT NULL,
  "token" text NOT NULL,
  "created_at" timestamp with time zone NOT NULL,
  "updated_at" timestamp with time zone NOT NULL,
  "ip_address" text,
  "user_agent" text,
  "user_id" text NOT NULL,
  CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.user
DROP TABLE IF EXISTS "public"."user" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."user" (
  "id" text NOT NULL,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "email_verified" boolean DEFAULT false NOT NULL,
  "image" text,
  "created_at" timestamp with time zone NOT NULL,
  "updated_at" timestamp with time zone NOT NULL,
  CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.verification
DROP TABLE IF EXISTS "public"."verification" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."verification" (
  "id" text NOT NULL,
  "identifier" text NOT NULL,
  "value" text NOT NULL,
  "expires_at" timestamp with time zone NOT NULL,
  "created_at" timestamp with time zone,
  "updated_at" timestamp with time zone,
  CONSTRAINT "verification_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.workspace_operations
DROP TABLE IF EXISTS "public"."workspace_operations" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."workspace_operations" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "execution_workspace_id" uuid,
  "heartbeat_run_id" uuid,
  "phase" text NOT NULL,
  "command" text,
  "cwd" text,
  "status" text DEFAULT 'running'::text NOT NULL,
  "exit_code" integer,
  "log_store" text,
  "log_ref" text,
  "log_bytes" bigint,
  "log_sha256" text,
  "log_compressed" boolean DEFAULT false NOT NULL,
  "stdout_excerpt" text,
  "stderr_excerpt" text,
  "metadata" jsonb,
  "started_at" timestamp with time zone DEFAULT now() NOT NULL,
  "finished_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "workspace_operations_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.workspace_runtime_services
DROP TABLE IF EXISTS "public"."workspace_runtime_services" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."workspace_runtime_services" (
  "id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid,
  "project_workspace_id" uuid,
  "issue_id" uuid,
  "scope_type" text NOT NULL,
  "scope_id" text,
  "service_name" text NOT NULL,
  "status" text NOT NULL,
  "lifecycle" text NOT NULL,
  "reuse_key" text,
  "command" text,
  "cwd" text,
  "port" integer,
  "url" text,
  "provider" text NOT NULL,
  "provider_ref" text,
  "owner_agent_id" uuid,
  "started_by_run_id" uuid,
  "last_used_at" timestamp with time zone DEFAULT now() NOT NULL,
  "started_at" timestamp with time zone DEFAULT now() NOT NULL,
  "stopped_at" timestamp with time zone,
  "stop_policy" jsonb,
  "health_status" text DEFAULT 'unknown'::text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "execution_workspace_id" uuid,
  CONSTRAINT "workspace_runtime_services_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Sequence ownership
ALTER SEQUENCE "public"."heartbeat_run_events_id_seq" OWNED BY "public"."heartbeat_run_events"."id";
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Foreign keys
ALTER TABLE "public"."account" ADD CONSTRAINT "account_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."activity_log" ADD CONSTRAINT "activity_log_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."activity_log" ADD CONSTRAINT "activity_log_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."activity_log" ADD CONSTRAINT "activity_log_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_api_keys" ADD CONSTRAINT "agent_api_keys_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_api_keys" ADD CONSTRAINT "agent_api_keys_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_config_revisions" ADD CONSTRAINT "agent_config_revisions_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_config_revisions" ADD CONSTRAINT "agent_config_revisions_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_config_revisions" ADD CONSTRAINT "agent_config_revisions_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_runtime_state" ADD CONSTRAINT "agent_runtime_state_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_runtime_state" ADD CONSTRAINT "agent_runtime_state_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_task_sessions" ADD CONSTRAINT "agent_task_sessions_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_task_sessions" ADD CONSTRAINT "agent_task_sessions_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_task_sessions" ADD CONSTRAINT "agent_task_sessions_last_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("last_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_wakeup_requests" ADD CONSTRAINT "agent_wakeup_requests_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_wakeup_requests" ADD CONSTRAINT "agent_wakeup_requests_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agents" ADD CONSTRAINT "agents_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agents" ADD CONSTRAINT "agents_reports_to_agents_id_fk" FOREIGN KEY ("reports_to") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approval_comments" ADD CONSTRAINT "approval_comments_approval_id_approvals_id_fk" FOREIGN KEY ("approval_id") REFERENCES "public"."approvals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approval_comments" ADD CONSTRAINT "approval_comments_author_agent_id_agents_id_fk" FOREIGN KEY ("author_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approval_comments" ADD CONSTRAINT "approval_comments_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approvals" ADD CONSTRAINT "approvals_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approvals" ADD CONSTRAINT "approvals_requested_by_agent_id_agents_id_fk" FOREIGN KEY ("requested_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."board_api_keys" ADD CONSTRAINT "board_api_keys_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."budget_incidents" ADD CONSTRAINT "budget_incidents_approval_id_approvals_id_fk" FOREIGN KEY ("approval_id") REFERENCES "public"."approvals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."budget_incidents" ADD CONSTRAINT "budget_incidents_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."budget_incidents" ADD CONSTRAINT "budget_incidents_policy_id_budget_policies_id_fk" FOREIGN KEY ("policy_id") REFERENCES "public"."budget_policies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."budget_policies" ADD CONSTRAINT "budget_policies_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cli_auth_challenges" ADD CONSTRAINT "cli_auth_challenges_approved_by_user_id_user_id_fk" FOREIGN KEY ("approved_by_user_id") REFERENCES "public"."user" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cli_auth_challenges" ADD CONSTRAINT "cli_auth_challenges_board_api_key_id_board_api_keys_id_fk" FOREIGN KEY ("board_api_key_id") REFERENCES "public"."board_api_keys" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cli_auth_challenges" ADD CONSTRAINT "cli_auth_challenges_requested_company_id_companies_id_fk" FOREIGN KEY ("requested_company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_logos" ADD CONSTRAINT "company_logos_asset_id_assets_id_fk" FOREIGN KEY ("asset_id") REFERENCES "public"."assets" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_logos" ADD CONSTRAINT "company_logos_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_memberships" ADD CONSTRAINT "company_memberships_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_secret_versions" ADD CONSTRAINT "company_secret_versions_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_secret_versions" ADD CONSTRAINT "company_secret_versions_secret_id_company_secrets_id_fk" FOREIGN KEY ("secret_id") REFERENCES "public"."company_secrets" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_secrets" ADD CONSTRAINT "company_secrets_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_secrets" ADD CONSTRAINT "company_secrets_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_skills" ADD CONSTRAINT "company_skills_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_heartbeat_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("heartbeat_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."document_revisions" ADD CONSTRAINT "document_revisions_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."document_revisions" ADD CONSTRAINT "document_revisions_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."document_revisions" ADD CONSTRAINT "document_revisions_created_by_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("created_by_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."document_revisions" ADD CONSTRAINT "document_revisions_document_id_documents_id_fk" FOREIGN KEY ("document_id") REFERENCES "public"."documents" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."documents" ADD CONSTRAINT "documents_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."documents" ADD CONSTRAINT "documents_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."documents" ADD CONSTRAINT "documents_updated_by_agent_id_agents_id_fk" FOREIGN KEY ("updated_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_derived_from_execution_workspace_id_execut" FOREIGN KEY ("derived_from_execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_project_workspace_id_project_workspaces_id" FOREIGN KEY ("project_workspace_id") REFERENCES "public"."project_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_source_issue_id_issues_id_fk" FOREIGN KEY ("source_issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_exports" ADD CONSTRAINT "feedback_exports_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_exports" ADD CONSTRAINT "feedback_exports_feedback_vote_id_feedback_votes_id_fk" FOREIGN KEY ("feedback_vote_id") REFERENCES "public"."feedback_votes" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_exports" ADD CONSTRAINT "feedback_exports_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_exports" ADD CONSTRAINT "feedback_exports_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_votes" ADD CONSTRAINT "feedback_votes_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_votes" ADD CONSTRAINT "feedback_votes_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_cost_event_id_cost_events_id_fk" FOREIGN KEY ("cost_event_id") REFERENCES "public"."cost_events" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_heartbeat_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("heartbeat_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."goals" ADD CONSTRAINT "goals_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."goals" ADD CONSTRAINT "goals_owner_agent_id_agents_id_fk" FOREIGN KEY ("owner_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."goals" ADD CONSTRAINT "goals_parent_id_goals_id_fk" FOREIGN KEY ("parent_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_run_events" ADD CONSTRAINT "heartbeat_run_events_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_run_events" ADD CONSTRAINT "heartbeat_run_events_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_run_events" ADD CONSTRAINT "heartbeat_run_events_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_runs" ADD CONSTRAINT "heartbeat_runs_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_runs" ADD CONSTRAINT "heartbeat_runs_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_runs" ADD CONSTRAINT "heartbeat_runs_retry_of_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("retry_of_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_runs" ADD CONSTRAINT "heartbeat_runs_wakeup_request_id_agent_wakeup_requests_id_fk" FOREIGN KEY ("wakeup_request_id") REFERENCES "public"."agent_wakeup_requests" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."invites" ADD CONSTRAINT "invites_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_approvals" ADD CONSTRAINT "issue_approvals_approval_id_approvals_id_fk" FOREIGN KEY ("approval_id") REFERENCES "public"."approvals" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_approvals" ADD CONSTRAINT "issue_approvals_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_approvals" ADD CONSTRAINT "issue_approvals_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_approvals" ADD CONSTRAINT "issue_approvals_linked_by_agent_id_agents_id_fk" FOREIGN KEY ("linked_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_attachments" ADD CONSTRAINT "issue_attachments_asset_id_assets_id_fk" FOREIGN KEY ("asset_id") REFERENCES "public"."assets" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_attachments" ADD CONSTRAINT "issue_attachments_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_attachments" ADD CONSTRAINT "issue_attachments_issue_comment_id_issue_comments_id_fk" FOREIGN KEY ("issue_comment_id") REFERENCES "public"."issue_comments" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_attachments" ADD CONSTRAINT "issue_attachments_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_comments" ADD CONSTRAINT "issue_comments_author_agent_id_agents_id_fk" FOREIGN KEY ("author_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_comments" ADD CONSTRAINT "issue_comments_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_comments" ADD CONSTRAINT "issue_comments_created_by_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("created_by_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_comments" ADD CONSTRAINT "issue_comments_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_documents" ADD CONSTRAINT "issue_documents_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_documents" ADD CONSTRAINT "issue_documents_document_id_documents_id_fk" FOREIGN KEY ("document_id") REFERENCES "public"."documents" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_documents" ADD CONSTRAINT "issue_documents_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_inbox_archives" ADD CONSTRAINT "issue_inbox_archives_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_inbox_archives" ADD CONSTRAINT "issue_inbox_archives_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_labels" ADD CONSTRAINT "issue_labels_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_labels" ADD CONSTRAINT "issue_labels_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_labels" ADD CONSTRAINT "issue_labels_label_id_labels_id_fk" FOREIGN KEY ("label_id") REFERENCES "public"."labels" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_read_states" ADD CONSTRAINT "issue_read_states_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_read_states" ADD CONSTRAINT "issue_read_states_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_created_by_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("created_by_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_execution_workspace_id_execution_workspaces" FOREIGN KEY ("execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_runtime_service_id_workspace_runtime_servic" FOREIGN KEY ("runtime_service_id") REFERENCES "public"."workspace_runtime_services" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_assignee_agent_id_agents_id_fk" FOREIGN KEY ("assignee_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_checkout_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("checkout_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_execution_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("execution_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_execution_workspace_id_execution_workspaces_id_fk" FOREIGN KEY ("execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_parent_id_issues_id_fk" FOREIGN KEY ("parent_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_project_workspace_id_project_workspaces_id_fk" FOREIGN KEY ("project_workspace_id") REFERENCES "public"."project_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."join_requests" ADD CONSTRAINT "join_requests_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."join_requests" ADD CONSTRAINT "join_requests_created_agent_id_agents_id_fk" FOREIGN KEY ("created_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."join_requests" ADD CONSTRAINT "join_requests_invite_id_invites_id_fk" FOREIGN KEY ("invite_id") REFERENCES "public"."invites" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."labels" ADD CONSTRAINT "labels_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_company_settings" ADD CONSTRAINT "plugin_company_settings_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_company_settings" ADD CONSTRAINT "plugin_company_settings_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_config" ADD CONSTRAINT "plugin_config_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_entities" ADD CONSTRAINT "plugin_entities_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_job_runs" ADD CONSTRAINT "plugin_job_runs_job_id_plugin_jobs_id_fk" FOREIGN KEY ("job_id") REFERENCES "public"."plugin_jobs" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_job_runs" ADD CONSTRAINT "plugin_job_runs_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_jobs" ADD CONSTRAINT "plugin_jobs_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_logs" ADD CONSTRAINT "plugin_logs_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_state" ADD CONSTRAINT "plugin_state_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_webhook_deliveries" ADD CONSTRAINT "plugin_webhook_deliveries_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."principal_permission_grants" ADD CONSTRAINT "principal_permission_grants_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_goals" ADD CONSTRAINT "project_goals_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_goals" ADD CONSTRAINT "project_goals_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_goals" ADD CONSTRAINT "project_goals_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_workspaces" ADD CONSTRAINT "project_workspaces_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_workspaces" ADD CONSTRAINT "project_workspaces_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."projects" ADD CONSTRAINT "projects_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."projects" ADD CONSTRAINT "projects_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."projects" ADD CONSTRAINT "projects_lead_agent_id_agents_id_fk" FOREIGN KEY ("lead_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_runs" ADD CONSTRAINT "routine_runs_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_runs" ADD CONSTRAINT "routine_runs_linked_issue_id_issues_id_fk" FOREIGN KEY ("linked_issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_runs" ADD CONSTRAINT "routine_runs_routine_id_routines_id_fk" FOREIGN KEY ("routine_id") REFERENCES "public"."routines" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_runs" ADD CONSTRAINT "routine_runs_trigger_id_routine_triggers_id_fk" FOREIGN KEY ("trigger_id") REFERENCES "public"."routine_triggers" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_routine_id_routines_id_fk" FOREIGN KEY ("routine_id") REFERENCES "public"."routines" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_secret_id_company_secrets_id_fk" FOREIGN KEY ("secret_id") REFERENCES "public"."company_secrets" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_updated_by_agent_id_agents_id_fk" FOREIGN KEY ("updated_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_assignee_agent_id_agents_id_fk" FOREIGN KEY ("assignee_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_parent_issue_id_issues_id_fk" FOREIGN KEY ("parent_issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_updated_by_agent_id_agents_id_fk" FOREIGN KEY ("updated_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."session" ADD CONSTRAINT "session_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_operations" ADD CONSTRAINT "workspace_operations_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_operations" ADD CONSTRAINT "workspace_operations_execution_workspace_id_execution_workspace" FOREIGN KEY ("execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_operations" ADD CONSTRAINT "workspace_operations_heartbeat_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("heartbeat_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_execution_workspace_id_execution_wor" FOREIGN KEY ("execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_owner_agent_id_agents_id_fk" FOREIGN KEY ("owner_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_project_workspace_id_project_workspa" FOREIGN KEY ("project_workspace_id") REFERENCES "public"."project_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_started_by_run_id_heartbeat_runs_id_" FOREIGN KEY ("started_by_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Unique constraints
ALTER TABLE "public"."plugin_state" ADD CONSTRAINT "plugin_state_unique_entry_idx" UNIQUE ("plugin_id", "scope_kind", "scope_id", "namespace", "state_key");
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Indexes
CREATE INDEX activity_log_company_created_idx ON public.activity_log USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX activity_log_entity_type_id_idx ON public.activity_log USING btree (entity_type, entity_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX activity_log_run_id_idx ON public.activity_log USING btree (run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_api_keys_company_agent_idx ON public.agent_api_keys USING btree (company_id, agent_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_api_keys_key_hash_idx ON public.agent_api_keys USING btree (key_hash);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_config_revisions_agent_created_idx ON public.agent_config_revisions USING btree (agent_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_config_revisions_company_agent_created_idx ON public.agent_config_revisions USING btree (company_id, agent_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_runtime_state_company_agent_idx ON public.agent_runtime_state USING btree (company_id, agent_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_runtime_state_company_updated_idx ON public.agent_runtime_state USING btree (company_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX agent_task_sessions_company_agent_adapter_task_uniq ON public.agent_task_sessions USING btree (company_id, agent_id, adapter_type, task_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_task_sessions_company_agent_updated_idx ON public.agent_task_sessions USING btree (company_id, agent_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_task_sessions_company_task_updated_idx ON public.agent_task_sessions USING btree (company_id, task_key, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_wakeup_requests_agent_requested_idx ON public.agent_wakeup_requests USING btree (agent_id, requested_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_wakeup_requests_company_agent_status_idx ON public.agent_wakeup_requests USING btree (company_id, agent_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_wakeup_requests_company_requested_idx ON public.agent_wakeup_requests USING btree (company_id, requested_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agents_company_reports_to_idx ON public.agents USING btree (company_id, reports_to);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agents_company_status_idx ON public.agents USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX approval_comments_approval_created_idx ON public.approval_comments USING btree (approval_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX approval_comments_approval_idx ON public.approval_comments USING btree (approval_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX approval_comments_company_idx ON public.approval_comments USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX approvals_company_status_type_idx ON public.approvals USING btree (company_id, status, type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX assets_company_created_idx ON public.assets USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX assets_company_object_key_uq ON public.assets USING btree (company_id, object_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX assets_company_provider_idx ON public.assets USING btree (company_id, provider);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX board_api_keys_key_hash_idx ON public.board_api_keys USING btree (key_hash);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX board_api_keys_user_idx ON public.board_api_keys USING btree (user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX budget_incidents_company_scope_idx ON public.budget_incidents USING btree (company_id, scope_type, scope_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX budget_incidents_company_status_idx ON public.budget_incidents USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX budget_incidents_policy_window_threshold_idx ON public.budget_incidents USING btree (policy_id, window_start, threshold_type) WHERE (status <> 'dismissed'::text);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX budget_policies_company_scope_active_idx ON public.budget_policies USING btree (company_id, scope_type, scope_id, is_active);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX budget_policies_company_scope_metric_unique_idx ON public.budget_policies USING btree (company_id, scope_type, scope_id, metric, window_kind);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX budget_policies_company_window_idx ON public.budget_policies USING btree (company_id, window_kind, metric);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cli_auth_challenges_approved_by_idx ON public.cli_auth_challenges USING btree (approved_by_user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cli_auth_challenges_requested_company_idx ON public.cli_auth_challenges USING btree (requested_company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cli_auth_challenges_secret_hash_idx ON public.cli_auth_challenges USING btree (secret_hash);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX companies_issue_prefix_idx ON public.companies USING btree (issue_prefix);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_logos_asset_uq ON public.company_logos USING btree (asset_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_logos_company_uq ON public.company_logos USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_memberships_company_principal_unique_idx ON public.company_memberships USING btree (company_id, principal_type, principal_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_memberships_company_status_idx ON public.company_memberships USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_memberships_principal_status_idx ON public.company_memberships USING btree (principal_type, principal_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_secret_versions_secret_idx ON public.company_secret_versions USING btree (secret_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_secret_versions_secret_version_uq ON public.company_secret_versions USING btree (secret_id, version);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_secret_versions_value_sha256_idx ON public.company_secret_versions USING btree (value_sha256);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_secrets_company_idx ON public.company_secrets USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_secrets_company_name_uq ON public.company_secrets USING btree (company_id, name);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_secrets_company_provider_idx ON public.company_secrets USING btree (company_id, provider);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_skills_company_key_idx ON public.company_skills USING btree (company_id, key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_skills_company_name_idx ON public.company_skills USING btree (company_id, name);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_agent_occurred_idx ON public.cost_events USING btree (company_id, agent_id, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_biller_occurred_idx ON public.cost_events USING btree (company_id, biller, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_heartbeat_run_idx ON public.cost_events USING btree (company_id, heartbeat_run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_occurred_idx ON public.cost_events USING btree (company_id, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_provider_occurred_idx ON public.cost_events USING btree (company_id, provider, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX document_revisions_company_document_created_idx ON public.document_revisions USING btree (company_id, document_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX document_revisions_document_revision_uq ON public.document_revisions USING btree (document_id, revision_number);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX documents_company_created_idx ON public.documents USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX documents_company_updated_idx ON public.documents USING btree (company_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_branch_idx ON public.execution_workspaces USING btree (company_id, branch_name);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_last_used_idx ON public.execution_workspaces USING btree (company_id, last_used_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_project_status_idx ON public.execution_workspaces USING btree (company_id, project_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_project_workspace_status_idx ON public.execution_workspaces USING btree (company_id, project_workspace_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_source_issue_idx ON public.execution_workspaces USING btree (company_id, source_issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_author_idx ON public.feedback_exports USING btree (company_id, author_user_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_created_idx ON public.feedback_exports USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_issue_idx ON public.feedback_exports USING btree (company_id, issue_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_project_idx ON public.feedback_exports USING btree (company_id, project_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_status_idx ON public.feedback_exports USING btree (company_id, status, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX feedback_exports_feedback_vote_idx ON public.feedback_exports USING btree (feedback_vote_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_votes_author_idx ON public.feedback_votes USING btree (author_user_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_votes_company_issue_idx ON public.feedback_votes USING btree (company_id, issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX feedback_votes_company_target_author_idx ON public.feedback_votes USING btree (company_id, target_type, target_id, author_user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_votes_issue_target_idx ON public.feedback_votes USING btree (issue_id, target_type, target_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_biller_occurred_idx ON public.finance_events USING btree (company_id, biller, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_cost_event_idx ON public.finance_events USING btree (company_id, cost_event_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_direction_occurred_idx ON public.finance_events USING btree (company_id, direction, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_heartbeat_run_idx ON public.finance_events USING btree (company_id, heartbeat_run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_kind_occurred_idx ON public.finance_events USING btree (company_id, event_kind, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_occurred_idx ON public.finance_events USING btree (company_id, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX goals_company_idx ON public.goals USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX heartbeat_run_events_company_created_idx ON public.heartbeat_run_events USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX heartbeat_run_events_company_run_idx ON public.heartbeat_run_events USING btree (company_id, run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX heartbeat_run_events_run_seq_idx ON public.heartbeat_run_events USING btree (run_id, seq);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX heartbeat_runs_company_agent_started_idx ON public.heartbeat_runs USING btree (company_id, agent_id, started_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX instance_settings_singleton_key_idx ON public.instance_settings USING btree (singleton_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX instance_user_roles_role_idx ON public.instance_user_roles USING btree (role);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX instance_user_roles_user_role_unique_idx ON public.instance_user_roles USING btree (user_id, role);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX invites_company_invite_state_idx ON public.invites USING btree (company_id, invite_type, revoked_at, expires_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX invites_token_hash_unique_idx ON public.invites USING btree (token_hash);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_approvals_approval_idx ON public.issue_approvals USING btree (approval_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_approvals_company_idx ON public.issue_approvals USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_approvals_issue_idx ON public.issue_approvals USING btree (issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_attachments_asset_uq ON public.issue_attachments USING btree (asset_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_attachments_company_issue_idx ON public.issue_attachments USING btree (company_id, issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_attachments_issue_comment_idx ON public.issue_attachments USING btree (issue_comment_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_comments_company_author_issue_created_at_idx ON public.issue_comments USING btree (company_id, author_user_id, issue_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_comments_company_idx ON public.issue_comments USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_comments_company_issue_created_at_idx ON public.issue_comments USING btree (company_id, issue_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_comments_issue_idx ON public.issue_comments USING btree (issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_documents_company_issue_key_uq ON public.issue_documents USING btree (company_id, issue_id, key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_documents_company_issue_updated_idx ON public.issue_documents USING btree (company_id, issue_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_documents_document_uq ON public.issue_documents USING btree (document_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_inbox_archives_company_issue_idx ON public.issue_inbox_archives USING btree (company_id, issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_inbox_archives_company_issue_user_idx ON public.issue_inbox_archives USING btree (company_id, issue_id, user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_inbox_archives_company_user_idx ON public.issue_inbox_archives USING btree (company_id, user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_labels_company_idx ON public.issue_labels USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_labels_issue_idx ON public.issue_labels USING btree (issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_labels_label_idx ON public.issue_labels USING btree (label_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_read_states_company_issue_idx ON public.issue_read_states USING btree (company_id, issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_read_states_company_issue_user_idx ON public.issue_read_states USING btree (company_id, issue_id, user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_read_states_company_user_idx ON public.issue_read_states USING btree (company_id, user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_work_products_company_execution_workspace_type_idx ON public.issue_work_products USING btree (company_id, execution_workspace_id, type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_work_products_company_issue_type_idx ON public.issue_work_products USING btree (company_id, issue_id, type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_work_products_company_provider_external_id_idx ON public.issue_work_products USING btree (company_id, provider, external_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_work_products_company_updated_idx ON public.issue_work_products USING btree (company_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_assignee_status_idx ON public.issues USING btree (company_id, assignee_agent_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_assignee_user_status_idx ON public.issues USING btree (company_id, assignee_user_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_execution_workspace_idx ON public.issues USING btree (company_id, execution_workspace_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_origin_idx ON public.issues USING btree (company_id, origin_kind, origin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_parent_idx ON public.issues USING btree (company_id, parent_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_project_idx ON public.issues USING btree (company_id, project_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_project_workspace_idx ON public.issues USING btree (company_id, project_workspace_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_status_idx ON public.issues USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issues_identifier_idx ON public.issues USING btree (identifier);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issues_open_routine_execution_uq ON public.issues USING btree (company_id, origin_kind, origin_id) WHERE ((origin_kind = 'routine_execution'::text) AND (origin_id IS NOT NULL) AND (hidden_at IS NULL) AND (execution_run_id IS NOT NULL) AND (status = ANY (ARRAY['backlog'::text, 'todo'::text, 'in_progress'::text, 'in_review'::text, 'blocked'::text])));
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX join_requests_company_status_type_created_idx ON public.join_requests USING btree (company_id, status, request_type, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX join_requests_invite_unique_idx ON public.join_requests USING btree (invite_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX labels_company_idx ON public.labels USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX labels_company_name_idx ON public.labels USING btree (company_id, name);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_company_settings_company_idx ON public.plugin_company_settings USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugin_company_settings_company_plugin_uq ON public.plugin_company_settings USING btree (company_id, plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_company_settings_plugin_idx ON public.plugin_company_settings USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugin_config_plugin_id_idx ON public.plugin_config USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugin_entities_external_idx ON public.plugin_entities USING btree (plugin_id, entity_type, external_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_entities_plugin_idx ON public.plugin_entities USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_entities_scope_idx ON public.plugin_entities USING btree (scope_kind, scope_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_entities_type_idx ON public.plugin_entities USING btree (entity_type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_job_runs_job_idx ON public.plugin_job_runs USING btree (job_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_job_runs_plugin_idx ON public.plugin_job_runs USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_job_runs_status_idx ON public.plugin_job_runs USING btree (status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_jobs_next_run_idx ON public.plugin_jobs USING btree (next_run_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_jobs_plugin_idx ON public.plugin_jobs USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugin_jobs_unique_idx ON public.plugin_jobs USING btree (plugin_id, job_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_logs_level_idx ON public.plugin_logs USING btree (level);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_logs_plugin_time_idx ON public.plugin_logs USING btree (plugin_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_state_plugin_scope_idx ON public.plugin_state USING btree (plugin_id, scope_kind);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_webhook_deliveries_key_idx ON public.plugin_webhook_deliveries USING btree (webhook_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_webhook_deliveries_plugin_idx ON public.plugin_webhook_deliveries USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_webhook_deliveries_status_idx ON public.plugin_webhook_deliveries USING btree (status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugins_plugin_key_idx ON public.plugins USING btree (plugin_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugins_status_idx ON public.plugins USING btree (status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX principal_permission_grants_company_permission_idx ON public.principal_permission_grants USING btree (company_id, permission_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX principal_permission_grants_unique_idx ON public.principal_permission_grants USING btree (company_id, principal_type, principal_id, permission_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_goals_company_idx ON public.project_goals USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_goals_goal_idx ON public.project_goals USING btree (goal_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_goals_project_idx ON public.project_goals USING btree (project_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_workspaces_company_project_idx ON public.project_workspaces USING btree (company_id, project_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_workspaces_company_shared_key_idx ON public.project_workspaces USING btree (company_id, shared_workspace_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_workspaces_project_primary_idx ON public.project_workspaces USING btree (project_id, is_primary);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX project_workspaces_project_remote_ref_idx ON public.project_workspaces USING btree (project_id, remote_provider, remote_workspace_ref);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_workspaces_project_source_type_idx ON public.project_workspaces USING btree (project_id, source_type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX projects_company_idx ON public.projects USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_runs_company_routine_idx ON public.routine_runs USING btree (company_id, routine_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_runs_linked_issue_idx ON public.routine_runs USING btree (linked_issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_runs_trigger_idempotency_idx ON public.routine_runs USING btree (trigger_id, idempotency_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_runs_trigger_idx ON public.routine_runs USING btree (trigger_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_triggers_company_kind_idx ON public.routine_triggers USING btree (company_id, kind);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_triggers_company_routine_idx ON public.routine_triggers USING btree (company_id, routine_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_triggers_next_run_idx ON public.routine_triggers USING btree (next_run_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_triggers_public_id_idx ON public.routine_triggers USING btree (public_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX routine_triggers_public_id_uq ON public.routine_triggers USING btree (public_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routines_company_assignee_idx ON public.routines USING btree (company_id, assignee_agent_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routines_company_project_idx ON public.routines USING btree (company_id, project_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routines_company_status_idx ON public.routines USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_operations_company_run_started_idx ON public.workspace_operations USING btree (company_id, heartbeat_run_id, started_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_operations_company_workspace_started_idx ON public.workspace_operations USING btree (company_id, execution_workspace_id, started_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_company_execution_workspace_status_i ON public.workspace_runtime_services USING btree (company_id, execution_workspace_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_company_project_status_idx ON public.workspace_runtime_services USING btree (company_id, project_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_company_updated_idx ON public.workspace_runtime_services USING btree (company_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_company_workspace_status_idx ON public.workspace_runtime_services USING btree (company_id, project_workspace_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_run_idx ON public.workspace_runtime_services USING btree (started_by_run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.activity_log (106 rows)
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$db82fc93-bfcc-42c1-83e7-1d43a9c6f9d5$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$company.created$paperclip$, $paperclip$company$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, NULL, $paperclip${"name":"AEGIS"}$paperclip$, $paperclip$2026-04-03T07:05:53.842Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$546f24cf-915b-4a35-8489-7d382c600681$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$company.created$paperclip$, $paperclip$company$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, NULL, $paperclip${"name":"AEGIS"}$paperclip$, $paperclip$2026-04-03T07:05:53.908Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$d5b57c7e-d84e-4a62-8dc7-31dd4f8cd56d$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$goal.created$paperclip$, $paperclip$goal$paperclip$, $paperclip$f37b9d3a-60c7-431a-a03d-b9eda150e5ae$paperclip$, NULL, $paperclip${"title":"Production-grade autonomous software delivery via 13 AI agents. 14-Stage SDLC Pipeline (IDEA → SPEC → BUILD → REVIEW → QA → COMPLY → DEPLOY → MONITOR) with 5-Gate Quality System and ISO 29110 Compliance. \"Context is King, Memory is Soul.\" Model routing: Opus thinks, Sonnet builds, Haiku gathers."}$paperclip$, $paperclip$2026-04-03T07:05:53.920Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$35e50e5e-6e17-46f9-a35d-5945cc7846aa$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$goal.created$paperclip$, $paperclip$goal$paperclip$, $paperclip$d7745ec8-1cec-4a57-a260-b810aaeaaec9$paperclip$, NULL, $paperclip${"title":"Deliver production-grade software autonomously"}$paperclip$, $paperclip$2026-04-03T07:06:09.693Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$914b5365-7865-459f-9fe6-5218ca17c571$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$goal.created$paperclip$, $paperclip$goal$paperclip$, $paperclip$7f94b7a6-1400-4bb8-8dbf-3761aa171461$paperclip$, NULL, $paperclip${"title":"Architecture & Specification Quality"}$paperclip$, $paperclip$2026-04-03T07:06:09.747Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$64ecda99-0dda-4071-a824-3ff7a87de1e3$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$goal.created$paperclip$, $paperclip$goal$paperclip$, $paperclip$4ddcd07b-d8c9-4b10-be66-fa9a06a585ce$paperclip$, NULL, $paperclip${"title":"Code Quality & Security"}$paperclip$, $paperclip$2026-04-03T07:06:09.784Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$b8a40b0d-d8d3-449b-9db2-674278932728$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$goal.created$paperclip$, $paperclip$goal$paperclip$, $paperclip$3244e301-acf7-4c11-8517-2befc568e7b5$paperclip$, NULL, $paperclip${"title":"ISO 29110 Compliance"}$paperclip$, $paperclip$2026-04-03T07:06:09.816Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$2481ac97-150d-4820-9736-17e266597735$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$goal.created$paperclip$, $paperclip$goal$paperclip$, $paperclip$768df2fa-cd17-40f3-a516-28e6c409ced4$paperclip$, NULL, $paperclip${"title":"Continuous Deployment & Monitoring"}$paperclip$, $paperclip$2026-04-03T07:06:09.846Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$9f90540c-79a0-4d0c-870a-e0e49e0a3a4c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$32eb19c3-4746-4313-b75a-c136b3e53061$paperclip$, NULL, $paperclip${"name":"Mother Brain","role":"ceo","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:42.997Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$a19b9abf-2685-45fe-86ea-04b8a9181170$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$fda1ef69-54d5-49c4-b4e1-d58ccb2c40b8$paperclip$, NULL, $paperclip${"amount":15000,"scopeId":"32eb19c3-4746-4313-b75a-c136b3e53061","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.015Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$58eff140-3522-4eb7-bc22-92b738eb5f6d$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, NULL, $paperclip${"name":"Navi","role":"pm","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.081Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$7f29dd8a-f079-4cc9-b17e-6567e15d9f9f$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$dd179edb-94dd-4acd-a7ea-3d50c588fb62$paperclip$, NULL, $paperclip${"amount":5000,"scopeId":"b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.087Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$eabf9ccd-e887-44e8-8096-9d746e0a3052$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, NULL, $paperclip${"name":"Sage","role":"cto","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.124Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$db549bbe-1d0e-4bba-9a8e-bb0956242a36$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$73a51382-1256-4817-91b9-c57ee8a03b0f$paperclip$, NULL, $paperclip${"amount":5000,"scopeId":"fb9504df-4a79-403a-8c73-efd73abf869c","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.129Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$cbe05e2b-abf8-4279-9528-30863d36f62f$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$34810f8a-b6f9-452e-884c-428b3fb0dbc9$paperclip$, NULL, $paperclip${"name":"Bolt","role":"engineer","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.170Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$ca1cd457-495a-4f61-9fde-30606e8f993c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$98da19de-4408-455b-8d6c-9bd9d404098e$paperclip$, NULL, $paperclip${"amount":5000,"scopeId":"34810f8a-b6f9-452e-884c-428b3fb0dbc9","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.175Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$6502a8ba-719c-4dc4-9e54-97cb2d0aa038$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$efb1cef7-7aa4-42ab-97bc-05d9b453486b$paperclip$, NULL, $paperclip${"name":"Vigil","role":"qa","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.212Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$1b7abdeb-d34c-41ef-9236-06384fdeec6d$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$c6e82478-1d51-4945-be72-bb3c01e70074$paperclip$, NULL, $paperclip${"amount":3000,"scopeId":"efb1cef7-7aa4-42ab-97bc-05d9b453486b","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.216Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$0b81bb84-1b2c-4781-852b-a7edf49b43bd$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$634372bd-2e09-4ff7-bbd8-6edbee0db841$paperclip$, NULL, $paperclip${"name":"Havoc","role":"researcher","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.258Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$1ef40f34-740d-4780-80fc-c1e9fa2d2c27$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$50c4ad19-5ec6-4447-8293-8add5a70afa7$paperclip$, NULL, $paperclip${"amount":3000,"scopeId":"634372bd-2e09-4ff7-bbd8-6edbee0db841","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.262Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$86221e28-76a8-4da1-903a-e8fd5121f9c5$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$2e52a6a5-ee41-4fc4-9017-e848cf543932$paperclip$, NULL, $paperclip${"name":"Forge","role":"researcher","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.297Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4ce2134e-f8d0-43af-9632-fb0b8a9ae466$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$b7a5c677-cb3c-40c6-900e-ee58f0cd9ca6$paperclip$, NULL, $paperclip${"amount":1000,"scopeId":"2e52a6a5-ee41-4fc4-9017-e848cf543932","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.301Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$f7448c98-6888-4e4f-9d29-d95434e76f20$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$06e05816-7d38-4c2a-a387-0a5661de648b$paperclip$, NULL, $paperclip${"name":"Pixel","role":"designer","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.337Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$660709b3-5a63-4664-aaac-35d2edfb8c16$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$1f8b17be-44f3-4d9e-a66a-44ad3fd62a4f$paperclip$, NULL, $paperclip${"amount":2000,"scopeId":"06e05816-7d38-4c2a-a387-0a5661de648b","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.341Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$c9ecdcf5-42a2-43b4-a58a-593e394711a2$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$c629de00-1589-408c-b400-be83dfa48253$paperclip$, NULL, $paperclip${"name":"Muse","role":"general","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.378Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$7fdd774c-c36b-48d6-bba9-af4613510f06$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$1072c596-872f-440c-9a13-f4f6d98b2557$paperclip$, NULL, $paperclip${"amount":1000,"scopeId":"c629de00-1589-408c-b400-be83dfa48253","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.382Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$dc843751-27c8-4701-a7d7-2d43ef0f7832$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$50a29397-83bc-4fae-976b-ea22d69d6a3a$paperclip$, NULL, $paperclip${"name":"Sentinel","role":"qa","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.415Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4d4e8871-38ad-42f7-8fb4-500c3cf55f1e$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$c4d11956-e49a-445d-86a7-b06e003c93ad$paperclip$, NULL, $paperclip${"amount":2000,"scopeId":"50a29397-83bc-4fae-976b-ea22d69d6a3a","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.419Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$34427384-d8a1-4973-86a9-2f2be6eb73b6$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$a412beec-95ba-44dd-bdd1-dcb608629065$paperclip$, NULL, $paperclip${"name":"Probe","role":"qa","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.451Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$8a1ca7cd-397d-40f3-a474-c18d77a1adc5$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$c07b1142-037a-4046-9b51-dfa347a1eb9c$paperclip$, NULL, $paperclip${"amount":1000,"scopeId":"a412beec-95ba-44dd-bdd1-dcb608629065","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.454Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$0d0120b1-e2d5-42ca-85ea-1326f1715b22$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$a3dd8cc4-cf7b-486f-be25-dce12648d8eb$paperclip$, NULL, $paperclip${"name":"Scribe","role":"general","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.492Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$66d49d70-513d-4a3a-a692-befafb630518$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$d2eda4d4-42d6-4e8e-ba35-ac0a613f6855$paperclip$, NULL, $paperclip${"amount":1000,"scopeId":"a3dd8cc4-cf7b-486f-be25-dce12648d8eb","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.497Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4667046a-4ae2-4234-9535-8c31aba01aa4$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$d99e4fff-2aa7-45e6-95d6-110bfd77d01d$paperclip$, NULL, $paperclip${"name":"Ops","role":"devops","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:43.536Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$c2f4268b-d948-45b9-bab1-317176c8b765$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip${"name":"Mother Brain","role":"ceo","desiredSkills":null}$paperclip$, $paperclip$2026-04-03T07:08:44.057Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$22fff586-6157-4cb1-8caa-19a1e0b97bb4$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$aa16b27c-7ac5-4840-ada3-c2b80ffe00e8$paperclip$, NULL, $paperclip${"title":"[COMPLY] Gate 3 - ISO 29110 compliance check","identifier":"AEG-5"}$paperclip$, $paperclip$2026-04-03T07:09:13.882Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$5c6b225b-6657-404c-8772-1d51b3e3c1b1$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.key_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, NULL, $paperclip${"name":"local-cli","keyId":"c3c2e899-f1ef-4382-bd84-f7b3e05000cd"}$paperclip$, $paperclip$2026-04-03T07:10:49.039Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$7e12e125-4c58-4a4d-89fb-9c40a1fc6fd0$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$6f9531ce-df76-4b3b-bbc0-7e681412ceb7$paperclip$, NULL, $paperclip${"amount":2000,"scopeId":"d99e4fff-2aa7-45e6-95d6-110bfd77d01d","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-03T07:08:43.542Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$3d8e28bf-48ad-421e-b772-6b1c28327933$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$project.created$paperclip$, $paperclip$project$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, NULL, $paperclip${"name":"AEGIS Sprint Workspace","workspaceId":null}$paperclip$, $paperclip$2026-04-03T07:09:13.659Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$90ebd3fe-8a83-4549-803d-ffdc89b585b5$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$270b74c3-64ed-42da-aa3c-62285281725d$paperclip$, NULL, $paperclip${"title":"[DEPLOY] Gate 4-5 - Deploy and monitor","identifier":"AEG-6"}$paperclip$, $paperclip$2026-04-03T07:09:13.925Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$0cbd605d-a54e-4a12-b49c-f80a3140b2ab$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.key_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, NULL, $paperclip${"name":"local-cli","keyId":"5908c86d-7f44-463a-95b2-231504c8050c"}$paperclip$, $paperclip$2026-04-03T07:10:54.748Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$3fa4d1a2-7ee9-4cd4-a147-aa1aaafbd11b$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, NULL, $paperclip${"title":"Activate AEGIS: Scan project state, hire remaining agents, and begin Sprint 1","identifier":"AEGA-1"}$paperclip$, $paperclip$2026-04-03T07:11:04.182Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$e030b03b-3f31-442d-8067-06b0096e9153$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:11:04.508Z"}$paperclip$, $paperclip$2026-04-03T07:11:04.512Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4343b4d3-30bc-4e22-9eba-f8be9fd0c2ac$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"title":"[SPEC] Create BRD + SRS specification template","identifier":"AEG-1"}$paperclip$, $paperclip$2026-04-03T07:09:13.727Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$d4ef66a8-0b5c-40c4-a978-e6098bca382b$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$4509a2a8-afab-4f59-8d29-ae9a245eb295$paperclip$, NULL, $paperclip${"title":"[BUILD] Implement feature from approved spec","identifier":"AEG-2"}$paperclip$, $paperclip$2026-04-03T07:09:13.766Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$2c356b55-9954-482e-93ab-f077fe5cfaf6$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$ba377e27-bd3d-438c-bd46-bf6688dbcde7$paperclip$, NULL, $paperclip${"title":"[REVIEW] Gate 1 - Code review by Vigil","identifier":"AEG-3"}$paperclip$, $paperclip$2026-04-03T07:09:13.802Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$a1d5b054-ecd8-4736-ad05-2682f6af1ae9$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$project.created$paperclip$, $paperclip$project$paperclip$, $paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, NULL, $paperclip${"name":"Onboarding","workspaceId":null}$paperclip$, $paperclip$2026-04-03T07:11:04.158Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$cffbca86-9702-42fc-9728-b3bf3f2efb60$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.key_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, NULL, $paperclip${"name":"local-cli","keyId":"79d1f76f-5bce-4f93-9bb8-d05c28fa18c7"}$paperclip$, $paperclip$2026-04-03T07:11:13.002Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$77c96bbe-d5be-4cf4-b6c8-079591e54be8$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$56aaf90a-6b56-4079-aac6-6973aeec8370$paperclip$, NULL, $paperclip${"title":"[QA] Gate 2 - Test strategy and execution","identifier":"AEG-4"}$paperclip$, $paperclip$2026-04-03T07:09:13.844Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4407da80-6a55-44c2-98b4-48b9a80c6176$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$issue.checked_out$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip${"agentId":"fb9504df-4a79-403a-8c73-efd73abf869c"}$paperclip$, $paperclip$2026-04-03T07:11:23.031Z$paperclip$, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$a97c9e52-ecaa-450f-ac3e-2d378b6836f9$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$issue.comment_added$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip${"commentId":"866b8b93-7ff0-4abc-8e50-31f66c4d4d35","identifier":"AEG-1","issueTitle":"[SPEC] Create BRD + SRS specification template","bodySnippet":"Starting Phase A — structured Q&A to gather requirements. Will ask 10 questions, then produce BRD + SRS + UX Blueprint f"}$paperclip$, $paperclip$2026-04-03T07:11:35.301Z$paperclip$, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$467e0478-6bee-4fd5-a5e0-5d16ceb0963f$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.key_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip${"name":"local-cli","keyId":"89abacdf-039a-40a4-a7de-6bc549e085ee"}$paperclip$, $paperclip$2026-04-03T07:11:44.578Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$87d849df-82d5-4d2f-a2a6-d30ce5a87ab6$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.key_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip${"name":"local-cli","keyId":"7d790d8b-5d49-4b48-b54f-154b683fb4f6"}$paperclip$, $paperclip$2026-04-03T07:11:49.832Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$75aee5b2-6b3a-400a-8b64-2556f024311c$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$issue.checked_out$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"agentId":"1e6d0b76-3817-4502-901e-7dd1356cd771"}$paperclip$, $paperclip$2026-04-03T07:12:08.430Z$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$95d866ce-8a1e-4286-aeda-3f1dac73780a$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$agent.hire_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"name":"Navi","role":"cto","issueIds":["af75be97-329e-4d28-80d9-27b03db4f7c6"],"approvalId":"8112ed6e-4eae-4360-9ac1-c5e88764c1b5","desiredSkills":null,"requiresApproval":true}$paperclip$, $paperclip$2026-04-03T07:12:53.824Z$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$5c81432f-4bd3-4f16-973e-e42802785e51$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$approval.created$paperclip$, $paperclip$approval$paperclip$, $paperclip$8112ed6e-4eae-4360-9ac1-c5e88764c1b5$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"type":"hire_agent","linkedAgentId":"3df78889-0a61-4fed-bb04-6c3134c3d2d8"}$paperclip$, $paperclip$2026-04-03T07:12:53.833Z$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$56731794-63b9-4f5c-be74-036f847584e6$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$approval.comment_added$paperclip$, $paperclip$approval$paperclip$, $paperclip$8112ed6e-4eae-4360-9ac1-c5e88764c1b5$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"commentId":"864732d2-d28b-4d8f-86b5-f0f39b2ab0bd"}$paperclip$, $paperclip$2026-04-03T07:13:04.803Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$8c788b62-cac6-4d4f-89da-2be45ee47e4a$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"source":"comment","status":"blocked","_previous":{"status":"in_progress"},"identifier":"AEGA-1"}$paperclip$, $paperclip$2026-04-03T07:13:14.357Z$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$173e91cf-e23e-4fe6-800f-e3df915c7f9e$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$issue.comment_added$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"updated":true,"commentId":"7a4a7036-317e-4def-8f4d-ebace0368c21","identifier":"AEGA-1","issueTitle":"Activate AEGIS: Scan project state, hire remaining agents, and begin Sprint 1","bodySnippet":"## Heartbeat 1 — Initial assessment and CTO hire\n\n**Situation:**\n- Green-field activation. Only CEO (me) exists. Zero ag"}$paperclip$, $paperclip$2026-04-03T07:13:14.362Z$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$fbdc2635-e647-4b53-9a24-7b06c16ea54d$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:13:26.924Z"}$paperclip$, $paperclip$2026-04-03T07:13:26.928Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4fae0bc8-5510-4db7-bcb3-edd2cd5eb23f$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:14:13.631Z"}$paperclip$, $paperclip$2026-04-03T07:14:13.633Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$fb0663dc-6965-47b0-a6d2-ccbd731c641f$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:14:18.204Z"}$paperclip$, $paperclip$2026-04-03T07:14:18.208Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$aefd80ac-4692-47c9-b470-213f4f58d56b$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:14:33.485Z"}$paperclip$, $paperclip$2026-04-03T07:14:33.486Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$06adb561-3831-4e02-b8fc-9487760bde05$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:14:40.083Z"}$paperclip$, $paperclip$2026-04-03T07:14:40.086Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$100728bd-2c71-4653-8b92-1da6a5b29a5c$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$approval.approved$paperclip$, $paperclip$approval$paperclip$, $paperclip$8112ed6e-4eae-4360-9ac1-c5e88764c1b5$paperclip$, NULL, $paperclip${"type":"hire_agent","linkedIssueIds":["af75be97-329e-4d28-80d9-27b03db4f7c6"],"requestedByAgentId":"1e6d0b76-3817-4502-901e-7dd1356cd771"}$paperclip$, $paperclip$2026-04-03T07:15:07.806Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$a086fbf1-25e1-4dc6-abbc-c8a49f34d871$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$approval.requester_wakeup_queued$paperclip$, $paperclip$approval$paperclip$, $paperclip$8112ed6e-4eae-4360-9ac1-c5e88764c1b5$paperclip$, NULL, $paperclip${"wakeRunId":"d1c08dfe-79d2-4b00-bebe-cf556cb7b15e","linkedIssueIds":["af75be97-329e-4d28-80d9-27b03db4f7c6"],"requesterAgentId":"1e6d0b76-3817-4502-901e-7dd1356cd771"}$paperclip$, $paperclip$2026-04-03T07:15:07.826Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$83e2f9b2-ef5b-46a1-af17-c30fd7747df2$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:15:23.078Z"}$paperclip$, $paperclip$2026-04-03T07:15:23.080Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$20856d88-7bbd-4b43-a061-0d45cb4b7b67$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$issue.checked_out$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"agentId":"1e6d0b76-3817-4502-901e-7dd1356cd771"}$paperclip$, $paperclip$2026-04-03T07:15:33.110Z$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$8b935c50-7da9-4e73-97f8-bab33f26fb18$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"title":"Build AEGIS org, create Sprint 1 plan, and delegate spec creation","identifier":"AEGA-2"}$paperclip$, $paperclip$2026-04-03T07:16:43.129Z$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$2d82d74b-7475-4271-a37e-6eb4c91e20a4$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"source":"comment","status":"in_progress","identifier":"AEGA-1"}$paperclip$, $paperclip$2026-04-03T07:17:00.592Z$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$63bfc0b2-dfec-4554-bc16-1afb4e44bf93$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$issue.comment_added$paperclip$, $paperclip$issue$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip${"commentId":"c6555771-d45b-4763-82eb-3fdf03f613c8","identifier":"AEGA-1","issueTitle":"Activate AEGIS: Scan project state, hire remaining agents, and begin Sprint 1","bodySnippet":"## Heartbeat 2 — CTO approved, delegation started\n\n**Approval resolved:**\n- Navi (CTO) hire approved by board: [8112ed6e"}$paperclip$, $paperclip$2026-04-03T07:17:00.595Z$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$2ce02a69-001c-4bfd-8d52-875244f85ddf$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.key_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, NULL, $paperclip${"name":"local-cli","keyId":"fa86317a-7375-4c09-b551-ebcf30bfe280"}$paperclip$, $paperclip$2026-04-03T07:17:10.391Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$d4d080f9-f180-4785-a0e6-f4ac4ad47470$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.key_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, NULL, $paperclip${"name":"local-cli","keyId":"d01c8fbe-a382-4384-a446-fa540cd80d58"}$paperclip$, $paperclip$2026-04-03T07:17:13.785Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$b2a4557b-da5b-41a7-a5aa-aebaef2a892f$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$company.updated$paperclip$, $paperclip$company$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, NULL, $paperclip${"feedbackDataSharingEnabled":true,"feedbackDataSharingConsentAt":"2026-04-03T07:18:03.637Z","feedbackDataSharingTermsVersion":"feedback-data-sharing-v1","feedbackDataSharingConsentByUserId":"local-board"}$paperclip$, $paperclip$2026-04-03T07:18:03.642Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$70ac0935-657a-4ce2-bd8c-94a01b29f31b$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$invite.openclaw_prompt_created$paperclip$, $paperclip$invite$paperclip$, $paperclip$4527fe57-f36a-4ae6-8b58-8d7486332d31$paperclip$, NULL, $paperclip${"expiresAt":"2026-04-03T07:28:12.085Z","inviteType":"company_join","hasAgentMessage":false,"allowedJoinTypes":"agent"}$paperclip$, $paperclip$2026-04-03T07:18:12.096Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$3e71e728-6d39-4aa6-afff-764f1104e0cf$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.key_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, NULL, $paperclip${"name":"local-cli","keyId":"a2084965-62eb-4858-b03a-cf3132a41a59"}$paperclip$, $paperclip$2026-04-03T07:18:13.028Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$c91c7e3b-1007-4a53-94b1-6b6c6a9675f7$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$agent.key_created$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, NULL, $paperclip${"name":"local-cli","keyId":"ecd8f77d-033d-4738-911f-c2694638780a"}$paperclip$, $paperclip$2026-04-03T07:18:20.188Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$05803da1-662d-4017-a830-3de80178ca29$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:21:04.278Z"}$paperclip$, $paperclip$2026-04-03T07:21:04.290Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4b982f3c-3b0e-4b14-88f6-72857a39b743$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:26:57.337Z"}$paperclip$, $paperclip$2026-04-03T07:26:57.341Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$db30508e-e6c9-4e85-b72d-1d610169d507$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$aa16b27c-7ac5-4840-ada3-c2b80ffe00e8$paperclip$, NULL, $paperclip${"status":"backlog","identifier":"AEG-5"}$paperclip$, $paperclip$2026-04-03T07:47:19.224Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$2e2be5a3-2968-45b6-b0cb-b8cb45fab6ce$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$routine.trigger_created$paperclip$, $paperclip$routine_trigger$paperclip$, $paperclip$8381bf68-225e-491e-a9eb-99f3eb27031c$paperclip$, NULL, $paperclip${"kind":"schedule","routineId":"fde6d1f8-b636-42e5-81c2-a2b81d3adce3"}$paperclip$, $paperclip$2026-04-03T07:48:09.512Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$32eacee6-14e0-4b14-9226-82e5864d2ee6$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$routine.trigger_created$paperclip$, $paperclip$routine_trigger$paperclip$, $paperclip$cf0584ef-fced-4403-a5a5-f61cb731219d$paperclip$, NULL, $paperclip${"kind":"schedule","routineId":"ddff6130-5b12-4618-bdeb-dea25eba121e"}$paperclip$, $paperclip$2026-04-03T07:48:09.640Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$1fca7acb-08fb-40c9-a751-931938ed29ec$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$routine.trigger_created$paperclip$, $paperclip$routine_trigger$paperclip$, $paperclip$17be08b5-431d-402d-a66f-9dd24b85e3ee$paperclip$, NULL, $paperclip${"kind":"schedule","routineId":"cc6cdb9a-5514-4442-8a4b-67c7b58b8d1b"}$paperclip$, $paperclip$2026-04-03T07:48:09.753Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$2851c184-eea7-4990-937a-6b8118740c9d$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$issue.checked_out$paperclip$, $paperclip$issue$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip${"agentId":"3df78889-0a61-4fed-bb04-6c3134c3d2d8"}$paperclip$, $paperclip$2026-04-03T07:18:28.250Z$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4ef108de-dfb7-40f2-9d76-dfb4aa9e752a$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$issue.document_created$paperclip$, $paperclip$issue$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip${"key":"plan","title":"Sprint 1 Plan — Phase A: IDEA → SPEC","format":"markdown","documentId":"09c406ff-9d42-4d8f-b736-0f0d454ca74f","revisionNumber":1}$paperclip$, $paperclip$2026-04-03T07:19:04.137Z$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$00472ffa-7c44-4627-93f8-97a969aada55$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$issue.comment_added$paperclip$, $paperclip$issue$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip${"commentId":"47319f92-702d-4053-90e7-6b43d978ed20","identifier":"AEGA-2","issueTitle":"Build AEGIS org, create Sprint 1 plan, and delegate spec creation","bodySnippet":"## Sprint 1 Assessment — CTO Navi\n\n### Current State\n- Only 2 agents exist: Mother Brain (CEO) and Navi (CTO)\n- No code,"}$paperclip$, $paperclip$2026-04-03T07:19:19.142Z$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$e85746f3-df7c-484e-8c5f-f7402c27575f$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:21:51.314Z"}$paperclip$, $paperclip$2026-04-03T07:21:51.318Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$af6ae204-e47a-440d-b10a-f48a2a03b2b5$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip${"source":"comment","status":"blocked","_previous":{"status":"in_progress"},"identifier":"AEGA-2"}$paperclip$, $paperclip$2026-04-03T07:19:24.174Z$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$8575eb86-2ac6-4557-954d-477699fb0c72$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$routine.created$paperclip$, $paperclip$routine$paperclip$, $paperclip$fde6d1f8-b636-42e5-81c2-a2b81d3adce3$paperclip$, NULL, $paperclip${"title":"Mother Brain Heartbeat","assigneeAgentId":"32eb19c3-4746-4313-b75a-c136b3e53061"}$paperclip$, $paperclip$2026-04-03T07:48:09.304Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$9bf31b78-95e5-4ac8-8465-f5f941394d02$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$issue.comment_added$paperclip$, $paperclip$issue$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip${"updated":true,"commentId":"1d190a36-d77e-4ea2-89d9-9d8b293d3726","identifier":"AEGA-2","issueTitle":"Build AEGIS org, create Sprint 1 plan, and delegate spec creation","bodySnippet":"Blocked: awaiting CEO (Mother Brain) to hire Sage (Specification Architect). No BRD/SRS can be created without Sage. Pla"}$paperclip$, $paperclip$2026-04-03T07:19:24.181Z$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$d6603146-1a7c-4d50-b1a9-1a7c6886e641$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:22:58.173Z"}$paperclip$, $paperclip$2026-04-03T07:22:58.176Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$13abb2e8-c7df-4a6f-b649-56c1b1e5df9f$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:28:12.063Z"}$paperclip$, $paperclip$2026-04-03T07:28:12.066Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$f5b68e44-98b1-4173-b8ed-a8bc09a9ecc2$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$routine.created$paperclip$, $paperclip$routine$paperclip$, $paperclip$cc6cdb9a-5514-4442-8a4b-67c7b58b8d1b$paperclip$, NULL, $paperclip${"title":"Weekly Dependency & Security Scan","assigneeAgentId":"2e52a6a5-ee41-4fc4-9017-e848cf543932"}$paperclip$, $paperclip$2026-04-03T07:48:09.418Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$f36f08c6-d3a0-4eac-9910-8bc06ebf4d8c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:20:37.330Z"}$paperclip$, $paperclip$2026-04-03T07:20:37.331Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$28754247-77f0-420d-8ad2-a120baf2fca3$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$4509a2a8-afab-4f59-8d29-ae9a245eb295$paperclip$, NULL, $paperclip${"status":"backlog","identifier":"AEG-2"}$paperclip$, $paperclip$2026-04-03T07:47:19.127Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$76e7bfd0-cdf2-4ce2-ae94-08a62bcdd285$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$270b74c3-64ed-42da-aa3c-62285281725d$paperclip$, NULL, $paperclip${"status":"backlog","identifier":"AEG-6"}$paperclip$, $paperclip$2026-04-03T07:47:19.260Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4de2651d-d4b2-46a4-affd-3bfd1b51786d$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:20:41.927Z"}$paperclip$, $paperclip$2026-04-03T07:20:41.929Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$ba81396b-8310-4295-9ade-0267a099c8d9$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$aa16b27c-7ac5-4840-ada3-c2b80ffe00e8$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:21:14.613Z"}$paperclip$, $paperclip$2026-04-03T07:21:14.614Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$df6943aa-8346-4d80-a2e0-b78905dfbb51$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$company.updated$paperclip$, $paperclip$company$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, NULL, $paperclip${"budgetMonthlyCents":50000}$paperclip$, $paperclip$2026-04-03T07:46:55.010Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$e0710e15-4b05-4a42-bc3e-5e9a5836e31e$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.comment_added$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"updated":true,"commentId":"45f82b39-fc0c-4676-b7e8-eb6312087941","identifier":"AEG-1","issueTitle":"[SPEC] Create BRD + SRS specification template","bodySnippet":"Parking - no active product project yet. Will reactivate when a real project begins."}$paperclip$, $paperclip$2026-04-03T07:47:19.103Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$6969e331-42ae-4c15-ac8a-87a292211dd2$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$ba377e27-bd3d-438c-bd46-bf6688dbcde7$paperclip$, NULL, $paperclip${"status":"backlog","identifier":"AEG-3"}$paperclip$, $paperclip$2026-04-03T07:47:19.160Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$155fdb12-019d-41e8-826a-5aa9c31243d4$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$270b74c3-64ed-42da-aa3c-62285281725d$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:21:11.824Z"}$paperclip$, $paperclip$2026-04-03T07:21:11.827Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$829b5dd3-c38c-4b30-b804-9a0db915a05b$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$56aaf90a-6b56-4079-aac6-6973aeec8370$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:21:18.348Z"}$paperclip$, $paperclip$2026-04-03T07:21:18.350Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$dd8b6685-a086-4e3c-bce0-424fde84167b$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$56aaf90a-6b56-4079-aac6-6973aeec8370$paperclip$, NULL, $paperclip${"status":"backlog","identifier":"AEG-4"}$paperclip$, $paperclip$2026-04-03T07:47:19.196Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$0b3ee9d1-752a-4540-93c2-a0d9decc3836$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$routine.created$paperclip$, $paperclip$routine$paperclip$, $paperclip$ddff6130-5b12-4618-bdeb-dea25eba121e$paperclip$, NULL, $paperclip${"title":"Daily Sprint Standup","assigneeAgentId":"b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0"}$paperclip$, $paperclip$2026-04-03T07:48:09.378Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$c5e82b5f-cfc9-414b-99d3-4299261d0a01$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"userId":"local-board","lastReadAt":"2026-04-03T07:24:54.987Z"}$paperclip$, $paperclip$2026-04-03T07:24:54.988Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$afb368fc-3384-4308-b50d-e425cbc2da42$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip${"source":"comment","status":"backlog","_previous":{"status":"in_progress"},"identifier":"AEG-1"}$paperclip$, $paperclip$2026-04-03T07:47:19.097Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agent_api_keys (9 rows)
INSERT INTO "public"."agent_api_keys" ("id", "agent_id", "company_id", "name", "key_hash", "last_used_at", "revoked_at", "created_at") VALUES ($paperclip$c3c2e899-f1ef-4382-bd84-f7b3e05000cd$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$local-cli$paperclip$, $paperclip$1ea08914a868b1c4ca88a1bc880c975a51c0ac9b867f6219231436f71d103639$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:10:49.031Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_api_keys" ("id", "agent_id", "company_id", "name", "key_hash", "last_used_at", "revoked_at", "created_at") VALUES ($paperclip$5908c86d-7f44-463a-95b2-231504c8050c$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$local-cli$paperclip$, $paperclip$8cda7fd5c64d16269f58e975a336b53ae920ef8943f24bac17be1c85bfa6f682$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:10:54.744Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_api_keys" ("id", "agent_id", "company_id", "name", "key_hash", "last_used_at", "revoked_at", "created_at") VALUES ($paperclip$79d1f76f-5bce-4f93-9bb8-d05c28fa18c7$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$local-cli$paperclip$, $paperclip$ffdf7fce17619bf04baf48e62dbc68cc484eb2a0861591f28ddba6a755171161$paperclip$, $paperclip$2026-04-03T07:11:35.291Z$paperclip$, NULL, $paperclip$2026-04-03T07:11:13.000Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_api_keys" ("id", "agent_id", "company_id", "name", "key_hash", "last_used_at", "revoked_at", "created_at") VALUES ($paperclip$89abacdf-039a-40a4-a7de-6bc549e085ee$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$local-cli$paperclip$, $paperclip$452e9f322c964b320c400cd04ca88d28df359eadff291be1754d9db4b5cc6692$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:11:44.575Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_api_keys" ("id", "agent_id", "company_id", "name", "key_hash", "last_used_at", "revoked_at", "created_at") VALUES ($paperclip$7d790d8b-5d49-4b48-b54f-154b683fb4f6$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$local-cli$paperclip$, $paperclip$a3f966efaf6b5eeacef168241fd38e9d6f8b38618a28bc09e8e83ec019cb7b8f$paperclip$, $paperclip$2026-04-03T07:17:00.585Z$paperclip$, NULL, $paperclip$2026-04-03T07:11:49.831Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_api_keys" ("id", "agent_id", "company_id", "name", "key_hash", "last_used_at", "revoked_at", "created_at") VALUES ($paperclip$fa86317a-7375-4c09-b551-ebcf30bfe280$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$local-cli$paperclip$, $paperclip$89a65d3fde09ca9179ec76b3b6a3d363b7c228ddc28c6f4d1a1f89e8ade2ed31$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:17:10.390Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_api_keys" ("id", "agent_id", "company_id", "name", "key_hash", "last_used_at", "revoked_at", "created_at") VALUES ($paperclip$d01c8fbe-a382-4384-a446-fa540cd80d58$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$local-cli$paperclip$, $paperclip$4f228ccedac422b37fb5d4d86ec532f7a607d77cbabb853987c901af7c6fa15d$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:17:13.784Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_api_keys" ("id", "agent_id", "company_id", "name", "key_hash", "last_used_at", "revoked_at", "created_at") VALUES ($paperclip$a2084965-62eb-4858-b03a-cf3132a41a59$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$local-cli$paperclip$, $paperclip$8fc5f4968b1bb8f4259a879057ac5583fc48c794e0ad1fec87d635c56e8fe0f7$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:18:13.027Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_api_keys" ("id", "agent_id", "company_id", "name", "key_hash", "last_used_at", "revoked_at", "created_at") VALUES ($paperclip$ecd8f77d-033d-4738-911f-c2694638780a$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$local-cli$paperclip$, $paperclip$09ee7d25df488e7fcfb6022b167c98183025b1e77c7245379bc5941d1f26df71$paperclip$, $paperclip$2026-04-03T07:19:24.166Z$paperclip$, NULL, $paperclip$2026-04-03T07:18:20.186Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agent_runtime_state (7 rows)
INSERT INTO "public"."agent_runtime_state" ("agent_id", "company_id", "adapter_type", "session_id", "state_json", "last_run_id", "last_run_status", "total_input_tokens", "total_output_tokens", "total_cached_input_tokens", "total_cost_cents", "last_error", "created_at", "updated_at") VALUES ($paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$claude_local$paperclip$, $paperclip$c0011f36-8c58-4ee0-a5e7-96a51a280338$paperclip$, $paperclip${}$paperclip$, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$, $paperclip$succeeded$paperclip$, $paperclip$25$paperclip$, $paperclip$4296$paperclip$, $paperclip$761113$paperclip$, $paperclip$0$paperclip$, NULL, $paperclip$2026-04-03T07:09:13.747Z$paperclip$, $paperclip$2026-04-03T07:12:08.528Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_runtime_state" ("agent_id", "company_id", "adapter_type", "session_id", "state_json", "last_run_id", "last_run_status", "total_input_tokens", "total_output_tokens", "total_cached_input_tokens", "total_cost_cents", "last_error", "created_at", "updated_at") VALUES ($paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$claude_local$paperclip$, $paperclip$60e284df-eb26-46b8-8507-391b2bddce9d$paperclip$, $paperclip${}$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$, $paperclip$succeeded$paperclip$, $paperclip$45$paperclip$, $paperclip$11632$paperclip$, $paperclip$1116727$paperclip$, $paperclip$0$paperclip$, NULL, $paperclip$2026-04-03T07:11:04.219Z$paperclip$, $paperclip$2026-04-03T07:17:10.820Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_runtime_state" ("agent_id", "company_id", "adapter_type", "session_id", "state_json", "last_run_id", "last_run_status", "total_input_tokens", "total_output_tokens", "total_cached_input_tokens", "total_cost_cents", "last_error", "created_at", "updated_at") VALUES ($paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$claude_local$paperclip$, $paperclip$ca78b91f-bd28-466e-b083-0cc2414dcce8$paperclip$, $paperclip${}$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$, $paperclip$succeeded$paperclip$, $paperclip$35$paperclip$, $paperclip$6882$paperclip$, $paperclip$1301513$paperclip$, $paperclip$0$paperclip$, NULL, $paperclip$2026-04-03T07:16:43.194Z$paperclip$, $paperclip$2026-04-03T07:19:33.717Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_runtime_state" ("agent_id", "company_id", "adapter_type", "session_id", "state_json", "last_run_id", "last_run_status", "total_input_tokens", "total_output_tokens", "total_cached_input_tokens", "total_cost_cents", "last_error", "created_at", "updated_at") VALUES ($paperclip$32eb19c3-4746-4313-b75a-c136b3e53061$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$claude_local$paperclip$, NULL, $paperclip${}$paperclip$, NULL, NULL, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, NULL, $paperclip$2026-04-03T07:24:31.895Z$paperclip$, $paperclip$2026-04-03T07:24:31.895Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_runtime_state" ("agent_id", "company_id", "adapter_type", "session_id", "state_json", "last_run_id", "last_run_status", "total_input_tokens", "total_output_tokens", "total_cached_input_tokens", "total_cost_cents", "last_error", "created_at", "updated_at") VALUES ($paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$claude_local$paperclip$, NULL, $paperclip${}$paperclip$, NULL, NULL, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, NULL, $paperclip$2026-04-03T07:24:34.180Z$paperclip$, $paperclip$2026-04-03T07:24:34.180Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_runtime_state" ("agent_id", "company_id", "adapter_type", "session_id", "state_json", "last_run_id", "last_run_status", "total_input_tokens", "total_output_tokens", "total_cached_input_tokens", "total_cost_cents", "last_error", "created_at", "updated_at") VALUES ($paperclip$2e52a6a5-ee41-4fc4-9017-e848cf543932$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$claude_local$paperclip$, NULL, $paperclip${}$paperclip$, NULL, NULL, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, NULL, $paperclip$2026-04-03T07:24:35.116Z$paperclip$, $paperclip$2026-04-03T07:24:35.116Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_runtime_state" ("agent_id", "company_id", "adapter_type", "session_id", "state_json", "last_run_id", "last_run_status", "total_input_tokens", "total_output_tokens", "total_cached_input_tokens", "total_cost_cents", "last_error", "created_at", "updated_at") VALUES ($paperclip$634372bd-2e09-4ff7-bbd8-6edbee0db841$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$claude_local$paperclip$, NULL, $paperclip${}$paperclip$, NULL, NULL, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, NULL, $paperclip$2026-04-03T07:24:35.964Z$paperclip$, $paperclip$2026-04-03T07:24:35.964Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agent_task_sessions (3 rows)
INSERT INTO "public"."agent_task_sessions" ("id", "company_id", "agent_id", "adapter_type", "task_key", "session_params_json", "session_display_id", "last_run_id", "last_error", "created_at", "updated_at") VALUES ($paperclip$e37b8451-c0fd-4cad-92fb-44877422eb0f$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$claude_local$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, $paperclip${"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/9c929d23-2ccc-4a69-9757-348ec303068b/dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc/_default","sessionId":"c0011f36-8c58-4ee0-a5e7-96a51a280338"}$paperclip$, $paperclip$c0011f36-8c58-4ee0-a5e7-96a51a280338$paperclip$, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$, NULL, $paperclip$2026-04-03T07:12:08.536Z$paperclip$, $paperclip$2026-04-03T07:12:08.536Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_task_sessions" ("id", "company_id", "agent_id", "adapter_type", "task_key", "session_params_json", "session_display_id", "last_run_id", "last_error", "created_at", "updated_at") VALUES ($paperclip$be173db8-3069-44e8-a130-d81698eba61f$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$claude_local$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip${"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","sessionId":"60e284df-eb26-46b8-8507-391b2bddce9d"}$paperclip$, $paperclip$60e284df-eb26-46b8-8507-391b2bddce9d$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$, NULL, $paperclip$2026-04-03T07:13:27.180Z$paperclip$, $paperclip$2026-04-03T07:17:10.825Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_task_sessions" ("id", "company_id", "agent_id", "adapter_type", "task_key", "session_params_json", "session_display_id", "last_run_id", "last_error", "created_at", "updated_at") VALUES ($paperclip$4f8d7b43-1339-4c68-b241-9f228b4ab6ad$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$claude_local$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip${"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","sessionId":"ca78b91f-bd28-466e-b083-0cc2414dcce8"}$paperclip$, $paperclip$ca78b91f-bd28-466e-b083-0cc2414dcce8$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$, NULL, $paperclip$2026-04-03T07:19:33.724Z$paperclip$, $paperclip$2026-04-03T07:19:33.724Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agent_wakeup_requests (4 rows)
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$a78e3831-d7ed-4844-badc-70ba85ba3c1c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$assignment$paperclip$, $paperclip$system$paperclip$, $paperclip$issue_assigned$paperclip$, $paperclip${"issueId":"16332a71-9b62-4703-a0a6-452b1fabc4a7","mutation":"create"}$paperclip$, $paperclip$completed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, NULL, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$, $paperclip$2026-04-03T07:09:13.736Z$paperclip$, $paperclip$2026-04-03T07:09:13.744Z$paperclip$, $paperclip$2026-04-03T07:12:08.522Z$paperclip$, NULL, $paperclip$2026-04-03T07:09:13.736Z$paperclip$, $paperclip$2026-04-03T07:12:08.522Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$108b8156-6149-4727-84b2-01d7292c6f92$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$assignment$paperclip$, $paperclip$system$paperclip$, $paperclip$issue_assigned$paperclip$, $paperclip${"issueId":"af75be97-329e-4d28-80d9-27b03db4f7c6","mutation":"create"}$paperclip$, $paperclip$completed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, NULL, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$, $paperclip$2026-04-03T07:11:04.198Z$paperclip$, $paperclip$2026-04-03T07:11:04.213Z$paperclip$, $paperclip$2026-04-03T07:13:27.165Z$paperclip$, NULL, $paperclip$2026-04-03T07:11:04.198Z$paperclip$, $paperclip$2026-04-03T07:13:27.165Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$740b95a5-1a9e-41d3-aa72-75de1791ccf2$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$automation$paperclip$, $paperclip$system$paperclip$, $paperclip$approval_approved$paperclip$, $paperclip${"issueId":"af75be97-329e-4d28-80d9-27b03db4f7c6","issueIds":["af75be97-329e-4d28-80d9-27b03db4f7c6"],"approvalId":"8112ed6e-4eae-4360-9ac1-c5e88764c1b5","approvalStatus":"approved"}$paperclip$, $paperclip$completed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, NULL, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$, $paperclip$2026-04-03T07:15:07.815Z$paperclip$, $paperclip$2026-04-03T07:15:07.825Z$paperclip$, $paperclip$2026-04-03T07:17:10.810Z$paperclip$, NULL, $paperclip$2026-04-03T07:15:07.815Z$paperclip$, $paperclip$2026-04-03T07:17:10.810Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$cd2ad101-bb97-4eb7-82ad-bd4e6bdc7a12$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$assignment$paperclip$, $paperclip$system$paperclip$, $paperclip$issue_assigned$paperclip$, $paperclip${"issueId":"d447cdfb-1655-41ba-b222-a7fad582e53c","mutation":"create"}$paperclip$, $paperclip$completed$paperclip$, 0, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$, $paperclip$2026-04-03T07:16:43.146Z$paperclip$, $paperclip$2026-04-03T07:16:43.166Z$paperclip$, $paperclip$2026-04-03T07:19:33.702Z$paperclip$, NULL, $paperclip$2026-04-03T07:16:43.146Z$paperclip$, $paperclip$2026-04-03T07:19:33.702Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agents (15 rows)
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$32eb19c3-4746-4313-b75a-c136b3e53061$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Mother Brain$paperclip$, $paperclip$ceo$paperclip$, $paperclip$Autonomous Decision Engine$paperclip$, $paperclip$idle$paperclip$, NULL, $paperclip$Persistent background orchestrator. Heartbeat loop: PULSE → SCAN → ANALYZE → DECIDE → DISPATCH → VERIFY → LEARN → BUDGET → WAIT. Agent health monitoring (nudge >120s, respawn >300s). Two-phase autonomy: Phase A human-in-the-loop spec, Phase B full autonomy with Spec Proxy mode. Decision matrix P0-P10. Context budget enforcement. 5-Gate quality oversight. Sprint/Kanban-aware dispatch.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/32eb19c3-4746-4313-b75a-c136b3e53061/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/32eb19c3-4746-4313-b75a-c136b3e53061/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 15000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:42.976Z$paperclip$, $paperclip$2026-04-03T07:08:43.006Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":true}$paperclip$, $paperclip$crown$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Navi$paperclip$, $paperclip$pm$paperclip$, $paperclip$Navigator & Lead Orchestrator$paperclip$, $paperclip$idle$paperclip$, $paperclip$32eb19c3-4746-4313-b75a-c136b3e53061$paperclip$, $paperclip$Team orchestration and synthesis. Conducts retrospectives. Resolves inter-agent conflicts. Synthesizes multi-agent outputs. Facilitates sprint ceremonies. Routes tasks to specialists. Escalates blockers to Mother Brain.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 5000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.076Z$paperclip$, $paperclip$2026-04-03T07:08:43.084Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$target$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$34810f8a-b6f9-452e-884c-428b3fb0dbc9$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Bolt$paperclip$, $paperclip$engineer$paperclip$, $paperclip$Fast Implementer$paperclip$, $paperclip$idle$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$Production code implementation from approved specs. Feature development. Test creation (unit + integration). Refactoring. Build execution. Bug remediation. REQUIRES approved spec. RESTRICTED to src/, lib/, tests/, config. MUST include test coverage. CANNOT deploy without gates. Output: _aegis-output/implementation/$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/34810f8a-b6f9-452e-884c-428b3fb0dbc9/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/34810f8a-b6f9-452e-884c-428b3fb0dbc9/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 5000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.167Z$paperclip$, $paperclip$2026-04-03T07:08:43.173Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$zap$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$efb1cef7-7aa4-42ab-97bc-05d9b453486b$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Vigil$paperclip$, $paperclip$qa$paperclip$, $paperclip$Code Reviewer & Gate 1 Owner$paperclip$, $paperclip$idle$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$Gate 1 owner: Code review for correctness, security, performance, maintainability, compliance. Blocks merge on critical findings. Reviews all PRs. Validates coding standards. Security vulnerability scanning. Performance regression detection.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/efb1cef7-7aa4-42ab-97bc-05d9b453486b/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/efb1cef7-7aa4-42ab-97bc-05d9b453486b/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 3000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.209Z$paperclip$, $paperclip$2026-04-03T07:08:43.214Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$shield$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$634372bd-2e09-4ff7-bbd8-6edbee0db841$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Havoc$paperclip$, $paperclip$researcher$paperclip$, $paperclip$Devils Advocate & Decision Challenger$paperclip$, $paperclip$idle$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$Challenges every design decision, assumption, and trade-off. Finds flaws and edge cases. Adversarial testing of specs and architecture. Stress-tests assumptions. Identifies single points of failure. Questions technology choices. Forces explicit justification.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/634372bd-2e09-4ff7-bbd8-6edbee0db841/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/634372bd-2e09-4ff7-bbd8-6edbee0db841/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 3000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.255Z$paperclip$, $paperclip$2026-04-03T07:08:43.260Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$flame$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$2e52a6a5-ee41-4fc4-9017-e848cf543932$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Forge$paperclip$, $paperclip$researcher$paperclip$, $paperclip$Scanner & Data Gatherer$paperclip$, $paperclip$idle$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$Data gathering and metric collection. Codebase scanning. Dependency analysis. Research external APIs and libraries. Benchmark collection. Technology comparison. Feeds findings to Sage, Vigil, and Havoc.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/2e52a6a5-ee41-4fc4-9017-e848cf543932/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/2e52a6a5-ee41-4fc4-9017-e848cf543932/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 1000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.294Z$paperclip$, $paperclip$2026-04-03T07:08:43.299Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$search$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Sage$paperclip$, $paperclip$cto$paperclip$, $paperclip$Architect & Spec Writer$paperclip$, $paperclip$idle$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$System architecture design. Technical specifications (BRD + SRS). Architecture Decision Records (ADRs). API contract design. Data models and schemas. Dependency mapping. CANNOT write production code (delegates to Bolt). CANNOT self-approve designs (requires Vigil/Havoc). Output: _aegis-output/architecture/$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/fb9504df-4a79-403a-8c73-efd73abf869c/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/fb9504df-4a79-403a-8c73-efd73abf869c/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 5000, 0, $paperclip$2026-04-03T07:12:08.539Z$paperclip$, NULL, $paperclip$2026-04-03T07:08:43.121Z$paperclip$, $paperclip$2026-04-03T07:12:08.539Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$brain$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$06e05816-7d38-4c2a-a387-0a5661de648b$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Pixel$paperclip$, $paperclip$designer$paperclip$, $paperclip$UX/UI Designer$paperclip$, $paperclip$idle$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$UI/UX design and component architecture. Accessibility (WCAG) compliance. Design system maintenance. User flow optimization. Responsive layout. Design token management. Interaction pattern design.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/06e05816-7d38-4c2a-a387-0a5661de648b/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/06e05816-7d38-4c2a-a387-0a5661de648b/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 2000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.334Z$paperclip$, $paperclip$2026-04-03T07:08:43.339Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$sparkles$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$c629de00-1589-408c-b400-be83dfa48253$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Muse$paperclip$, $paperclip$general$paperclip$, $paperclip$Content Creator & Documentation Writer$paperclip$, $paperclip$idle$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$Technical documentation. Changelogs and release notes. README and onboarding guides. API documentation. User-facing content. Internal knowledge base articles.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/c629de00-1589-408c-b400-be83dfa48253/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/c629de00-1589-408c-b400-be83dfa48253/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 1000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.376Z$paperclip$, $paperclip$2026-04-03T07:08:43.380Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$lightbulb$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$50a29397-83bc-4fae-976b-ea22d69d6a3a$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Sentinel$paperclip$, $paperclip$qa$paperclip$, $paperclip$QA Lead & Gate 2 Owner$paperclip$, $paperclip$idle$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$Gate 2 owner: Test strategy, test plan creation, test execution oversight, coverage analysis, release gate verdict. Functional, acceptance, regression testing. Delegates execution to Probe. Signs off on quality before deploy.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/50a29397-83bc-4fae-976b-ea22d69d6a3a/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/50a29397-83bc-4fae-976b-ea22d69d6a3a/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 2000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.412Z$paperclip$, $paperclip$2026-04-03T07:08:43.417Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$eye$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$a412beec-95ba-44dd-bdd1-dcb608629065$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Probe$paperclip$, $paperclip$qa$paperclip$, $paperclip$QA Executor & Test Runner$paperclip$, $paperclip$idle$paperclip$, $paperclip$50a29397-83bc-4fae-976b-ea22d69d6a3a$paperclip$, $paperclip$Test execution (unit, integration, e2e). Test result reporting. Bug reproduction. Test data preparation. Coverage measurement. Reports results to Sentinel for verdict.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/a412beec-95ba-44dd-bdd1-dcb608629065/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/a412beec-95ba-44dd-bdd1-dcb608629065/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 1000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.449Z$paperclip$, $paperclip$2026-04-03T07:08:43.453Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$microscope$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$a3dd8cc4-cf7b-486f-be25-dce12648d8eb$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Scribe$paperclip$, $paperclip$general$paperclip$, $paperclip$Compliance Officer & Gate 3 Owner$paperclip$, $paperclip$idle$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$Gate 3 owner: ISO 29110 compliance. 14 work product management. Traceability matrix maintenance. Audit trail documentation. Activity-time generation. Document validation and lifecycle management.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/a3dd8cc4-cf7b-486f-be25-dce12648d8eb/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/a3dd8cc4-cf7b-486f-be25-dce12648d8eb/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 1000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.490Z$paperclip$, $paperclip$2026-04-03T07:08:43.495Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$file-code$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$Mother Brain$paperclip$, $paperclip$ceo$paperclip$, NULL, $paperclip$idle$paperclip$, NULL, NULL, $paperclip$claude_local$paperclip$, $paperclip${"model":"claude-opus-4-6","graceSec":15,"timeoutSec":0,"maxTurnsPerRun":1000,"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/1e6d0b76-3817-4502-901e-7dd1356cd771/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/1e6d0b76-3817-4502-901e-7dd1356cd771/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslySkipPermissions":true}$paperclip$, 0, 0, $paperclip$2026-04-03T07:17:10.827Z$paperclip$, NULL, $paperclip$2026-04-03T07:08:44.049Z$paperclip$, $paperclip$2026-04-03T07:17:10.827Z$paperclip$, $paperclip${"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}}$paperclip$, $paperclip${"canCreateAgents":true}$paperclip$, NULL, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$d99e4fff-2aa7-45e6-95d6-110bfd77d01d$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Ops$paperclip$, $paperclip$devops$paperclip$, $paperclip$DevOps Engineer & Gate 4-5 Owner$paperclip$, $paperclip$idle$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$Gate 4: Build, deploy, health check, smoke test. Gate 5: Post-deploy monitor (5 min), error rate <2x baseline, rollback readiness. CI/CD pipeline management. Infrastructure provisioning. Incident response. Auto-triggered on sprint close after Gate 3 PASS.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/d99e4fff-2aa7-45e6-95d6-110bfd77d01d/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/d99e4fff-2aa7-45e6-95d6-110bfd77d01d/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 2000, 0, NULL, NULL, $paperclip$2026-04-03T07:08:43.533Z$paperclip$, $paperclip$2026-04-03T07:08:43.540Z$paperclip$, $paperclip${}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$rocket$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$Navi$paperclip$, $paperclip$cto$paperclip$, $paperclip$Chief Technology Officer$paperclip$, $paperclip$idle$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$Owns technical roadmap, architecture, engineering staffing, code quality, and execution. Manages all specialist agents: engineers, QA, security, DevOps, infrastructure. Delegates implementation work, reviews technical decisions, and ensures delivery quality.$paperclip$, $paperclip$claude_local$paperclip$, $paperclip${"model":"claude-sonnet-4-6","graceSec":15,"timeoutSec":0,"maxTurnsPerRun":500,"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslySkipPermissions":true}$paperclip$, 0, 0, $paperclip$2026-04-03T07:19:33.725Z$paperclip$, NULL, $paperclip$2026-04-03T07:12:53.816Z$paperclip$, $paperclip$2026-04-03T07:19:33.725Z$paperclip$, $paperclip${"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}}$paperclip$, $paperclip${"canCreateAgents":false}$paperclip$, $paperclip$cpu$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.approval_comments (1 rows)
INSERT INTO "public"."approval_comments" ("id", "company_id", "approval_id", "author_agent_id", "author_user_id", "body", "created_at", "updated_at") VALUES ($paperclip$864732d2-d28b-4d8f-86b5-f0f39b2ab0bd$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$8112ed6e-4eae-4360-9ac1-c5e88764c1b5$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip$## CTO hire request submitted

- **Agent**: Navi — Chief Technology Officer
- **Model**: claude-sonnet-4-6 (Sonnet builds, Opus thinks)
- **Reports to**: Mother Brain (CEO)
- **Capabilities**: Technical roadmap, architecture, engineering staffing, code quality, execution. Manages all specialist agents.
- **Rationale**: First hire. CTO is the single delegation point for all technical work. Once approved, Navi will own hiring the remaining 12 specialist agents and driving Sprint 1.

- Approval: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)
- Pending agent: [Navi](/AEGA/agents/navi)
- Source issue: [AEGA-1](/AEGA/issues/AEGA-1)$paperclip$, $paperclip$2026-04-03T07:13:04.800Z$paperclip$, $paperclip$2026-04-03T07:13:04.800Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.approvals (1 rows)
INSERT INTO "public"."approvals" ("id", "company_id", "type", "requested_by_agent_id", "requested_by_user_id", "status", "payload", "decision_note", "decided_by_user_id", "decided_at", "created_at", "updated_at") VALUES ($paperclip$8112ed6e-4eae-4360-9ac1-c5e88764c1b5$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$hire_agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip$approved$paperclip$, $paperclip${"icon":"cpu","name":"Navi","role":"cto","title":"Chief Technology Officer","agentId":"3df78889-0a61-4fed-bb04-6c3134c3d2d8","metadata":{},"reportsTo":"1e6d0b76-3817-4502-901e-7dd1356cd771","adapterType":"claude_local","capabilities":"Owns technical roadmap, architecture, engineering staffing, code quality, and execution. Manages all specialist agents: engineers, QA, security, DevOps, infrastructure. Delegates implementation work, reviews technical decisions, and ensures delivery quality.","adapterConfig":{"model":"claude-sonnet-4-6","graceSec":15,"timeoutSec":0,"maxTurnsPerRun":500,"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslySkipPermissions":true},"desiredSkills":null,"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":0,"requestedByAgentId":"1e6d0b76-3817-4502-901e-7dd1356cd771","requestedConfigurationSnapshot":{"adapterType":"claude_local","adapterConfig":{"model":"claude-sonnet-4-6","graceSec":15,"timeoutSec":0,"maxTurnsPerRun":500,"instructionsFilePath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions/AGENTS.md","instructionsRootPath":"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslySkipPermissions":true},"desiredSkills":null,"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}}}}$paperclip$, NULL, $paperclip$board$paperclip$, $paperclip$2026-04-03T07:15:07.782Z$paperclip$, $paperclip$2026-04-03T07:12:53.820Z$paperclip$, $paperclip$2026-04-03T07:15:07.782Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.budget_policies (13 rows)
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$fda1ef69-54d5-49c4-b4e1-d58ccb2c40b8$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$32eb19c3-4746-4313-b75a-c136b3e53061$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 15000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.007Z$paperclip$, $paperclip$2026-04-03T07:08:43.007Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$dd179edb-94dd-4acd-a7ea-3d50c588fb62$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 5000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.084Z$paperclip$, $paperclip$2026-04-03T07:08:43.084Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$73a51382-1256-4817-91b9-c57ee8a03b0f$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 5000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.126Z$paperclip$, $paperclip$2026-04-03T07:08:43.126Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$98da19de-4408-455b-8d6c-9bd9d404098e$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$34810f8a-b6f9-452e-884c-428b3fb0dbc9$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 5000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.173Z$paperclip$, $paperclip$2026-04-03T07:08:43.173Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$c6e82478-1d51-4945-be72-bb3c01e70074$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$efb1cef7-7aa4-42ab-97bc-05d9b453486b$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 3000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.214Z$paperclip$, $paperclip$2026-04-03T07:08:43.214Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$50c4ad19-5ec6-4447-8293-8add5a70afa7$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$634372bd-2e09-4ff7-bbd8-6edbee0db841$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 3000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.260Z$paperclip$, $paperclip$2026-04-03T07:08:43.260Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$b7a5c677-cb3c-40c6-900e-ee58f0cd9ca6$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$2e52a6a5-ee41-4fc4-9017-e848cf543932$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 1000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.299Z$paperclip$, $paperclip$2026-04-03T07:08:43.299Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$1f8b17be-44f3-4d9e-a66a-44ad3fd62a4f$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$06e05816-7d38-4c2a-a387-0a5661de648b$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 2000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.339Z$paperclip$, $paperclip$2026-04-03T07:08:43.339Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$1072c596-872f-440c-9a13-f4f6d98b2557$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$c629de00-1589-408c-b400-be83dfa48253$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 1000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.380Z$paperclip$, $paperclip$2026-04-03T07:08:43.380Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$c4d11956-e49a-445d-86a7-b06e003c93ad$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$50a29397-83bc-4fae-976b-ea22d69d6a3a$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 2000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.417Z$paperclip$, $paperclip$2026-04-03T07:08:43.417Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$c07b1142-037a-4046-9b51-dfa347a1eb9c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$a412beec-95ba-44dd-bdd1-dcb608629065$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 1000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.453Z$paperclip$, $paperclip$2026-04-03T07:08:43.453Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$d2eda4d4-42d6-4e8e-ba35-ac0a613f6855$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$a3dd8cc4-cf7b-486f-be25-dce12648d8eb$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 1000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.495Z$paperclip$, $paperclip$2026-04-03T07:08:43.495Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$6f9531ce-df76-4b3b-bbc0-7e681412ceb7$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$d99e4fff-2aa7-45e6-95d6-110bfd77d01d$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 2000, 80, true, true, true, $paperclip$local-board$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.540Z$paperclip$, $paperclip$2026-04-03T07:08:43.540Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.companies (2 rows)
INSERT INTO "public"."companies" ("id", "name", "description", "status", "budget_monthly_cents", "spent_monthly_cents", "created_at", "updated_at", "issue_prefix", "issue_counter", "require_board_approval_for_new_agents", "brand_color", "pause_reason", "paused_at", "feedback_data_sharing_enabled", "feedback_data_sharing_consent_at", "feedback_data_sharing_consent_by_user_id", "feedback_data_sharing_terms_version") VALUES ($paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$AEGIS$paperclip$, NULL, $paperclip$active$paperclip$, 0, 0, $paperclip$2026-04-03T07:05:53.902Z$paperclip$, $paperclip$2026-04-03T07:19:33.722Z$paperclip$, $paperclip$AEGA$paperclip$, 2, true, NULL, NULL, NULL, true, $paperclip$2026-04-03T07:18:03.637Z$paperclip$, $paperclip$local-board$paperclip$, $paperclip$feedback-data-sharing-v1$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."companies" ("id", "name", "description", "status", "budget_monthly_cents", "spent_monthly_cents", "created_at", "updated_at", "issue_prefix", "issue_counter", "require_board_approval_for_new_agents", "brand_color", "pause_reason", "paused_at", "feedback_data_sharing_enabled", "feedback_data_sharing_consent_at", "feedback_data_sharing_consent_by_user_id", "feedback_data_sharing_terms_version") VALUES ($paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$AEGIS$paperclip$, $paperclip$Production-grade autonomous software delivery via 13 AI agents. 14-Stage SDLC Pipeline (IDEA → SPEC → BUILD → REVIEW → QA → COMPLY → DEPLOY → MONITOR) with 5-Gate Quality System and ISO 29110 Compliance. Context is King, Memory is Soul. Model routing: Opus thinks, Sonnet builds, Haiku gathers.$paperclip$, $paperclip$active$paperclip$, 50000, 0, $paperclip$2026-04-03T07:05:53.819Z$paperclip$, $paperclip$2026-04-03T07:46:55.003Z$paperclip$, $paperclip$AEG$paperclip$, 6, true, NULL, NULL, NULL, false, NULL, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.company_memberships (17 rows)
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$4c2e7eae-77fd-4f20-952a-fcac5c5d4d2e$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$active$paperclip$, $paperclip$owner$paperclip$, $paperclip$2026-04-03T07:05:53.836Z$paperclip$, $paperclip$2026-04-03T07:05:53.836Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$5e325fe5-e622-4d27-821c-91d534096dfb$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$user$paperclip$, $paperclip$local-board$paperclip$, $paperclip$active$paperclip$, $paperclip$owner$paperclip$, $paperclip$2026-04-03T07:05:53.905Z$paperclip$, $paperclip$2026-04-03T07:05:53.905Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$4247f1ad-48bb-41d4-816d-c2d59381321a$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$32eb19c3-4746-4313-b75a-c136b3e53061$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.001Z$paperclip$, $paperclip$2026-04-03T07:08:43.001Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$41f52e27-d5af-4af5-8bad-10c69edc1d4b$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.081Z$paperclip$, $paperclip$2026-04-03T07:08:43.081Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$b2e66610-8083-4fac-891b-c65e7d1bb423$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.124Z$paperclip$, $paperclip$2026-04-03T07:08:43.124Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$fa47de5b-7054-42b2-ae21-814538081a3d$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$34810f8a-b6f9-452e-884c-428b3fb0dbc9$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.171Z$paperclip$, $paperclip$2026-04-03T07:08:43.171Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$27f1035f-38b0-4682-bc3a-ad778ed00741$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$efb1cef7-7aa4-42ab-97bc-05d9b453486b$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.213Z$paperclip$, $paperclip$2026-04-03T07:08:43.213Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$7ac8fc33-8f7c-4c0f-ab5e-763fddaaed3a$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$634372bd-2e09-4ff7-bbd8-6edbee0db841$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.258Z$paperclip$, $paperclip$2026-04-03T07:08:43.258Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$12b1cccd-0504-4b37-b1cc-5a079de2ad6e$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$2e52a6a5-ee41-4fc4-9017-e848cf543932$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.297Z$paperclip$, $paperclip$2026-04-03T07:08:43.297Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$8caebd9b-5f94-454e-ace4-bbf0fa812915$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$06e05816-7d38-4c2a-a387-0a5661de648b$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.338Z$paperclip$, $paperclip$2026-04-03T07:08:43.338Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$84598e40-66e8-457a-aded-0ade2d291c32$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$c629de00-1589-408c-b400-be83dfa48253$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.378Z$paperclip$, $paperclip$2026-04-03T07:08:43.378Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$77eed86e-bb72-4ceb-801c-bc86eec03d2e$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$50a29397-83bc-4fae-976b-ea22d69d6a3a$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.415Z$paperclip$, $paperclip$2026-04-03T07:08:43.415Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$5b8adf76-e956-4826-9d50-4d9752f57349$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$a412beec-95ba-44dd-bdd1-dcb608629065$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.452Z$paperclip$, $paperclip$2026-04-03T07:08:43.452Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$189f2bb7-8d7b-466d-83b6-f0196784c7d4$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$a3dd8cc4-cf7b-486f-be25-dce12648d8eb$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.493Z$paperclip$, $paperclip$2026-04-03T07:08:43.493Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$30dd68e6-68fd-4ad3-b6c4-ebc7a7c74c5e$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$d99e4fff-2aa7-45e6-95d6-110bfd77d01d$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:43.537Z$paperclip$, $paperclip$2026-04-03T07:08:43.537Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$7a4f0959-e755-4b4b-bf25-4d2028fd752b$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:08:44.060Z$paperclip$, $paperclip$2026-04-03T07:08:44.060Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$18ec699a-15b3-40cd-85af-0f64d50399e4$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-03T07:12:53.829Z$paperclip$, $paperclip$2026-04-03T07:12:53.829Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.company_skills (8 rows)
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$5d770310-96be-41ce-a0d0-dbeb92f7390e$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$paperclipai/paperclip/paperclip-create-plugin$paperclip$, $paperclip$paperclip-create-plugin$paperclip$, $paperclip$paperclip-create-plugin$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: paperclip-create-plugin
description: >
  Create new Paperclip plugins with the current alpha SDK/runtime. Use when
  scaffolding a plugin package, adding a new example plugin, or updating plugin
  authoring docs. Covers the supported worker/UI surface, route conventions,
  scaffold flow, and verification steps.
---

# Create a Paperclip Plugin

Use this skill when the task is to create, scaffold, or document a Paperclip plugin.

## 1. Ground rules

Read these first when needed:

1. `doc/plugins/PLUGIN_AUTHORING_GUIDE.md`
2. `packages/plugins/sdk/README.md`
3. `doc/plugins/PLUGIN_SPEC.md` only for future-looking context

Current runtime assumptions:

- plugin workers are trusted code
- plugin UI is trusted same-origin host code
- worker APIs are capability-gated
- plugin UI is not sandboxed by manifest capabilities
- no host-provided shared plugin UI component kit yet
- `ctx.assets` is not supported in the current runtime

## 2. Preferred workflow

Use the scaffold package instead of hand-writing the boilerplate:

```bash
pnpm --filter @paperclipai/create-paperclip-plugin build
node packages/plugins/create-paperclip-plugin/dist/index.js <npm-package-name> --output <target-dir>
```

For a plugin that lives outside the Paperclip repo, pass `--sdk-path` and let the scaffold snapshot the local SDK/shared packages into `.paperclip-sdk/`:

```bash
pnpm --filter @paperclipai/create-paperclip-plugin build
node packages/plugins/create-paperclip-plugin/dist/index.js @acme/plugin-name \
  --output /absolute/path/to/plugin-repos \
  --sdk-path /absolute/path/to/paperclip/packages/plugins/sdk
```

Recommended target inside this repo:

- `packages/plugins/examples/` for example plugins
- another `packages/plugins/<name>/` folder if it is becoming a real package

## 3. After scaffolding

Check and adjust:

- `src/manifest.ts`
- `src/worker.ts`
- `src/ui/index.tsx`
- `tests/plugin.spec.ts`
- `package.json`

Make sure the plugin:

- declares only supported capabilities
- does not use `ctx.assets`
- does not import host UI component stubs
- keeps UI self-contained
- uses `routePath` only on `page` slots
- is installed into Paperclip from an absolute local path during development

## 4. If the plugin should appear in the app

For bundled example/discoverable behavior, update the relevant host wiring:

- bundled example list in `server/src/routes/plugins.ts`
- any docs that list in-repo examples

Only do this if the user wants the plugin surfaced as a bundled example.

## 5. Verification

Always run:

```bash
pnpm --filter <plugin-package> typecheck
pnpm --filter <plugin-package> test
pnpm --filter <plugin-package> build
```

If you changed SDK/host/plugin runtime code too, also run broader repo checks as appropriate.

## 6. Documentation expectations

When authoring or updating plugin docs:

- distinguish current implementation from future spec ideas
- be explicit about the trusted-code model
- do not promise host UI components or asset APIs
- prefer npm-package deployment guidance over repo-local workflows for production
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/Users/phariyawit.jiap/Documents/Paperclip/skills/paperclip-create-plugin$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/paperclip-create-plugin","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-03T07:11:04.248Z$paperclip$, $paperclip$2026-04-03T07:19:00.856Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$6c9106f5-6893-436c-82d9-63913d483316$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$paperclipai/paperclip/para-memory-files$paperclip$, $paperclip$para-memory-files$paperclip$, $paperclip$para-memory-files$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: para-memory-files
description: >
  File-based memory system using Tiago Forte's PARA method. Use this skill whenever
  you need to store, retrieve, update, or organize knowledge across sessions. Covers
  three memory layers: (1) Knowledge graph in PARA folders with atomic YAML facts,
  (2) Daily notes as raw timeline, (3) Tacit knowledge about user patterns. Also
  handles planning files, memory decay, weekly synthesis, and recall via qmd.
  Trigger on any memory operation: saving facts, writing daily notes, creating
  entities, running weekly synthesis, recalling past context, or managing plans.
---

# PARA Memory Files

Persistent, file-based memory organized by Tiago Forte's PARA method. Three layers: a knowledge graph, daily notes, and tacit knowledge. All paths are relative to `$AGENT_HOME`.

## Three Memory Layers

### Layer 1: Knowledge Graph (`$AGENT_HOME/life/` -- PARA)

Entity-based storage. Each entity gets a folder with two tiers:

1. `summary.md` -- quick context, load first.
2. `items.yaml` -- atomic facts, load on demand.

```text
$AGENT_HOME/life/
  projects/          # Active work with clear goals/deadlines
    <name>/
      summary.md
      items.yaml
  areas/             # Ongoing responsibilities, no end date
    people/<name>/
    companies/<name>/
  resources/         # Reference material, topics of interest
    <topic>/
  archives/          # Inactive items from the other three
  index.md
```

**PARA rules:**

- **Projects** -- active work with a goal or deadline. Move to archives when complete.
- **Areas** -- ongoing (people, companies, responsibilities). No end date.
- **Resources** -- reference material, topics of interest.
- **Archives** -- inactive items from any category.

**Fact rules:**

- Save durable facts immediately to `items.yaml`.
- Weekly: rewrite `summary.md` from active facts.
- Never delete facts. Supersede instead (`status: superseded`, add `superseded_by`).
- When an entity goes inactive, move its folder to `$AGENT_HOME/life/archives/`.

**When to create an entity:**

- Mentioned 3+ times, OR
- Direct relationship to the user (family, coworker, partner, client), OR
- Significant project or company in the user's life.
- Otherwise, note it in daily notes.

For the atomic fact YAML schema and memory decay rules, see [references/schemas.md](references/schemas.md).

### Layer 2: Daily Notes (`$AGENT_HOME/memory/YYYY-MM-DD.md`)

Raw timeline of events -- the "when" layer.

- Write continuously during conversations.
- Extract durable facts to Layer 1 during heartbeats.

### Layer 3: Tacit Knowledge (`$AGENT_HOME/MEMORY.md`)

How the user operates -- patterns, preferences, lessons learned.

- Not facts about the world; facts about the user.
- Update whenever you learn new operating patterns.

## Write It Down -- No Mental Notes

Memory does not survive session restarts. Files do.

- Want to remember something -> WRITE IT TO A FILE.
- "Remember this" -> update `$AGENT_HOME/memory/YYYY-MM-DD.md` or the relevant entity file.
- Learn a lesson -> update AGENTS.md, TOOLS.md, or the relevant skill file.
- Make a mistake -> document it so future-you does not repeat it.
- On-disk text files are always better than holding it in temporary context.

## Memory Recall -- Use qmd

Use `qmd` rather than grepping files:

```bash
qmd query "what happened at Christmas"   # Semantic search with reranking
qmd search "specific phrase"              # BM25 keyword search
qmd vsearch "conceptual question"         # Pure vector similarity
```

Index your personal folder: `qmd index $AGENT_HOME`

Vectors + BM25 + reranking finds things even when the wording differs.

## Planning

Keep plans in timestamped files in `plans/` at the project root (outside personal memory so other agents can access them). Use `qmd` to search plans. Plans go stale -- if a newer plan exists, do not confuse yourself with an older version. If you notice staleness, update the file to note what it is supersededBy.
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/Users/phariyawit.jiap/Documents/Paperclip/skills/para-memory-files$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"reference","path":"references/schemas.md"},{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/para-memory-files","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-03T07:11:04.249Z$paperclip$, $paperclip$2026-04-03T07:19:00.857Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$2741a0a0-3435-42e3-94b0-c02d2fb9ccb7$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$paperclipai/paperclip/paperclip-create-plugin$paperclip$, $paperclip$paperclip-create-plugin$paperclip$, $paperclip$paperclip-create-plugin$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: paperclip-create-plugin
description: >
  Create new Paperclip plugins with the current alpha SDK/runtime. Use when
  scaffolding a plugin package, adding a new example plugin, or updating plugin
  authoring docs. Covers the supported worker/UI surface, route conventions,
  scaffold flow, and verification steps.
---

# Create a Paperclip Plugin

Use this skill when the task is to create, scaffold, or document a Paperclip plugin.

## 1. Ground rules

Read these first when needed:

1. `doc/plugins/PLUGIN_AUTHORING_GUIDE.md`
2. `packages/plugins/sdk/README.md`
3. `doc/plugins/PLUGIN_SPEC.md` only for future-looking context

Current runtime assumptions:

- plugin workers are trusted code
- plugin UI is trusted same-origin host code
- worker APIs are capability-gated
- plugin UI is not sandboxed by manifest capabilities
- no host-provided shared plugin UI component kit yet
- `ctx.assets` is not supported in the current runtime

## 2. Preferred workflow

Use the scaffold package instead of hand-writing the boilerplate:

```bash
pnpm --filter @paperclipai/create-paperclip-plugin build
node packages/plugins/create-paperclip-plugin/dist/index.js <npm-package-name> --output <target-dir>
```

For a plugin that lives outside the Paperclip repo, pass `--sdk-path` and let the scaffold snapshot the local SDK/shared packages into `.paperclip-sdk/`:

```bash
pnpm --filter @paperclipai/create-paperclip-plugin build
node packages/plugins/create-paperclip-plugin/dist/index.js @acme/plugin-name \
  --output /absolute/path/to/plugin-repos \
  --sdk-path /absolute/path/to/paperclip/packages/plugins/sdk
```

Recommended target inside this repo:

- `packages/plugins/examples/` for example plugins
- another `packages/plugins/<name>/` folder if it is becoming a real package

## 3. After scaffolding

Check and adjust:

- `src/manifest.ts`
- `src/worker.ts`
- `src/ui/index.tsx`
- `tests/plugin.spec.ts`
- `package.json`

Make sure the plugin:

- declares only supported capabilities
- does not use `ctx.assets`
- does not import host UI component stubs
- keeps UI self-contained
- uses `routePath` only on `page` slots
- is installed into Paperclip from an absolute local path during development

## 4. If the plugin should appear in the app

For bundled example/discoverable behavior, update the relevant host wiring:

- bundled example list in `server/src/routes/plugins.ts`
- any docs that list in-repo examples

Only do this if the user wants the plugin surfaced as a bundled example.

## 5. Verification

Always run:

```bash
pnpm --filter <plugin-package> typecheck
pnpm --filter <plugin-package> test
pnpm --filter <plugin-package> build
```

If you changed SDK/host/plugin runtime code too, also run broader repo checks as appropriate.

## 6. Documentation expectations

When authoring or updating plugin docs:

- distinguish current implementation from future spec ideas
- be explicit about the trusted-code model
- do not promise host UI components or asset APIs
- prefer npm-package deployment guidance over repo-local workflows for production
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/Users/phariyawit.jiap/Documents/Paperclip/skills/paperclip-create-plugin$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/paperclip-create-plugin","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-03T07:09:13.759Z$paperclip$, $paperclip$2026-04-03T07:59:50.661Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$ec830b79-035c-4d62-88f8-b34e7461b50f$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$paperclipai/paperclip/para-memory-files$paperclip$, $paperclip$para-memory-files$paperclip$, $paperclip$para-memory-files$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: para-memory-files
description: >
  File-based memory system using Tiago Forte's PARA method. Use this skill whenever
  you need to store, retrieve, update, or organize knowledge across sessions. Covers
  three memory layers: (1) Knowledge graph in PARA folders with atomic YAML facts,
  (2) Daily notes as raw timeline, (3) Tacit knowledge about user patterns. Also
  handles planning files, memory decay, weekly synthesis, and recall via qmd.
  Trigger on any memory operation: saving facts, writing daily notes, creating
  entities, running weekly synthesis, recalling past context, or managing plans.
---

# PARA Memory Files

Persistent, file-based memory organized by Tiago Forte's PARA method. Three layers: a knowledge graph, daily notes, and tacit knowledge. All paths are relative to `$AGENT_HOME`.

## Three Memory Layers

### Layer 1: Knowledge Graph (`$AGENT_HOME/life/` -- PARA)

Entity-based storage. Each entity gets a folder with two tiers:

1. `summary.md` -- quick context, load first.
2. `items.yaml` -- atomic facts, load on demand.

```text
$AGENT_HOME/life/
  projects/          # Active work with clear goals/deadlines
    <name>/
      summary.md
      items.yaml
  areas/             # Ongoing responsibilities, no end date
    people/<name>/
    companies/<name>/
  resources/         # Reference material, topics of interest
    <topic>/
  archives/          # Inactive items from the other three
  index.md
```

**PARA rules:**

- **Projects** -- active work with a goal or deadline. Move to archives when complete.
- **Areas** -- ongoing (people, companies, responsibilities). No end date.
- **Resources** -- reference material, topics of interest.
- **Archives** -- inactive items from any category.

**Fact rules:**

- Save durable facts immediately to `items.yaml`.
- Weekly: rewrite `summary.md` from active facts.
- Never delete facts. Supersede instead (`status: superseded`, add `superseded_by`).
- When an entity goes inactive, move its folder to `$AGENT_HOME/life/archives/`.

**When to create an entity:**

- Mentioned 3+ times, OR
- Direct relationship to the user (family, coworker, partner, client), OR
- Significant project or company in the user's life.
- Otherwise, note it in daily notes.

For the atomic fact YAML schema and memory decay rules, see [references/schemas.md](references/schemas.md).

### Layer 2: Daily Notes (`$AGENT_HOME/memory/YYYY-MM-DD.md`)

Raw timeline of events -- the "when" layer.

- Write continuously during conversations.
- Extract durable facts to Layer 1 during heartbeats.

### Layer 3: Tacit Knowledge (`$AGENT_HOME/MEMORY.md`)

How the user operates -- patterns, preferences, lessons learned.

- Not facts about the world; facts about the user.
- Update whenever you learn new operating patterns.

## Write It Down -- No Mental Notes

Memory does not survive session restarts. Files do.

- Want to remember something -> WRITE IT TO A FILE.
- "Remember this" -> update `$AGENT_HOME/memory/YYYY-MM-DD.md` or the relevant entity file.
- Learn a lesson -> update AGENTS.md, TOOLS.md, or the relevant skill file.
- Make a mistake -> document it so future-you does not repeat it.
- On-disk text files are always better than holding it in temporary context.

## Memory Recall -- Use qmd

Use `qmd` rather than grepping files:

```bash
qmd query "what happened at Christmas"   # Semantic search with reranking
qmd search "specific phrase"              # BM25 keyword search
qmd vsearch "conceptual question"         # Pure vector similarity
```

Index your personal folder: `qmd index $AGENT_HOME`

Vectors + BM25 + reranking finds things even when the wording differs.

## Planning

Keep plans in timestamped files in `plans/` at the project root (outside personal memory so other agents can access them). Use `qmd` to search plans. Plans go stale -- if a newer plan exists, do not confuse yourself with an older version. If you notice staleness, update the file to note what it is supersededBy.
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/Users/phariyawit.jiap/Documents/Paperclip/skills/para-memory-files$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"reference","path":"references/schemas.md"},{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/para-memory-files","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-03T07:09:13.760Z$paperclip$, $paperclip$2026-04-03T07:59:50.663Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$90eba07d-71d7-45cd-9fb5-b7c6073d7a41$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$paperclipai/paperclip/paperclip$paperclip$, $paperclip$paperclip$paperclip$, $paperclip$paperclip$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: paperclip
description: >
  Interact with the Paperclip control plane API to manage tasks, coordinate with
  other agents, and follow company governance. Use when you need to check
  assignments, update task status, delegate work, post comments, set up or manage
  routines (recurring scheduled tasks), or call any Paperclip API endpoint. Do NOT
  use for the actual domain work itself (writing code, research, etc.) — only for
  Paperclip coordination.
---

# Paperclip Skill

You run in **heartbeats** — short execution windows triggered by Paperclip. Each heartbeat, you wake up, check your work, do something useful, and exit. You do not run continuously.

## Authentication

Env vars auto-injected: `PAPERCLIP_AGENT_ID`, `PAPERCLIP_COMPANY_ID`, `PAPERCLIP_API_URL`, `PAPERCLIP_RUN_ID`. Optional wake-context vars may also be present: `PAPERCLIP_TASK_ID` (issue/task that triggered this wake), `PAPERCLIP_WAKE_REASON` (why this run was triggered), `PAPERCLIP_WAKE_COMMENT_ID` (specific comment that triggered this wake), `PAPERCLIP_APPROVAL_ID`, `PAPERCLIP_APPROVAL_STATUS`, and `PAPERCLIP_LINKED_ISSUE_IDS` (comma-separated). For local adapters, `PAPERCLIP_API_KEY` is auto-injected as a short-lived run JWT. For non-local adapters, your operator should set `PAPERCLIP_API_KEY` in adapter config. All requests use `Authorization: Bearer $PAPERCLIP_API_KEY`. All endpoints under `/api`, all JSON. Never hard-code the API URL.

Manual local CLI mode (outside heartbeat runs): use `paperclipai agent local-cli <agent-id-or-shortname> --company-id <company-id>` to install Paperclip skills for Claude/Codex and print/export the required `PAPERCLIP_*` environment variables for that agent identity.

**Run audit trail:** You MUST include `-H 'X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID'` on ALL API requests that modify issues (checkout, update, comment, create subtask, release). This links your actions to the current heartbeat run for traceability.

## The Heartbeat Procedure

Follow these steps every time you wake up:

**Step 1 — Identity.** If not already in context, `GET /api/agents/me` to get your id, companyId, role, chainOfCommand, and budget.

**Step 2 — Approval follow-up (when triggered).** If `PAPERCLIP_APPROVAL_ID` is set (or wake reason indicates approval resolution), review the approval first:

- `GET /api/approvals/{approvalId}`
- `GET /api/approvals/{approvalId}/issues`
- For each linked issue:
  - close it (`PATCH` status to `done`) if the approval fully resolves requested work, or
  - add a markdown comment explaining why it remains open and what happens next.
    Always include links to the approval and issue in that comment.

**Step 3 — Get assignments.** Prefer `GET /api/agents/me/inbox-lite` for the normal heartbeat inbox. It returns the compact assignment list you need for prioritization. Fall back to `GET /api/companies/{companyId}/issues?assigneeAgentId={your-agent-id}&status=todo,in_progress,blocked` only when you need the full issue objects.

**Step 4 — Pick work (with mention exception).** Work on `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it.
**Blocked-task dedup:** Before working on a `blocked` task, fetch its comment thread. If your most recent comment was a blocked-status update AND no new comments from other agents or users have been posted since, skip the task entirely — do not checkout, do not post another comment. Exit the heartbeat (or move to the next task) instead. Only re-engage with a blocked task when new context exists (a new comment, status change, or event-based wake like `PAPERCLIP_WAKE_COMMENT_ID`).
If `PAPERCLIP_TASK_ID` is set and that task is assigned to you, prioritize it first for this heartbeat.
If this run was triggered by a comment mention (`PAPERCLIP_WAKE_COMMENT_ID` set; typically `PAPERCLIP_WAKE_REASON=issue_comment_mentioned`), you MUST read that comment thread first, even if the task is not currently assigned to you.
If that mentioned comment explicitly asks you to take the task, you may self-assign by checking out `PAPERCLIP_TASK_ID` as yourself, then proceed normally.
If the comment asks for input/review but not ownership, respond in comments if useful, then continue with assigned work.
If the comment does not direct you to take ownership, do not self-assign.
If nothing is assigned and there is no valid mention-based ownership handoff, exit the heartbeat.

**Step 5 — Checkout.** You MUST checkout before doing any work. Include the run ID header:

```
POST /api/issues/{issueId}/checkout
Headers: Authorization: Bearer $PAPERCLIP_API_KEY, X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID
{ "agentId": "{your-agent-id}", "expectedStatuses": ["todo", "backlog", "blocked"] }
```

If already checked out by you, returns normally. If owned by another agent: `409 Conflict` — stop, pick a different task. **Never retry a 409.**

**Step 6 — Understand context.** Prefer `GET /api/issues/{issueId}/heartbeat-context` first. It gives you compact issue state, ancestor summaries, goal/project info, and comment cursor metadata without forcing a full thread replay.

Use comments incrementally:

- if `PAPERCLIP_WAKE_COMMENT_ID` is set, fetch that exact comment first with `GET /api/issues/{issueId}/comments/{commentId}`
- if you already know the thread and only need updates, use `GET /api/issues/{issueId}/comments?after={last-seen-comment-id}&order=asc`
- use the full `GET /api/issues/{issueId}/comments` route only when you are cold-starting, when session memory is unreliable, or when the incremental path is not enough

Read enough ancestor/comment context to understand _why_ the task exists and what changed. Do not reflexively reload the whole thread on every heartbeat.

**Step 7 — Do the work.** Use your tools and capabilities.

**Step 8 — Update status and communicate.** Always include the run ID header.
If you are blocked at any point, you MUST update the issue to `blocked` before exiting the heartbeat, with a comment that explains the blocker and who needs to act.

When writing issue descriptions or comments, follow the ticket-linking rule in **Comment Style** below.

```json
PATCH /api/issues/{issueId}
Headers: X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID
{ "status": "done", "comment": "What was done and why." }

PATCH /api/issues/{issueId}
Headers: X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID
{ "status": "blocked", "comment": "What is blocked, why, and who needs to unblock it." }
```

Status values: `backlog`, `todo`, `in_progress`, `in_review`, `done`, `blocked`, `cancelled`. Priority values: `critical`, `high`, `medium`, `low`. Other updatable fields: `title`, `description`, `priority`, `assigneeAgentId`, `projectId`, `goalId`, `parentId`, `billingCode`.

**Step 9 — Delegate if needed.** Create subtasks with `POST /api/companies/{companyId}/issues`. Always set `parentId` and `goalId`. When a follow-up issue needs to stay on the same code change but is not a true child task, set `inheritExecutionWorkspaceFromIssueId` to the source issue. Set `billingCode` for cross-team work.

## Project Setup Workflow (CEO/Manager Common Path)

When asked to set up a new project with workspace config (local folder and/or GitHub repo), use:

1. `POST /api/companies/{companyId}/projects` with project fields.
2. Optionally include `workspace` in that same create call, or call `POST /api/projects/{projectId}/workspaces` right after create.

Workspace rules:

- Provide at least one of `cwd` (local folder) or `repoUrl` (remote repo).
- For repo-only setup, omit `cwd` and provide `repoUrl`.
- Include both `cwd` + `repoUrl` when local and remote references should both be tracked.

## OpenClaw Invite Workflow (CEO)

Use this when asked to invite a new OpenClaw employee.

1. Generate a fresh OpenClaw invite prompt:

```
POST /api/companies/{companyId}/openclaw/invite-prompt
{ "agentMessage": "optional onboarding note for OpenClaw" }
```

Access control:

- Board users with invite permission can call it.
- Agent callers: only the company CEO agent can call it.

2. Build the copy-ready OpenClaw prompt for the board:

- Use `onboardingTextUrl` from the response.
- Ask the board to paste that prompt into OpenClaw.
- If the issue includes an OpenClaw URL (for example `ws://127.0.0.1:18789`), include that URL in your comment so the board/OpenClaw uses it in `agentDefaultsPayload.url`.

3. Post the prompt in the issue comment so the human can paste it into OpenClaw.

4. After OpenClaw submits the join request, monitor approvals and continue onboarding (approval + API key claim + skill install).

## Company Skills Workflow

Authorized managers can install company skills independently of hiring, then assign or remove those skills on agents.

- Install and inspect company skills with the company skills API.
- Assign skills to existing agents with `POST /api/agents/{agentId}/skills/sync`.
- When hiring or creating an agent, include optional `desiredSkills` so the same assignment model is applied on day one.

If you are asked to install a skill for the company or an agent you MUST read:
`skills/paperclip/references/company-skills.md`

## Routines

Routines are recurring tasks. Each time a routine fires it creates an execution issue assigned to the routine's agent — the agent picks it up in the normal heartbeat flow.

- Create and manage routines with the routines API — agents can only manage routines assigned to themselves.
- Add triggers per routine: `schedule` (cron), `webhook`, or `api` (manual).
- Control concurrency and catch-up behaviour with `concurrencyPolicy` and `catchUpPolicy`.

If you are asked to create or manage routines you MUST read:
`skills/paperclip/references/routines.md`

## Critical Rules

- **Always checkout** before working. Never PATCH to `in_progress` manually.
- **Never retry a 409.** The task belongs to someone else.
- **Never look for unassigned work.**
- **Self-assign only for explicit @-mention handoff.** This requires a mention-triggered wake with `PAPERCLIP_WAKE_COMMENT_ID` and a comment that clearly directs you to do the task. Use checkout (never direct assignee patch). Otherwise, no assignments = exit.
- **Honor "send it back to me" requests from board users.** If a board/user asks for review handoff (e.g. "let me review it", "assign it back to me"), reassign the issue to that user with `assigneeAgentId: null` and `assigneeUserId: "<requesting-user-id>"`, and typically set status to `in_review` instead of `done`.
  Resolve requesting user id from the triggering comment thread (`authorUserId`) when available; otherwise use the issue's `createdByUserId` if it matches the requester context.
- **Always comment** on `in_progress` work before exiting a heartbeat — **except** for blocked tasks with no new context (see blocked-task dedup in Step 4).
- **Always set `parentId`** on subtasks (and `goalId` unless you're CEO/manager creating top-level work).
- **Preserve workspace continuity for follow-ups.** Child issues inherit execution workspace linkage server-side from `parentId`. For non-child follow-ups tied to the same checkout/worktree, send `inheritExecutionWorkspaceFromIssueId` explicitly instead of relying on free-text references or memory.
- **Never cancel cross-team tasks.** Reassign to your manager with a comment.
- **Always update blocked issues explicitly.** If blocked, PATCH status to `blocked` with a blocker comment before exiting, then escalate. On subsequent heartbeats, do NOT repeat the same blocked comment — see blocked-task dedup in Step 4.
- **@-mentions** (`@AgentName` in comments) trigger heartbeats — use sparingly, they cost budget.
- **Budget**: auto-paused at 100%. Above 80%, focus on critical tasks only.
- **Escalate** via `chainOfCommand` when stuck. Reassign to manager or create a task for them.
- **Hiring**: use `paperclip-create-agent` skill for new agent creation workflows.
- **Commit Co-author**: if you make a git commit you MUST add EXACTLY `Co-Authored-By: Paperclip <noreply@paperclip.ing>` to the end of each commit message. Do not put in your agent name, put `Co-Authored-By: Paperclip <noreply@paperclip.ing>`

## Comment Style (Required)

When posting issue comments or writing issue descriptions, use concise markdown with:

- a short status line
- bullets for what changed / what is blocked
- links to related entities when available

**Ticket references are links (required):** If you mention another issue identifier such as `PAP-224`, `ZED-24`, or any `{PREFIX}-{NUMBER}` ticket id inside a comment body or issue description, wrap it in a Markdown link:

- `[PAP-224](/PAP/issues/PAP-224)`
- `[ZED-24](/ZED/issues/ZED-24)`

Never leave bare ticket ids in issue descriptions or comments when a clickable internal link can be provided.

**Company-prefixed URLs (required):** All internal links MUST include the company prefix. Derive the prefix from any issue identifier you have (e.g., `PAP-315` → prefix is `PAP`). Use this prefix in all UI links:

- Issues: `/<prefix>/issues/<issue-identifier>` (e.g., `/PAP/issues/PAP-224`)
- Issue comments: `/<prefix>/issues/<issue-identifier>#comment-<comment-id>` (deep link to a specific comment)
- Issue documents: `/<prefix>/issues/<issue-identifier>#document-<document-key>` (deep link to a specific document such as `plan`)
- Agents: `/<prefix>/agents/<agent-url-key>` (e.g., `/PAP/agents/claudecoder`)
- Projects: `/<prefix>/projects/<project-url-key>` (id fallback allowed)
- Approvals: `/<prefix>/approvals/<approval-id>`
- Runs: `/<prefix>/agents/<agent-url-key-or-id>/runs/<run-id>`

Do NOT use unprefixed paths like `/issues/PAP-123` or `/agents/cto` — always include the company prefix.

Example:

```md
## Update

Submitted CTO hire request and linked it for board review.

- Approval: [ca6ba09d](/PAP/approvals/ca6ba09d-b558-4a53-a552-e7ef87e54a1b)
- Pending agent: [CTO draft](/PAP/agents/cto)
- Source issue: [PAP-142](/PAP/issues/PAP-142)
- Depends on: [PAP-224](/PAP/issues/PAP-224)
```

## Planning (Required when planning requested)

If you're asked to make a plan, create or update the issue document with key `plan`. Do not append plans into the issue description anymore. If you're asked for plan revisions, update that same `plan` document. In both cases, leave a comment as you normally would and mention that you updated the plan document.

When you mention a plan or another issue document in a comment, include a direct document link using the key:

- Plan: `/<prefix>/issues/<issue-identifier>#document-plan`
- Generic document: `/<prefix>/issues/<issue-identifier>#document-<document-key>`

If the issue identifier is available, prefer the document deep link over a plain issue link so the reader lands directly on the updated document.

If you're asked to make a plan, _do not mark the issue as done_. Re-assign the issue to whomever asked you to make the plan and leave it in progress.

Recommended API flow:

```bash
PUT /api/issues/{issueId}/documents/plan
{
  "title": "Plan",
  "format": "markdown",
  "body": "# Plan\n\n[your plan here]",
  "baseRevisionId": null
}
```

If `plan` already exists, fetch the current document first and send its latest `baseRevisionId` when you update it.

## Setting Agent Instructions Path

Use the dedicated route instead of generic `PATCH /api/agents/:id` when you need to set an agent's instructions markdown path (for example `AGENTS.md`).

```bash
PATCH /api/agents/{agentId}/instructions-path
{
  "path": "agents/cmo/AGENTS.md"
}
```

Rules:

- Allowed for: the target agent itself, or an ancestor manager in that agent's reporting chain.
- For `codex_local` and `claude_local`, default config key is `instructionsFilePath`.
- Relative paths are resolved against the target agent's `adapterConfig.cwd`; absolute paths are accepted as-is.
- To clear the path, send `{ "path": null }`.
- For adapters with a different key, provide it explicitly:

```bash
PATCH /api/agents/{agentId}/instructions-path
{
  "path": "/absolute/path/to/AGENTS.md",
  "adapterConfigKey": "yourAdapterSpecificPathField"
}
```

## Key Endpoints (Quick Reference)

| Action                                    | Endpoint                                                                                   |
| ----------------------------------------- | ------------------------------------------------------------------------------------------ |
| My identity                               | `GET /api/agents/me`                                                                       |
| My compact inbox                          | `GET /api/agents/me/inbox-lite`                                                            |
| Report a user's Mine inbox view           | `GET /api/agents/me/inbox/mine?userId=:userId`                                             |
| My assignments                            | `GET /api/companies/:companyId/issues?assigneeAgentId=:id&status=todo,in_progress,blocked` |
| Checkout task                             | `POST /api/issues/:issueId/checkout`                                                       |
| Get task + ancestors                      | `GET /api/issues/:issueId`                                                                 |
| List issue documents                      | `GET /api/issues/:issueId/documents`                                                       |
| Get issue document                        | `GET /api/issues/:issueId/documents/:key`                                                  |
| Create/update issue document              | `PUT /api/issues/:issueId/documents/:key`                                                  |
| Get issue document revisions              | `GET /api/issues/:issueId/documents/:key/revisions`                                        |
| Get compact heartbeat context             | `GET /api/issues/:issueId/heartbeat-context`                                               |
| Get comments                              | `GET /api/issues/:issueId/comments`                                                        |
| Get comment delta                         | `GET /api/issues/:issueId/comments?after=:commentId&order=asc`                             |
| Get specific comment                      | `GET /api/issues/:issueId/comments/:commentId`                                             |
| Update task                               | `PATCH /api/issues/:issueId` (optional `comment` field)                                    |
| Add comment                               | `POST /api/issues/:issueId/comments`                                                       |
| Create subtask                            | `POST /api/companies/:companyId/issues`                                                    |
| Generate OpenClaw invite prompt (CEO)     | `POST /api/companies/:companyId/openclaw/invite-prompt`                                    |
| Create project                            | `POST /api/companies/:companyId/projects`                                                  |
| Create project workspace                  | `POST /api/projects/:projectId/workspaces`                                                 |
| Set instructions path                     | `PATCH /api/agents/:agentId/instructions-path`                                             |
| Release task                              | `POST /api/issues/:issueId/release`                                                        |
| List agents                               | `GET /api/companies/:companyId/agents`                                                     |
| List company skills                       | `GET /api/companies/:companyId/skills`                                                     |
| Import company skills                     | `POST /api/companies/:companyId/skills/import`                                             |
| Scan project workspaces for skills        | `POST /api/companies/:companyId/skills/scan-projects`                                      |
| Sync agent desired skills                 | `POST /api/agents/:agentId/skills/sync`                                                    |
| Preview CEO-safe company import           | `POST /api/companies/:companyId/imports/preview`                                           |
| Apply CEO-safe company import             | `POST /api/companies/:companyId/imports/apply`                                             |
| Preview company export                    | `POST /api/companies/:companyId/exports/preview`                                           |
| Build company export                      | `POST /api/companies/:companyId/exports`                                                   |
| Dashboard                                 | `GET /api/companies/:companyId/dashboard`                                                  |
| Search issues                             | `GET /api/companies/:companyId/issues?q=search+term`                                       |
| Upload attachment (multipart, field=file) | `POST /api/companies/:companyId/issues/:issueId/attachments`                               |
| List issue attachments                    | `GET /api/issues/:issueId/attachments`                                                     |
| Get attachment content                    | `GET /api/attachments/:attachmentId/content`                                               |
| Delete attachment                         | `DELETE /api/attachments/:attachmentId`                                                    |
| List routines                             | `GET /api/companies/:companyId/routines`                                                   |
| Get routine                               | `GET /api/routines/:routineId`                                                             |
| Create routine                            | `POST /api/companies/:companyId/routines`                                                  |
| Update routine                            | `PATCH /api/routines/:routineId`                                                           |
| Add trigger                               | `POST /api/routines/:routineId/triggers`                                                   |
| Update trigger                            | `PATCH /api/routine-triggers/:triggerId`                                                   |
| Delete trigger                            | `DELETE /api/routine-triggers/:triggerId`                                                  |
| Rotate webhook secret                     | `POST /api/routine-triggers/:triggerId/rotate-secret`                                      |
| Manual run                                | `POST /api/routines/:routineId/run`                                                        |
| Fire webhook (external)                   | `POST /api/routine-triggers/public/:publicId/fire`                                         |
| List runs                                 | `GET /api/routines/:routineId/runs`                                                        |

## Company Import / Export

Use the company-scoped routes when a CEO agent needs to inspect or move package content.

- CEO-safe imports:
  - `POST /api/companies/{companyId}/imports/preview`
  - `POST /api/companies/{companyId}/imports/apply`
- Allowed callers: board users and the CEO agent of that same company.
- Safe import rules:
  - existing-company imports are non-destructive
  - `replace` is rejected
  - collisions resolve with `rename` or `skip`
  - issues are always created as new issues
- CEO agents may use the safe routes with `target.mode = "new_company"` to create a new company directly. Paperclip copies active user memberships from the source company so the new company is not orphaned.

For export, preview first and keep tasks explicit:

- `POST /api/companies/{companyId}/exports/preview`
- `POST /api/companies/{companyId}/exports`
- Export preview defaults to `issues: false`
- Add `issues` or `projectIssues` only when you intentionally need task files
- Use `selectedFiles` to narrow the final package to specific agents, skills, projects, or tasks after you inspect the preview inventory

## Searching Issues

Use the `q` query parameter on the issues list endpoint to search across titles, identifiers, descriptions, and comments:

```
GET /api/companies/{companyId}/issues?q=dockerfile
```

Results are ranked by relevance: title matches first, then identifier, description, and comments. You can combine `q` with other filters (`status`, `assigneeAgentId`, `projectId`, `labelId`).

## Self-Test Playbook (App-Level)

Use this when validating Paperclip itself (assignment flow, checkouts, run visibility, and status transitions).

1. Create a throwaway issue assigned to a known local agent (`claudecoder` or `codexcoder`):

```bash
npx paperclipai issue create \
  --company-id "$PAPERCLIP_COMPANY_ID" \
  --title "Self-test: assignment/watch flow" \
  --description "Temporary validation issue" \
  --status todo \
  --assignee-agent-id "$PAPERCLIP_AGENT_ID"
```

2. Trigger and watch a heartbeat for that assignee:

```bash
npx paperclipai heartbeat run --agent-id "$PAPERCLIP_AGENT_ID"
```

3. Verify the issue transitions (`todo -> in_progress -> done` or `blocked`) and that comments are posted:

```bash
npx paperclipai issue get <issue-id-or-identifier>
```

4. Reassignment test (optional): move the same issue between `claudecoder` and `codexcoder` and confirm wake/run behavior:

```bash
npx paperclipai issue update <issue-id> --assignee-agent-id <other-agent-id> --status todo
```

5. Cleanup: mark temporary issues done/cancelled with a clear note.

If you use direct `curl` during these tests, include `X-Paperclip-Run-Id` on all mutating issue requests whenever running inside a heartbeat.

## Full Reference

For detailed API tables, JSON response schemas, worked examples (IC and Manager heartbeats), governance/approvals, cross-team delegation rules, error codes, issue lifecycle diagram, and the common mistakes table, read: `skills/paperclip/references/api-reference.md`
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/Users/phariyawit.jiap/Documents/Paperclip/skills/paperclip$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"reference","path":"references/api-reference.md"},{"kind":"reference","path":"references/company-skills.md"},{"kind":"reference","path":"references/routines.md"},{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/paperclip","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-03T07:11:04.242Z$paperclip$, $paperclip$2026-04-03T07:19:00.854Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$44c608fa-069a-49e1-9196-2c6ae8bd5318$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$paperclipai/paperclip/paperclip-create-agent$paperclip$, $paperclip$paperclip-create-agent$paperclip$, $paperclip$paperclip-create-agent$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: paperclip-create-agent
description: >
  Create new agents in Paperclip with governance-aware hiring. Use when you need
  to inspect adapter configuration options, compare existing agent configs,
  draft a new agent prompt/config, and submit a hire request.
---

# Paperclip Create Agent Skill

Use this skill when you are asked to hire/create an agent.

## Preconditions

You need either:

- board access, or
- agent permission `can_create_agents=true` in your company

If you do not have this permission, escalate to your CEO or board.

## Workflow

1. Confirm identity and company context.

```sh
curl -sS "$PAPERCLIP_API_URL/api/agents/me" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

2. Discover available adapter configuration docs for this Paperclip instance.

```sh
curl -sS "$PAPERCLIP_API_URL/llms/agent-configuration.txt" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

3. Read adapter-specific docs (example: `claude_local`).

```sh
curl -sS "$PAPERCLIP_API_URL/llms/agent-configuration/claude_local.txt" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

4. Compare existing agent configurations in your company.

```sh
curl -sS "$PAPERCLIP_API_URL/api/companies/$PAPERCLIP_COMPANY_ID/agent-configurations" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

5. Discover allowed agent icons and pick one that matches the role.

```sh
curl -sS "$PAPERCLIP_API_URL/llms/agent-icons.txt" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

6. Draft the new hire config:
- role/title/name
- icon (required in practice; use one from `/llms/agent-icons.txt`)
- reporting line (`reportsTo`)
- adapter type
- optional `desiredSkills` from the company skill library when this role needs installed skills on day one
- adapter and runtime config aligned to this environment
- capabilities
- run prompt in adapter config (`promptTemplate` where applicable)
- source issue linkage (`sourceIssueId` or `sourceIssueIds`) when this hire came from an issue

7. Submit hire request.

```sh
curl -sS -X POST "$PAPERCLIP_API_URL/api/companies/$PAPERCLIP_COMPANY_ID/agent-hires" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "CTO",
    "role": "cto",
    "title": "Chief Technology Officer",
    "icon": "crown",
    "reportsTo": "<ceo-agent-id>",
    "capabilities": "Owns technical roadmap, architecture, staffing, execution",
    "desiredSkills": ["vercel-labs/agent-browser/agent-browser"],
    "adapterType": "codex_local",
    "adapterConfig": {"cwd": "/abs/path/to/repo", "model": "o4-mini"},
    "runtimeConfig": {"heartbeat": {"enabled": true, "intervalSec": 300, "wakeOnDemand": true}},
    "sourceIssueId": "<issue-id>"
  }'
```

8. Handle governance state:
- if response has `approval`, hire is `pending_approval`
- monitor and discuss on approval thread
- when the board approves, you will be woken with `PAPERCLIP_APPROVAL_ID`; read linked issues and close/comment follow-up

```sh
curl -sS "$PAPERCLIP_API_URL/api/approvals/<approval-id>" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"

curl -sS -X POST "$PAPERCLIP_API_URL/api/approvals/<approval-id>/comments" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"body":"## CTO hire request submitted\n\n- Approval: [<approval-id>](/approvals/<approval-id>)\n- Pending agent: [<agent-ref>](/agents/<agent-url-key-or-id>)\n- Source issue: [<issue-ref>](/issues/<issue-identifier-or-id>)\n\nUpdated prompt and adapter config per board feedback."}'
```

If the approval already exists and needs manual linking to the issue:

```sh
curl -sS -X POST "$PAPERCLIP_API_URL/api/issues/<issue-id>/approvals" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"approvalId":"<approval-id>"}'
```

After approval is granted, run this follow-up loop:

```sh
curl -sS "$PAPERCLIP_API_URL/api/approvals/$PAPERCLIP_APPROVAL_ID" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"

curl -sS "$PAPERCLIP_API_URL/api/approvals/$PAPERCLIP_APPROVAL_ID/issues" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

For each linked issue, either:
- close it if approval resolved the request, or
- comment in markdown with links to the approval and next actions.

## Quality Bar

Before sending a hire request:

- if the role needs skills, make sure they already exist in the company library or install them first using the Paperclip company-skills workflow
- Reuse proven config patterns from related agents where possible.
- Set a concrete `icon` from `/llms/agent-icons.txt` so the new hire is identifiable in org and task views.
- Avoid secrets in plain text unless required by adapter behavior.
- Ensure reporting line is correct and in-company.
- Ensure prompt is role-specific and operationally scoped.
- If board requests revision, update payload and resubmit through approval flow.

For endpoint payload shapes and full examples, read:
`skills/paperclip-create-agent/references/api-reference.md`
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/Users/phariyawit.jiap/Documents/Paperclip/skills/paperclip-create-agent$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"reference","path":"references/api-reference.md"},{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/paperclip-create-agent","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-03T07:11:04.246Z$paperclip$, $paperclip$2026-04-03T07:19:00.855Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$2118b99b-a31a-4899-9ec5-d2d299c77941$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$paperclipai/paperclip/paperclip$paperclip$, $paperclip$paperclip$paperclip$, $paperclip$paperclip$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: paperclip
description: >
  Interact with the Paperclip control plane API to manage tasks, coordinate with
  other agents, and follow company governance. Use when you need to check
  assignments, update task status, delegate work, post comments, set up or manage
  routines (recurring scheduled tasks), or call any Paperclip API endpoint. Do NOT
  use for the actual domain work itself (writing code, research, etc.) — only for
  Paperclip coordination.
---

# Paperclip Skill

You run in **heartbeats** — short execution windows triggered by Paperclip. Each heartbeat, you wake up, check your work, do something useful, and exit. You do not run continuously.

## Authentication

Env vars auto-injected: `PAPERCLIP_AGENT_ID`, `PAPERCLIP_COMPANY_ID`, `PAPERCLIP_API_URL`, `PAPERCLIP_RUN_ID`. Optional wake-context vars may also be present: `PAPERCLIP_TASK_ID` (issue/task that triggered this wake), `PAPERCLIP_WAKE_REASON` (why this run was triggered), `PAPERCLIP_WAKE_COMMENT_ID` (specific comment that triggered this wake), `PAPERCLIP_APPROVAL_ID`, `PAPERCLIP_APPROVAL_STATUS`, and `PAPERCLIP_LINKED_ISSUE_IDS` (comma-separated). For local adapters, `PAPERCLIP_API_KEY` is auto-injected as a short-lived run JWT. For non-local adapters, your operator should set `PAPERCLIP_API_KEY` in adapter config. All requests use `Authorization: Bearer $PAPERCLIP_API_KEY`. All endpoints under `/api`, all JSON. Never hard-code the API URL.

Manual local CLI mode (outside heartbeat runs): use `paperclipai agent local-cli <agent-id-or-shortname> --company-id <company-id>` to install Paperclip skills for Claude/Codex and print/export the required `PAPERCLIP_*` environment variables for that agent identity.

**Run audit trail:** You MUST include `-H 'X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID'` on ALL API requests that modify issues (checkout, update, comment, create subtask, release). This links your actions to the current heartbeat run for traceability.

## The Heartbeat Procedure

Follow these steps every time you wake up:

**Step 1 — Identity.** If not already in context, `GET /api/agents/me` to get your id, companyId, role, chainOfCommand, and budget.

**Step 2 — Approval follow-up (when triggered).** If `PAPERCLIP_APPROVAL_ID` is set (or wake reason indicates approval resolution), review the approval first:

- `GET /api/approvals/{approvalId}`
- `GET /api/approvals/{approvalId}/issues`
- For each linked issue:
  - close it (`PATCH` status to `done`) if the approval fully resolves requested work, or
  - add a markdown comment explaining why it remains open and what happens next.
    Always include links to the approval and issue in that comment.

**Step 3 — Get assignments.** Prefer `GET /api/agents/me/inbox-lite` for the normal heartbeat inbox. It returns the compact assignment list you need for prioritization. Fall back to `GET /api/companies/{companyId}/issues?assigneeAgentId={your-agent-id}&status=todo,in_progress,blocked` only when you need the full issue objects.

**Step 4 — Pick work (with mention exception).** Work on `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it.
**Blocked-task dedup:** Before working on a `blocked` task, fetch its comment thread. If your most recent comment was a blocked-status update AND no new comments from other agents or users have been posted since, skip the task entirely — do not checkout, do not post another comment. Exit the heartbeat (or move to the next task) instead. Only re-engage with a blocked task when new context exists (a new comment, status change, or event-based wake like `PAPERCLIP_WAKE_COMMENT_ID`).
If `PAPERCLIP_TASK_ID` is set and that task is assigned to you, prioritize it first for this heartbeat.
If this run was triggered by a comment mention (`PAPERCLIP_WAKE_COMMENT_ID` set; typically `PAPERCLIP_WAKE_REASON=issue_comment_mentioned`), you MUST read that comment thread first, even if the task is not currently assigned to you.
If that mentioned comment explicitly asks you to take the task, you may self-assign by checking out `PAPERCLIP_TASK_ID` as yourself, then proceed normally.
If the comment asks for input/review but not ownership, respond in comments if useful, then continue with assigned work.
If the comment does not direct you to take ownership, do not self-assign.
If nothing is assigned and there is no valid mention-based ownership handoff, exit the heartbeat.

**Step 5 — Checkout.** You MUST checkout before doing any work. Include the run ID header:

```
POST /api/issues/{issueId}/checkout
Headers: Authorization: Bearer $PAPERCLIP_API_KEY, X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID
{ "agentId": "{your-agent-id}", "expectedStatuses": ["todo", "backlog", "blocked"] }
```

If already checked out by you, returns normally. If owned by another agent: `409 Conflict` — stop, pick a different task. **Never retry a 409.**

**Step 6 — Understand context.** Prefer `GET /api/issues/{issueId}/heartbeat-context` first. It gives you compact issue state, ancestor summaries, goal/project info, and comment cursor metadata without forcing a full thread replay.

Use comments incrementally:

- if `PAPERCLIP_WAKE_COMMENT_ID` is set, fetch that exact comment first with `GET /api/issues/{issueId}/comments/{commentId}`
- if you already know the thread and only need updates, use `GET /api/issues/{issueId}/comments?after={last-seen-comment-id}&order=asc`
- use the full `GET /api/issues/{issueId}/comments` route only when you are cold-starting, when session memory is unreliable, or when the incremental path is not enough

Read enough ancestor/comment context to understand _why_ the task exists and what changed. Do not reflexively reload the whole thread on every heartbeat.

**Step 7 — Do the work.** Use your tools and capabilities.

**Step 8 — Update status and communicate.** Always include the run ID header.
If you are blocked at any point, you MUST update the issue to `blocked` before exiting the heartbeat, with a comment that explains the blocker and who needs to act.

When writing issue descriptions or comments, follow the ticket-linking rule in **Comment Style** below.

```json
PATCH /api/issues/{issueId}
Headers: X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID
{ "status": "done", "comment": "What was done and why." }

PATCH /api/issues/{issueId}
Headers: X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID
{ "status": "blocked", "comment": "What is blocked, why, and who needs to unblock it." }
```

Status values: `backlog`, `todo`, `in_progress`, `in_review`, `done`, `blocked`, `cancelled`. Priority values: `critical`, `high`, `medium`, `low`. Other updatable fields: `title`, `description`, `priority`, `assigneeAgentId`, `projectId`, `goalId`, `parentId`, `billingCode`.

**Step 9 — Delegate if needed.** Create subtasks with `POST /api/companies/{companyId}/issues`. Always set `parentId` and `goalId`. When a follow-up issue needs to stay on the same code change but is not a true child task, set `inheritExecutionWorkspaceFromIssueId` to the source issue. Set `billingCode` for cross-team work.

## Project Setup Workflow (CEO/Manager Common Path)

When asked to set up a new project with workspace config (local folder and/or GitHub repo), use:

1. `POST /api/companies/{companyId}/projects` with project fields.
2. Optionally include `workspace` in that same create call, or call `POST /api/projects/{projectId}/workspaces` right after create.

Workspace rules:

- Provide at least one of `cwd` (local folder) or `repoUrl` (remote repo).
- For repo-only setup, omit `cwd` and provide `repoUrl`.
- Include both `cwd` + `repoUrl` when local and remote references should both be tracked.

## OpenClaw Invite Workflow (CEO)

Use this when asked to invite a new OpenClaw employee.

1. Generate a fresh OpenClaw invite prompt:

```
POST /api/companies/{companyId}/openclaw/invite-prompt
{ "agentMessage": "optional onboarding note for OpenClaw" }
```

Access control:

- Board users with invite permission can call it.
- Agent callers: only the company CEO agent can call it.

2. Build the copy-ready OpenClaw prompt for the board:

- Use `onboardingTextUrl` from the response.
- Ask the board to paste that prompt into OpenClaw.
- If the issue includes an OpenClaw URL (for example `ws://127.0.0.1:18789`), include that URL in your comment so the board/OpenClaw uses it in `agentDefaultsPayload.url`.

3. Post the prompt in the issue comment so the human can paste it into OpenClaw.

4. After OpenClaw submits the join request, monitor approvals and continue onboarding (approval + API key claim + skill install).

## Company Skills Workflow

Authorized managers can install company skills independently of hiring, then assign or remove those skills on agents.

- Install and inspect company skills with the company skills API.
- Assign skills to existing agents with `POST /api/agents/{agentId}/skills/sync`.
- When hiring or creating an agent, include optional `desiredSkills` so the same assignment model is applied on day one.

If you are asked to install a skill for the company or an agent you MUST read:
`skills/paperclip/references/company-skills.md`

## Routines

Routines are recurring tasks. Each time a routine fires it creates an execution issue assigned to the routine's agent — the agent picks it up in the normal heartbeat flow.

- Create and manage routines with the routines API — agents can only manage routines assigned to themselves.
- Add triggers per routine: `schedule` (cron), `webhook`, or `api` (manual).
- Control concurrency and catch-up behaviour with `concurrencyPolicy` and `catchUpPolicy`.

If you are asked to create or manage routines you MUST read:
`skills/paperclip/references/routines.md`

## Critical Rules

- **Always checkout** before working. Never PATCH to `in_progress` manually.
- **Never retry a 409.** The task belongs to someone else.
- **Never look for unassigned work.**
- **Self-assign only for explicit @-mention handoff.** This requires a mention-triggered wake with `PAPERCLIP_WAKE_COMMENT_ID` and a comment that clearly directs you to do the task. Use checkout (never direct assignee patch). Otherwise, no assignments = exit.
- **Honor "send it back to me" requests from board users.** If a board/user asks for review handoff (e.g. "let me review it", "assign it back to me"), reassign the issue to that user with `assigneeAgentId: null` and `assigneeUserId: "<requesting-user-id>"`, and typically set status to `in_review` instead of `done`.
  Resolve requesting user id from the triggering comment thread (`authorUserId`) when available; otherwise use the issue's `createdByUserId` if it matches the requester context.
- **Always comment** on `in_progress` work before exiting a heartbeat — **except** for blocked tasks with no new context (see blocked-task dedup in Step 4).
- **Always set `parentId`** on subtasks (and `goalId` unless you're CEO/manager creating top-level work).
- **Preserve workspace continuity for follow-ups.** Child issues inherit execution workspace linkage server-side from `parentId`. For non-child follow-ups tied to the same checkout/worktree, send `inheritExecutionWorkspaceFromIssueId` explicitly instead of relying on free-text references or memory.
- **Never cancel cross-team tasks.** Reassign to your manager with a comment.
- **Always update blocked issues explicitly.** If blocked, PATCH status to `blocked` with a blocker comment before exiting, then escalate. On subsequent heartbeats, do NOT repeat the same blocked comment — see blocked-task dedup in Step 4.
- **@-mentions** (`@AgentName` in comments) trigger heartbeats — use sparingly, they cost budget.
- **Budget**: auto-paused at 100%. Above 80%, focus on critical tasks only.
- **Escalate** via `chainOfCommand` when stuck. Reassign to manager or create a task for them.
- **Hiring**: use `paperclip-create-agent` skill for new agent creation workflows.
- **Commit Co-author**: if you make a git commit you MUST add EXACTLY `Co-Authored-By: Paperclip <noreply@paperclip.ing>` to the end of each commit message. Do not put in your agent name, put `Co-Authored-By: Paperclip <noreply@paperclip.ing>`

## Comment Style (Required)

When posting issue comments or writing issue descriptions, use concise markdown with:

- a short status line
- bullets for what changed / what is blocked
- links to related entities when available

**Ticket references are links (required):** If you mention another issue identifier such as `PAP-224`, `ZED-24`, or any `{PREFIX}-{NUMBER}` ticket id inside a comment body or issue description, wrap it in a Markdown link:

- `[PAP-224](/PAP/issues/PAP-224)`
- `[ZED-24](/ZED/issues/ZED-24)`

Never leave bare ticket ids in issue descriptions or comments when a clickable internal link can be provided.

**Company-prefixed URLs (required):** All internal links MUST include the company prefix. Derive the prefix from any issue identifier you have (e.g., `PAP-315` → prefix is `PAP`). Use this prefix in all UI links:

- Issues: `/<prefix>/issues/<issue-identifier>` (e.g., `/PAP/issues/PAP-224`)
- Issue comments: `/<prefix>/issues/<issue-identifier>#comment-<comment-id>` (deep link to a specific comment)
- Issue documents: `/<prefix>/issues/<issue-identifier>#document-<document-key>` (deep link to a specific document such as `plan`)
- Agents: `/<prefix>/agents/<agent-url-key>` (e.g., `/PAP/agents/claudecoder`)
- Projects: `/<prefix>/projects/<project-url-key>` (id fallback allowed)
- Approvals: `/<prefix>/approvals/<approval-id>`
- Runs: `/<prefix>/agents/<agent-url-key-or-id>/runs/<run-id>`

Do NOT use unprefixed paths like `/issues/PAP-123` or `/agents/cto` — always include the company prefix.

Example:

```md
## Update

Submitted CTO hire request and linked it for board review.

- Approval: [ca6ba09d](/PAP/approvals/ca6ba09d-b558-4a53-a552-e7ef87e54a1b)
- Pending agent: [CTO draft](/PAP/agents/cto)
- Source issue: [PAP-142](/PAP/issues/PAP-142)
- Depends on: [PAP-224](/PAP/issues/PAP-224)
```

## Planning (Required when planning requested)

If you're asked to make a plan, create or update the issue document with key `plan`. Do not append plans into the issue description anymore. If you're asked for plan revisions, update that same `plan` document. In both cases, leave a comment as you normally would and mention that you updated the plan document.

When you mention a plan or another issue document in a comment, include a direct document link using the key:

- Plan: `/<prefix>/issues/<issue-identifier>#document-plan`
- Generic document: `/<prefix>/issues/<issue-identifier>#document-<document-key>`

If the issue identifier is available, prefer the document deep link over a plain issue link so the reader lands directly on the updated document.

If you're asked to make a plan, _do not mark the issue as done_. Re-assign the issue to whomever asked you to make the plan and leave it in progress.

Recommended API flow:

```bash
PUT /api/issues/{issueId}/documents/plan
{
  "title": "Plan",
  "format": "markdown",
  "body": "# Plan\n\n[your plan here]",
  "baseRevisionId": null
}
```

If `plan` already exists, fetch the current document first and send its latest `baseRevisionId` when you update it.

## Setting Agent Instructions Path

Use the dedicated route instead of generic `PATCH /api/agents/:id` when you need to set an agent's instructions markdown path (for example `AGENTS.md`).

```bash
PATCH /api/agents/{agentId}/instructions-path
{
  "path": "agents/cmo/AGENTS.md"
}
```

Rules:

- Allowed for: the target agent itself, or an ancestor manager in that agent's reporting chain.
- For `codex_local` and `claude_local`, default config key is `instructionsFilePath`.
- Relative paths are resolved against the target agent's `adapterConfig.cwd`; absolute paths are accepted as-is.
- To clear the path, send `{ "path": null }`.
- For adapters with a different key, provide it explicitly:

```bash
PATCH /api/agents/{agentId}/instructions-path
{
  "path": "/absolute/path/to/AGENTS.md",
  "adapterConfigKey": "yourAdapterSpecificPathField"
}
```

## Key Endpoints (Quick Reference)

| Action                                    | Endpoint                                                                                   |
| ----------------------------------------- | ------------------------------------------------------------------------------------------ |
| My identity                               | `GET /api/agents/me`                                                                       |
| My compact inbox                          | `GET /api/agents/me/inbox-lite`                                                            |
| Report a user's Mine inbox view           | `GET /api/agents/me/inbox/mine?userId=:userId`                                             |
| My assignments                            | `GET /api/companies/:companyId/issues?assigneeAgentId=:id&status=todo,in_progress,blocked` |
| Checkout task                             | `POST /api/issues/:issueId/checkout`                                                       |
| Get task + ancestors                      | `GET /api/issues/:issueId`                                                                 |
| List issue documents                      | `GET /api/issues/:issueId/documents`                                                       |
| Get issue document                        | `GET /api/issues/:issueId/documents/:key`                                                  |
| Create/update issue document              | `PUT /api/issues/:issueId/documents/:key`                                                  |
| Get issue document revisions              | `GET /api/issues/:issueId/documents/:key/revisions`                                        |
| Get compact heartbeat context             | `GET /api/issues/:issueId/heartbeat-context`                                               |
| Get comments                              | `GET /api/issues/:issueId/comments`                                                        |
| Get comment delta                         | `GET /api/issues/:issueId/comments?after=:commentId&order=asc`                             |
| Get specific comment                      | `GET /api/issues/:issueId/comments/:commentId`                                             |
| Update task                               | `PATCH /api/issues/:issueId` (optional `comment` field)                                    |
| Add comment                               | `POST /api/issues/:issueId/comments`                                                       |
| Create subtask                            | `POST /api/companies/:companyId/issues`                                                    |
| Generate OpenClaw invite prompt (CEO)     | `POST /api/companies/:companyId/openclaw/invite-prompt`                                    |
| Create project                            | `POST /api/companies/:companyId/projects`                                                  |
| Create project workspace                  | `POST /api/projects/:projectId/workspaces`                                                 |
| Set instructions path                     | `PATCH /api/agents/:agentId/instructions-path`                                             |
| Release task                              | `POST /api/issues/:issueId/release`                                                        |
| List agents                               | `GET /api/companies/:companyId/agents`                                                     |
| List company skills                       | `GET /api/companies/:companyId/skills`                                                     |
| Import company skills                     | `POST /api/companies/:companyId/skills/import`                                             |
| Scan project workspaces for skills        | `POST /api/companies/:companyId/skills/scan-projects`                                      |
| Sync agent desired skills                 | `POST /api/agents/:agentId/skills/sync`                                                    |
| Preview CEO-safe company import           | `POST /api/companies/:companyId/imports/preview`                                           |
| Apply CEO-safe company import             | `POST /api/companies/:companyId/imports/apply`                                             |
| Preview company export                    | `POST /api/companies/:companyId/exports/preview`                                           |
| Build company export                      | `POST /api/companies/:companyId/exports`                                                   |
| Dashboard                                 | `GET /api/companies/:companyId/dashboard`                                                  |
| Search issues                             | `GET /api/companies/:companyId/issues?q=search+term`                                       |
| Upload attachment (multipart, field=file) | `POST /api/companies/:companyId/issues/:issueId/attachments`                               |
| List issue attachments                    | `GET /api/issues/:issueId/attachments`                                                     |
| Get attachment content                    | `GET /api/attachments/:attachmentId/content`                                               |
| Delete attachment                         | `DELETE /api/attachments/:attachmentId`                                                    |
| List routines                             | `GET /api/companies/:companyId/routines`                                                   |
| Get routine                               | `GET /api/routines/:routineId`                                                             |
| Create routine                            | `POST /api/companies/:companyId/routines`                                                  |
| Update routine                            | `PATCH /api/routines/:routineId`                                                           |
| Add trigger                               | `POST /api/routines/:routineId/triggers`                                                   |
| Update trigger                            | `PATCH /api/routine-triggers/:triggerId`                                                   |
| Delete trigger                            | `DELETE /api/routine-triggers/:triggerId`                                                  |
| Rotate webhook secret                     | `POST /api/routine-triggers/:triggerId/rotate-secret`                                      |
| Manual run                                | `POST /api/routines/:routineId/run`                                                        |
| Fire webhook (external)                   | `POST /api/routine-triggers/public/:publicId/fire`                                         |
| List runs                                 | `GET /api/routines/:routineId/runs`                                                        |

## Company Import / Export

Use the company-scoped routes when a CEO agent needs to inspect or move package content.

- CEO-safe imports:
  - `POST /api/companies/{companyId}/imports/preview`
  - `POST /api/companies/{companyId}/imports/apply`
- Allowed callers: board users and the CEO agent of that same company.
- Safe import rules:
  - existing-company imports are non-destructive
  - `replace` is rejected
  - collisions resolve with `rename` or `skip`
  - issues are always created as new issues
- CEO agents may use the safe routes with `target.mode = "new_company"` to create a new company directly. Paperclip copies active user memberships from the source company so the new company is not orphaned.

For export, preview first and keep tasks explicit:

- `POST /api/companies/{companyId}/exports/preview`
- `POST /api/companies/{companyId}/exports`
- Export preview defaults to `issues: false`
- Add `issues` or `projectIssues` only when you intentionally need task files
- Use `selectedFiles` to narrow the final package to specific agents, skills, projects, or tasks after you inspect the preview inventory

## Searching Issues

Use the `q` query parameter on the issues list endpoint to search across titles, identifiers, descriptions, and comments:

```
GET /api/companies/{companyId}/issues?q=dockerfile
```

Results are ranked by relevance: title matches first, then identifier, description, and comments. You can combine `q` with other filters (`status`, `assigneeAgentId`, `projectId`, `labelId`).

## Self-Test Playbook (App-Level)

Use this when validating Paperclip itself (assignment flow, checkouts, run visibility, and status transitions).

1. Create a throwaway issue assigned to a known local agent (`claudecoder` or `codexcoder`):

```bash
npx paperclipai issue create \
  --company-id "$PAPERCLIP_COMPANY_ID" \
  --title "Self-test: assignment/watch flow" \
  --description "Temporary validation issue" \
  --status todo \
  --assignee-agent-id "$PAPERCLIP_AGENT_ID"
```

2. Trigger and watch a heartbeat for that assignee:

```bash
npx paperclipai heartbeat run --agent-id "$PAPERCLIP_AGENT_ID"
```

3. Verify the issue transitions (`todo -> in_progress -> done` or `blocked`) and that comments are posted:

```bash
npx paperclipai issue get <issue-id-or-identifier>
```

4. Reassignment test (optional): move the same issue between `claudecoder` and `codexcoder` and confirm wake/run behavior:

```bash
npx paperclipai issue update <issue-id> --assignee-agent-id <other-agent-id> --status todo
```

5. Cleanup: mark temporary issues done/cancelled with a clear note.

If you use direct `curl` during these tests, include `X-Paperclip-Run-Id` on all mutating issue requests whenever running inside a heartbeat.

## Full Reference

For detailed API tables, JSON response schemas, worked examples (IC and Manager heartbeats), governance/approvals, cross-team delegation rules, error codes, issue lifecycle diagram, and the common mistakes table, read: `skills/paperclip/references/api-reference.md`
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/Users/phariyawit.jiap/Documents/Paperclip/skills/paperclip$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"reference","path":"references/api-reference.md"},{"kind":"reference","path":"references/company-skills.md"},{"kind":"reference","path":"references/routines.md"},{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/paperclip","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-03T07:09:13.756Z$paperclip$, $paperclip$2026-04-03T07:59:50.645Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$60923533-21ee-4655-b8fc-e6154e8d7ec6$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$paperclipai/paperclip/paperclip-create-agent$paperclip$, $paperclip$paperclip-create-agent$paperclip$, $paperclip$paperclip-create-agent$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: paperclip-create-agent
description: >
  Create new agents in Paperclip with governance-aware hiring. Use when you need
  to inspect adapter configuration options, compare existing agent configs,
  draft a new agent prompt/config, and submit a hire request.
---

# Paperclip Create Agent Skill

Use this skill when you are asked to hire/create an agent.

## Preconditions

You need either:

- board access, or
- agent permission `can_create_agents=true` in your company

If you do not have this permission, escalate to your CEO or board.

## Workflow

1. Confirm identity and company context.

```sh
curl -sS "$PAPERCLIP_API_URL/api/agents/me" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

2. Discover available adapter configuration docs for this Paperclip instance.

```sh
curl -sS "$PAPERCLIP_API_URL/llms/agent-configuration.txt" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

3. Read adapter-specific docs (example: `claude_local`).

```sh
curl -sS "$PAPERCLIP_API_URL/llms/agent-configuration/claude_local.txt" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

4. Compare existing agent configurations in your company.

```sh
curl -sS "$PAPERCLIP_API_URL/api/companies/$PAPERCLIP_COMPANY_ID/agent-configurations" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

5. Discover allowed agent icons and pick one that matches the role.

```sh
curl -sS "$PAPERCLIP_API_URL/llms/agent-icons.txt" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

6. Draft the new hire config:
- role/title/name
- icon (required in practice; use one from `/llms/agent-icons.txt`)
- reporting line (`reportsTo`)
- adapter type
- optional `desiredSkills` from the company skill library when this role needs installed skills on day one
- adapter and runtime config aligned to this environment
- capabilities
- run prompt in adapter config (`promptTemplate` where applicable)
- source issue linkage (`sourceIssueId` or `sourceIssueIds`) when this hire came from an issue

7. Submit hire request.

```sh
curl -sS -X POST "$PAPERCLIP_API_URL/api/companies/$PAPERCLIP_COMPANY_ID/agent-hires" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "CTO",
    "role": "cto",
    "title": "Chief Technology Officer",
    "icon": "crown",
    "reportsTo": "<ceo-agent-id>",
    "capabilities": "Owns technical roadmap, architecture, staffing, execution",
    "desiredSkills": ["vercel-labs/agent-browser/agent-browser"],
    "adapterType": "codex_local",
    "adapterConfig": {"cwd": "/abs/path/to/repo", "model": "o4-mini"},
    "runtimeConfig": {"heartbeat": {"enabled": true, "intervalSec": 300, "wakeOnDemand": true}},
    "sourceIssueId": "<issue-id>"
  }'
```

8. Handle governance state:
- if response has `approval`, hire is `pending_approval`
- monitor and discuss on approval thread
- when the board approves, you will be woken with `PAPERCLIP_APPROVAL_ID`; read linked issues and close/comment follow-up

```sh
curl -sS "$PAPERCLIP_API_URL/api/approvals/<approval-id>" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"

curl -sS -X POST "$PAPERCLIP_API_URL/api/approvals/<approval-id>/comments" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"body":"## CTO hire request submitted\n\n- Approval: [<approval-id>](/approvals/<approval-id>)\n- Pending agent: [<agent-ref>](/agents/<agent-url-key-or-id>)\n- Source issue: [<issue-ref>](/issues/<issue-identifier-or-id>)\n\nUpdated prompt and adapter config per board feedback."}'
```

If the approval already exists and needs manual linking to the issue:

```sh
curl -sS -X POST "$PAPERCLIP_API_URL/api/issues/<issue-id>/approvals" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"approvalId":"<approval-id>"}'
```

After approval is granted, run this follow-up loop:

```sh
curl -sS "$PAPERCLIP_API_URL/api/approvals/$PAPERCLIP_APPROVAL_ID" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"

curl -sS "$PAPERCLIP_API_URL/api/approvals/$PAPERCLIP_APPROVAL_ID/issues" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

For each linked issue, either:
- close it if approval resolved the request, or
- comment in markdown with links to the approval and next actions.

## Quality Bar

Before sending a hire request:

- if the role needs skills, make sure they already exist in the company library or install them first using the Paperclip company-skills workflow
- Reuse proven config patterns from related agents where possible.
- Set a concrete `icon` from `/llms/agent-icons.txt` so the new hire is identifiable in org and task views.
- Avoid secrets in plain text unless required by adapter behavior.
- Ensure reporting line is correct and in-company.
- Ensure prompt is role-specific and operationally scoped.
- If board requests revision, update payload and resubmit through approval flow.

For endpoint payload shapes and full examples, read:
`skills/paperclip-create-agent/references/api-reference.md`
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/Users/phariyawit.jiap/Documents/Paperclip/skills/paperclip-create-agent$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"reference","path":"references/api-reference.md"},{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/paperclip-create-agent","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-03T07:09:13.758Z$paperclip$, $paperclip$2026-04-03T07:59:50.657Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.cost_events (4 rows)
INSERT INTO "public"."cost_events" ("id", "company_id", "agent_id", "issue_id", "project_id", "goal_id", "billing_code", "provider", "model", "input_tokens", "output_tokens", "cost_cents", "occurred_at", "created_at", "heartbeat_run_id", "biller", "billing_type", "cached_input_tokens") VALUES ($paperclip$0fce8086-7b51-46d1-ac40-5cd134320ca7$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, NULL, NULL, $paperclip$anthropic$paperclip$, $paperclip$claude-sonnet-4-6$paperclip$, 25, 4296, 0, $paperclip$2026-04-03T07:12:08.529Z$paperclip$, $paperclip$2026-04-03T07:12:08.530Z$paperclip$, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$, $paperclip$anthropic$paperclip$, $paperclip$subscription_included$paperclip$, 761113);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."cost_events" ("id", "company_id", "agent_id", "issue_id", "project_id", "goal_id", "billing_code", "provider", "model", "input_tokens", "output_tokens", "cost_cents", "occurred_at", "created_at", "heartbeat_run_id", "biller", "billing_type", "cached_input_tokens") VALUES ($paperclip$bba6112b-06c6-4222-a196-bc3be36dcf23$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, NULL, NULL, $paperclip$anthropic$paperclip$, $paperclip$claude-opus-4-6$paperclip$, 25, 6309, 0, $paperclip$2026-04-03T07:13:27.177Z$paperclip$, $paperclip$2026-04-03T07:13:27.177Z$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$, $paperclip$anthropic$paperclip$, $paperclip$subscription_included$paperclip$, 808244);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."cost_events" ("id", "company_id", "agent_id", "issue_id", "project_id", "goal_id", "billing_code", "provider", "model", "input_tokens", "output_tokens", "cost_cents", "occurred_at", "created_at", "heartbeat_run_id", "biller", "billing_type", "cached_input_tokens") VALUES ($paperclip$a24610c7-5c4c-4450-8e4c-f511fcc200d7$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, NULL, NULL, $paperclip$anthropic$paperclip$, $paperclip$claude-opus-4-6$paperclip$, 20, 5323, 0, $paperclip$2026-04-03T07:17:10.821Z$paperclip$, $paperclip$2026-04-03T07:17:10.821Z$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$, $paperclip$anthropic$paperclip$, $paperclip$subscription_included$paperclip$, 308483);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."cost_events" ("id", "company_id", "agent_id", "issue_id", "project_id", "goal_id", "billing_code", "provider", "model", "input_tokens", "output_tokens", "cost_cents", "occurred_at", "created_at", "heartbeat_run_id", "biller", "billing_type", "cached_input_tokens") VALUES ($paperclip$0be7c692-e2ce-408c-a5f5-3d8a21cd520e$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, NULL, NULL, $paperclip$anthropic$paperclip$, $paperclip$claude-sonnet-4-6$paperclip$, 35, 6882, 0, $paperclip$2026-04-03T07:19:33.718Z$paperclip$, $paperclip$2026-04-03T07:19:33.719Z$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$, $paperclip$anthropic$paperclip$, $paperclip$subscription_included$paperclip$, 1301513);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.document_revisions (1 rows)
INSERT INTO "public"."document_revisions" ("id", "company_id", "document_id", "revision_number", "body", "change_summary", "created_by_agent_id", "created_by_user_id", "created_at", "title", "format", "created_by_run_id") VALUES ($paperclip$69e68204-1e40-4692-ae6d-35c9ec2f8ee5$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$09c406ff-9d42-4d8f-b736-0f0d454ca74f$paperclip$, 1, $paperclip$# Sprint 1 Plan — Phase A: IDEA → SPEC

## Goal
Establish the BRD + SRS foundation for AEGIS autonomous software delivery platform. This is the critical pre-requisite for all downstream build, QA, and deployment phases.

## Sprint 1 Scope
Phase A of the 14-Stage SDLC Pipeline: **IDEA → SPEC**

## Decision Tree Entry Point
> P8 (No spec exists) → Run spec creation → breakdown → sprint plan → build

## Phase A Tasks

| # | Task | Owner | Status | Blocker |
|---|------|-------|--------|--------|
| A1 | Hire Sage (Specification Architect) | Mother Brain (CEO) | **Blocked — awaiting hire request** | CEO must submit hire |
| A2 | BRD + SRS creation via super-spec skill | Sage | Pending | A1 |
| A3 | QualityGate 1 — Spec completeness review | Navi (CTO) | Pending | A2 |
| A4 | Sprint 2 breakdown from validated spec | Navi (CTO) | Pending | A3 |

## Agent Roster Needed for Sprint 1 (Phase A)

### Sage — Specification Architect (CRITICAL PATH)
- **Role**: spec_architect
- **Capabilities**: BRD authoring, SRS drafting, requirements elicitation, ISO 29110 compliance mapping, super-spec skill
- **Rationale**: No spec exists. AEGIS cannot proceed past Phase A without a BRD and SRS. This is a P0 hire for Sprint 1.
- **Deliverable**: Complete BRD + SRS via `super-spec` skill on this project

## Agents Needed for Sprint 2+ (Context Only)
Once the spec is validated, the following agents will need to be hired for downstream phases:

| Agent | Role | Phase |
|-------|------|-------|
| Bolt | Senior Developer | BUILD |
| Vigil | QA Lead | QA |
| Havoc | Security/Chaos | COMPLY |
| Forge | DevOps/CI-CD | DEPLOY |
| Pixel | Frontend Dev | BUILD |
| Muse | UX Designer | SPEC/BUILD |
| Sentinel | Monitoring | MONITOR |
| Probe | Test Automation | QA |
| Scribe | Technical Writer | COMPLY/DOC |
| Ops | Operations | DEPLOY/MONITOR |

## Quality Gates

### Gate 1 — Spec Completeness (end of Sprint 1)
- [ ] BRD covers: business context, stakeholders, requirements, success metrics
- [ ] SRS covers: functional specs, non-functional requirements, system constraints
- [ ] ISO 29110 Basic Profile work products accounted for
- [ ] All 14 pipeline stages have at least one acceptance criterion

## Immediate Next Actions
1. **CEO (Mother Brain)**: Hire Sage with `spec_architect` role
2. **Navi (CTO)**: Once Sage is online, create AEGA-3 (BRD + SRS task) assigned to Sage
3. **Sage**: Execute super-spec skill to produce BRD + SRS
4. **Navi**: Review, approve at Gate 1, then plan Sprint 2

## Success Criteria for Sprint 1
- Sage is hired and operational
- BRD + SRS document exists and passes Gate 1 review
- Sprint 2 breakdown is ready with agent hiring queue
$paperclip$, NULL, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, NULL, $paperclip$2026-04-03T07:19:04.131Z$paperclip$, $paperclip$Sprint 1 Plan — Phase A: IDEA → SPEC$paperclip$, $paperclip$markdown$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.documents (1 rows)
INSERT INTO "public"."documents" ("id", "company_id", "title", "format", "latest_body", "latest_revision_id", "latest_revision_number", "created_by_agent_id", "created_by_user_id", "updated_by_agent_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$09c406ff-9d42-4d8f-b736-0f0d454ca74f$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$Sprint 1 Plan — Phase A: IDEA → SPEC$paperclip$, $paperclip$markdown$paperclip$, $paperclip$# Sprint 1 Plan — Phase A: IDEA → SPEC

## Goal
Establish the BRD + SRS foundation for AEGIS autonomous software delivery platform. This is the critical pre-requisite for all downstream build, QA, and deployment phases.

## Sprint 1 Scope
Phase A of the 14-Stage SDLC Pipeline: **IDEA → SPEC**

## Decision Tree Entry Point
> P8 (No spec exists) → Run spec creation → breakdown → sprint plan → build

## Phase A Tasks

| # | Task | Owner | Status | Blocker |
|---|------|-------|--------|--------|
| A1 | Hire Sage (Specification Architect) | Mother Brain (CEO) | **Blocked — awaiting hire request** | CEO must submit hire |
| A2 | BRD + SRS creation via super-spec skill | Sage | Pending | A1 |
| A3 | QualityGate 1 — Spec completeness review | Navi (CTO) | Pending | A2 |
| A4 | Sprint 2 breakdown from validated spec | Navi (CTO) | Pending | A3 |

## Agent Roster Needed for Sprint 1 (Phase A)

### Sage — Specification Architect (CRITICAL PATH)
- **Role**: spec_architect
- **Capabilities**: BRD authoring, SRS drafting, requirements elicitation, ISO 29110 compliance mapping, super-spec skill
- **Rationale**: No spec exists. AEGIS cannot proceed past Phase A without a BRD and SRS. This is a P0 hire for Sprint 1.
- **Deliverable**: Complete BRD + SRS via `super-spec` skill on this project

## Agents Needed for Sprint 2+ (Context Only)
Once the spec is validated, the following agents will need to be hired for downstream phases:

| Agent | Role | Phase |
|-------|------|-------|
| Bolt | Senior Developer | BUILD |
| Vigil | QA Lead | QA |
| Havoc | Security/Chaos | COMPLY |
| Forge | DevOps/CI-CD | DEPLOY |
| Pixel | Frontend Dev | BUILD |
| Muse | UX Designer | SPEC/BUILD |
| Sentinel | Monitoring | MONITOR |
| Probe | Test Automation | QA |
| Scribe | Technical Writer | COMPLY/DOC |
| Ops | Operations | DEPLOY/MONITOR |

## Quality Gates

### Gate 1 — Spec Completeness (end of Sprint 1)
- [ ] BRD covers: business context, stakeholders, requirements, success metrics
- [ ] SRS covers: functional specs, non-functional requirements, system constraints
- [ ] ISO 29110 Basic Profile work products accounted for
- [ ] All 14 pipeline stages have at least one acceptance criterion

## Immediate Next Actions
1. **CEO (Mother Brain)**: Hire Sage with `spec_architect` role
2. **Navi (CTO)**: Once Sage is online, create AEGA-3 (BRD + SRS task) assigned to Sage
3. **Sage**: Execute super-spec skill to produce BRD + SRS
4. **Navi**: Review, approve at Gate 1, then plan Sprint 2

## Success Criteria for Sprint 1
- Sage is hired and operational
- BRD + SRS document exists and passes Gate 1 review
- Sprint 2 breakdown is ready with agent hiring queue
$paperclip$, $paperclip$69e68204-1e40-4692-ae6d-35c9ec2f8ee5$paperclip$, 1, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, NULL, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, NULL, $paperclip$2026-04-03T07:19:04.131Z$paperclip$, $paperclip$2026-04-03T07:19:04.131Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.execution_workspaces (4 rows)
INSERT INTO "public"."execution_workspaces" ("id", "company_id", "project_id", "project_workspace_id", "source_issue_id", "mode", "strategy_type", "name", "status", "cwd", "repo_url", "base_ref", "branch_name", "provider_type", "provider_ref", "derived_from_execution_workspace_id", "last_used_at", "opened_at", "closed_at", "cleanup_eligible_at", "cleanup_reason", "metadata", "created_at", "updated_at") VALUES ($paperclip$62ff6c81-eff8-4e91-a583-778ec97c764c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, NULL, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, $paperclip$shared_workspace$paperclip$, $paperclip$project_primary$paperclip$, $paperclip$AEG-1$paperclip$, $paperclip$active$paperclip$, $paperclip$/Users/phariyawit.jiap/.paperclip/instances/default/projects/9c929d23-2ccc-4a69-9757-348ec303068b/dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc/_default$paperclip$, NULL, NULL, NULL, $paperclip$local_fs$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:09:13.763Z$paperclip$, $paperclip$2026-04-03T07:09:13.763Z$paperclip$, NULL, NULL, NULL, $paperclip${"source":"project_primary","createdByRuntime":false}$paperclip$, $paperclip$2026-04-03T07:09:13.763Z$paperclip$, $paperclip$2026-04-03T07:09:13.763Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."execution_workspaces" ("id", "company_id", "project_id", "project_workspace_id", "source_issue_id", "mode", "strategy_type", "name", "status", "cwd", "repo_url", "base_ref", "branch_name", "provider_type", "provider_ref", "derived_from_execution_workspace_id", "last_used_at", "opened_at", "closed_at", "cleanup_eligible_at", "cleanup_reason", "metadata", "created_at", "updated_at") VALUES ($paperclip$3b5f9c75-8246-4bf0-8336-f7871efcaae0$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, NULL, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$shared_workspace$paperclip$, $paperclip$project_primary$paperclip$, $paperclip$AEGA-1$paperclip$, $paperclip$active$paperclip$, $paperclip$/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default$paperclip$, NULL, NULL, NULL, $paperclip$local_fs$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:11:04.253Z$paperclip$, $paperclip$2026-04-03T07:11:04.253Z$paperclip$, NULL, NULL, NULL, $paperclip${"source":"project_primary","createdByRuntime":false}$paperclip$, $paperclip$2026-04-03T07:11:04.253Z$paperclip$, $paperclip$2026-04-03T07:11:04.253Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."execution_workspaces" ("id", "company_id", "project_id", "project_workspace_id", "source_issue_id", "mode", "strategy_type", "name", "status", "cwd", "repo_url", "base_ref", "branch_name", "provider_type", "provider_ref", "derived_from_execution_workspace_id", "last_used_at", "opened_at", "closed_at", "cleanup_eligible_at", "cleanup_reason", "metadata", "created_at", "updated_at") VALUES ($paperclip$474acb14-54f2-4547-a389-66b4b881c5ad$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, NULL, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$shared_workspace$paperclip$, $paperclip$project_primary$paperclip$, $paperclip$AEGA-1$paperclip$, $paperclip$active$paperclip$, $paperclip$/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default$paperclip$, NULL, NULL, NULL, $paperclip$local_fs$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:15:07.856Z$paperclip$, $paperclip$2026-04-03T07:15:07.856Z$paperclip$, NULL, NULL, NULL, $paperclip${"source":"project_primary","createdByRuntime":false}$paperclip$, $paperclip$2026-04-03T07:15:07.856Z$paperclip$, $paperclip$2026-04-03T07:15:07.856Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."execution_workspaces" ("id", "company_id", "project_id", "project_workspace_id", "source_issue_id", "mode", "strategy_type", "name", "status", "cwd", "repo_url", "base_ref", "branch_name", "provider_type", "provider_ref", "derived_from_execution_workspace_id", "last_used_at", "opened_at", "closed_at", "cleanup_eligible_at", "cleanup_reason", "metadata", "created_at", "updated_at") VALUES ($paperclip$dfb96d75-53ae-4bbe-a299-a398af3879e2$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, NULL, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$shared_workspace$paperclip$, $paperclip$project_primary$paperclip$, $paperclip$AEGA-2$paperclip$, $paperclip$active$paperclip$, $paperclip$/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default$paperclip$, NULL, NULL, NULL, $paperclip$local_fs$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:16:43.223Z$paperclip$, $paperclip$2026-04-03T07:16:43.223Z$paperclip$, NULL, NULL, NULL, $paperclip${"source":"project_primary","createdByRuntime":false}$paperclip$, $paperclip$2026-04-03T07:16:43.223Z$paperclip$, $paperclip$2026-04-03T07:16:43.223Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.goals (6 rows)
INSERT INTO "public"."goals" ("id", "company_id", "title", "description", "level", "status", "parent_id", "owner_agent_id", "created_at", "updated_at") VALUES ($paperclip$f37b9d3a-60c7-431a-a03d-b9eda150e5ae$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$Production-grade autonomous software delivery via 13 AI agents. 14-Stage SDLC Pipeline (IDEA → SPEC → BUILD → REVIEW → QA → COMPLY → DEPLOY → MONITOR) with 5-Gate Quality System and ISO 29110 Compliance. "Context is King, Memory is Soul." Model routing: Opus thinks, Sonnet builds, Haiku gathers.$paperclip$, NULL, $paperclip$company$paperclip$, $paperclip$active$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:05:53.918Z$paperclip$, $paperclip$2026-04-03T07:05:53.918Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."goals" ("id", "company_id", "title", "description", "level", "status", "parent_id", "owner_agent_id", "created_at", "updated_at") VALUES ($paperclip$d7745ec8-1cec-4a57-a260-b810aaeaaec9$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Deliver production-grade software autonomously$paperclip$, $paperclip$End-to-end SDLC from ideation to monitoring via 14-stage pipeline. All deliverables pass 5-Gate Quality System.$paperclip$, $paperclip$company$paperclip$, $paperclip$active$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:06:09.688Z$paperclip$, $paperclip$2026-04-03T07:06:09.688Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."goals" ("id", "company_id", "title", "description", "level", "status", "parent_id", "owner_agent_id", "created_at", "updated_at") VALUES ($paperclip$7f94b7a6-1400-4bb8-8dbf-3761aa171461$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Architecture & Specification Quality$paperclip$, $paperclip$All features have approved BRD + SRS before implementation. No code without spec.$paperclip$, $paperclip$team$paperclip$, $paperclip$active$paperclip$, $paperclip$d7745ec8-1cec-4a57-a260-b810aaeaaec9$paperclip$, NULL, $paperclip$2026-04-03T07:06:09.746Z$paperclip$, $paperclip$2026-04-03T07:06:09.746Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."goals" ("id", "company_id", "title", "description", "level", "status", "parent_id", "owner_agent_id", "created_at", "updated_at") VALUES ($paperclip$4ddcd07b-d8c9-4b10-be66-fa9a06a585ce$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Code Quality & Security$paperclip$, $paperclip$All code passes Gate 1 (Vigil review) + Gate 2 (QA). Test coverage mandatory.$paperclip$, $paperclip$team$paperclip$, $paperclip$active$paperclip$, $paperclip$d7745ec8-1cec-4a57-a260-b810aaeaaec9$paperclip$, NULL, $paperclip$2026-04-03T07:06:09.783Z$paperclip$, $paperclip$2026-04-03T07:06:09.783Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."goals" ("id", "company_id", "title", "description", "level", "status", "parent_id", "owner_agent_id", "created_at", "updated_at") VALUES ($paperclip$3244e301-acf7-4c11-8517-2befc568e7b5$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$ISO 29110 Compliance$paperclip$, $paperclip$14 work products maintained. Gate 3 (Scribe) required before deploy.$paperclip$, $paperclip$team$paperclip$, $paperclip$active$paperclip$, $paperclip$d7745ec8-1cec-4a57-a260-b810aaeaaec9$paperclip$, NULL, $paperclip$2026-04-03T07:06:09.815Z$paperclip$, $paperclip$2026-04-03T07:06:09.815Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."goals" ("id", "company_id", "title", "description", "level", "status", "parent_id", "owner_agent_id", "created_at", "updated_at") VALUES ($paperclip$768df2fa-cd17-40f3-a516-28e6c409ced4$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$Continuous Deployment & Monitoring$paperclip$, $paperclip$Gate 4 (deploy + health check) and Gate 5 (post-deploy monitor, error rate <2x baseline).$paperclip$, $paperclip$team$paperclip$, $paperclip$active$paperclip$, $paperclip$d7745ec8-1cec-4a57-a260-b810aaeaaec9$paperclip$, NULL, $paperclip$2026-04-03T07:06:09.845Z$paperclip$, $paperclip$2026-04-03T07:06:09.845Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.heartbeat_run_events (12 rows)
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$1$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-03T07:09:13.769Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$2$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/9c929d23-2ccc-4a69-9757-348ec303068b/dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc/_default","env":{"HOME":"/Users/phariyawit.jiap","AGENT_HOME":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/fb9504df-4a79-403a-8c73-efd73abf869c","PAPERCLIP_RUN_ID":"da5df186-9330-4ca7-a694-4d69440fbe0d","PAPERCLIP_API_URL":"http://127.0.0.1:3100","PAPERCLIP_TASK_ID":"16332a71-9b62-4703-a0a6-452b1fabc4a7","PAPERCLIP_AGENT_ID":"fb9504df-4a79-403a-8c73-efd73abf869c","PAPERCLIP_COMPANY_ID":"9c929d23-2ccc-4a69-9757-348ec303068b","PAPERCLIP_WAKE_REASON":"issue_assigned","PAPERCLIP_WORKSPACE_CWD":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/9c929d23-2ccc-4a69-9757-348ec303068b/dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc/_default","PAPERCLIP_RESOLVED_COMMAND":"/opt/homebrew/bin/claude","PAPERCLIP_WORKSPACE_SOURCE":"project_primary","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent fb9504df-4a79-403a-8c73-efd73abf869c (Sage). Continue your Paperclip work.","command":"/opt/homebrew/bin/claude","context":{"source":"issue.create","taskId":"16332a71-9b62-4703-a0a6-452b1fabc4a7","issueId":"16332a71-9b62-4703-a0a6-452b1fabc4a7","taskKey":"16332a71-9b62-4703-a0a6-452b1fabc4a7","projectId":"dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc","wakeReason":"issue_assigned","wakeSource":"assignment","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/9c929d23-2ccc-4a69-9757-348ec303068b/dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc/_default","mode":"shared_workspace","source":"project_primary","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/fb9504df-4a79-403a-8c73-efd73abf869c","projectId":"dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc","branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[],"executionWorkspaceId":"62ff6c81-eff8-4e91-a583-778ec97c764c"},"adapterType":"claude_local","commandArgs":["--print","-","--output-format","stream-json","--verbose","--append-system-prompt-file","/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-Ed0xTm/agent-instructions.md","--add-dir","/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-Ed0xTm"],"commandNotes":["Injected agent instructions via --append-system-prompt-file /Users/phariyawit.jiap/.paperclip/instances/default/companies/9c929d23-2ccc-4a69-9757-348ec303068b/agents/fb9504df-4a79-403a-8c73-efd73abf869c/instructions/AGENTS.md (with path directive appended)"],"promptMetrics":{"promptChars":88,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":88}}$paperclip$, $paperclip$2026-04-03T07:09:13.776Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$3$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-03T07:11:04.266Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$4$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","env":{"HOME":"/Users/phariyawit.jiap","AGENT_HOME":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/1e6d0b76-3817-4502-901e-7dd1356cd771","PAPERCLIP_RUN_ID":"a59f0164-e5a8-45bf-8525-f5c02c090957","PAPERCLIP_API_URL":"http://127.0.0.1:3100","PAPERCLIP_TASK_ID":"af75be97-329e-4d28-80d9-27b03db4f7c6","PAPERCLIP_AGENT_ID":"1e6d0b76-3817-4502-901e-7dd1356cd771","PAPERCLIP_COMPANY_ID":"3cfded27-7059-4ce7-a93e-11fd3d0eb4af","PAPERCLIP_WAKE_REASON":"issue_assigned","PAPERCLIP_WORKSPACE_CWD":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","PAPERCLIP_RESOLVED_COMMAND":"/opt/homebrew/bin/claude","PAPERCLIP_WORKSPACE_SOURCE":"project_primary","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 1e6d0b76-3817-4502-901e-7dd1356cd771 (Mother Brain). Continue your Paperclip work.","command":"/opt/homebrew/bin/claude","context":{"source":"issue.create","taskId":"af75be97-329e-4d28-80d9-27b03db4f7c6","issueId":"af75be97-329e-4d28-80d9-27b03db4f7c6","taskKey":"af75be97-329e-4d28-80d9-27b03db4f7c6","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","wakeReason":"issue_assigned","wakeSource":"assignment","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","mode":"shared_workspace","source":"project_primary","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/1e6d0b76-3817-4502-901e-7dd1356cd771","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[],"executionWorkspaceId":"3b5f9c75-8246-4bf0-8336-f7871efcaae0"},"adapterType":"claude_local","commandArgs":["--print","-","--output-format","stream-json","--verbose","--dangerously-skip-permissions","--model","claude-opus-4-6","--max-turns","1000","--append-system-prompt-file","/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-z9F5bQ/agent-instructions.md","--add-dir","/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-z9F5bQ"],"commandNotes":["Injected agent instructions via --append-system-prompt-file /Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/1e6d0b76-3817-4502-901e-7dd1356cd771/instructions/AGENTS.md (with path directive appended)"],"promptMetrics":{"promptChars":96,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":96}}$paperclip$, $paperclip$2026-04-03T07:11:04.290Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$5$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run succeeded$paperclip$, $paperclip${"status":"succeeded","exitCode":0}$paperclip$, $paperclip$2026-04-03T07:12:08.525Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$6$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run succeeded$paperclip$, $paperclip${"status":"succeeded","exitCode":0}$paperclip$, $paperclip$2026-04-03T07:13:27.168Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$7$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-03T07:15:07.862Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$8$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","env":{"HOME":"/Users/phariyawit.jiap","AGENT_HOME":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/1e6d0b76-3817-4502-901e-7dd1356cd771","PAPERCLIP_RUN_ID":"d1c08dfe-79d2-4b00-bebe-cf556cb7b15e","PAPERCLIP_API_URL":"http://127.0.0.1:3100","PAPERCLIP_TASK_ID":"af75be97-329e-4d28-80d9-27b03db4f7c6","PAPERCLIP_AGENT_ID":"1e6d0b76-3817-4502-901e-7dd1356cd771","PAPERCLIP_COMPANY_ID":"3cfded27-7059-4ce7-a93e-11fd3d0eb4af","PAPERCLIP_APPROVAL_ID":"8112ed6e-4eae-4360-9ac1-c5e88764c1b5","PAPERCLIP_WAKE_REASON":"approval_approved","PAPERCLIP_WORKSPACE_CWD":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","PAPERCLIP_APPROVAL_STATUS":"approved","PAPERCLIP_LINKED_ISSUE_IDS":"af75be97-329e-4d28-80d9-27b03db4f7c6","PAPERCLIP_RESOLVED_COMMAND":"/opt/homebrew/bin/claude","PAPERCLIP_WORKSPACE_SOURCE":"project_primary","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 1e6d0b76-3817-4502-901e-7dd1356cd771 (Mother Brain). Continue your Paperclip work.","command":"/opt/homebrew/bin/claude","context":{"source":"approval.approved","taskId":"af75be97-329e-4d28-80d9-27b03db4f7c6","issueId":"af75be97-329e-4d28-80d9-27b03db4f7c6","taskKey":"af75be97-329e-4d28-80d9-27b03db4f7c6","issueIds":["af75be97-329e-4d28-80d9-27b03db4f7c6"],"projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","approvalId":"8112ed6e-4eae-4360-9ac1-c5e88764c1b5","wakeReason":"approval_approved","wakeSource":"automation","approvalStatus":"approved","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","mode":"shared_workspace","source":"project_primary","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/1e6d0b76-3817-4502-901e-7dd1356cd771","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[],"executionWorkspaceId":"474acb14-54f2-4547-a389-66b4b881c5ad"},"adapterType":"claude_local","commandArgs":["--print","-","--output-format","stream-json","--verbose","--resume","60e284df-eb26-46b8-8507-391b2bddce9d","--dangerously-skip-permissions","--model","claude-opus-4-6","--max-turns","1000","--append-system-prompt-file","/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-iRuj9q/agent-instructions.md","--add-dir","/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-iRuj9q"],"commandNotes":["Injected agent instructions via --append-system-prompt-file /Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/1e6d0b76-3817-4502-901e-7dd1356cd771/instructions/AGENTS.md (with path directive appended)"],"promptMetrics":{"promptChars":96,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":96}}$paperclip$, $paperclip$2026-04-03T07:15:07.866Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$9$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-03T07:16:43.234Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$10$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","env":{"HOME":"/Users/phariyawit.jiap","AGENT_HOME":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/3df78889-0a61-4fed-bb04-6c3134c3d2d8","PAPERCLIP_RUN_ID":"fcdc325d-fe50-434d-b011-904de1bb60e5","PAPERCLIP_API_URL":"http://127.0.0.1:3100","PAPERCLIP_TASK_ID":"d447cdfb-1655-41ba-b222-a7fad582e53c","PAPERCLIP_AGENT_ID":"3df78889-0a61-4fed-bb04-6c3134c3d2d8","PAPERCLIP_COMPANY_ID":"3cfded27-7059-4ce7-a93e-11fd3d0eb4af","PAPERCLIP_WAKE_REASON":"issue_assigned","PAPERCLIP_WORKSPACE_CWD":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","PAPERCLIP_RESOLVED_COMMAND":"/opt/homebrew/bin/claude","PAPERCLIP_WORKSPACE_SOURCE":"project_primary","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 3df78889-0a61-4fed-bb04-6c3134c3d2d8 (Navi). Continue your Paperclip work.","command":"/opt/homebrew/bin/claude","context":{"source":"issue.create","taskId":"d447cdfb-1655-41ba-b222-a7fad582e53c","issueId":"d447cdfb-1655-41ba-b222-a7fad582e53c","taskKey":"d447cdfb-1655-41ba-b222-a7fad582e53c","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","wakeReason":"issue_assigned","wakeSource":"assignment","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","mode":"shared_workspace","source":"project_primary","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/3df78889-0a61-4fed-bb04-6c3134c3d2d8","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[],"executionWorkspaceId":"dfb96d75-53ae-4bbe-a299-a398af3879e2"},"adapterType":"claude_local","commandArgs":["--print","-","--output-format","stream-json","--verbose","--dangerously-skip-permissions","--model","claude-sonnet-4-6","--max-turns","500","--append-system-prompt-file","/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-JV1biR/agent-instructions.md","--add-dir","/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-JV1biR"],"commandNotes":["Injected agent instructions via --append-system-prompt-file /Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions/AGENTS.md (with path directive appended)"],"promptMetrics":{"promptChars":88,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":88}}$paperclip$, $paperclip$2026-04-03T07:16:43.245Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$11$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run succeeded$paperclip$, $paperclip${"status":"succeeded","exitCode":0}$paperclip$, $paperclip$2026-04-03T07:17:10.812Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$12$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run succeeded$paperclip$, $paperclip${"status":"succeeded","exitCode":0}$paperclip$, $paperclip$2026-04-03T07:19:33.711Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.heartbeat_runs (4 rows)
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$assignment$paperclip$, $paperclip$succeeded$paperclip$, $paperclip$2026-04-03T07:09:13.744Z$paperclip$, $paperclip$2026-04-03T07:12:08.519Z$paperclip$, NULL, NULL, $paperclip${"source":"issue.create","taskId":"16332a71-9b62-4703-a0a6-452b1fabc4a7","issueId":"16332a71-9b62-4703-a0a6-452b1fabc4a7","taskKey":"16332a71-9b62-4703-a0a6-452b1fabc4a7","projectId":"dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc","wakeReason":"issue_assigned","wakeSource":"assignment","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/9c929d23-2ccc-4a69-9757-348ec303068b/dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc/_default","mode":"shared_workspace","source":"project_primary","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/fb9504df-4a79-403a-8c73-efd73abf869c","projectId":"dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc","branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[],"executionWorkspaceId":"62ff6c81-eff8-4e91-a583-778ec97c764c"}$paperclip$, $paperclip$2026-04-03T07:09:13.736Z$paperclip$, $paperclip$2026-04-03T07:12:08.519Z$paperclip$, $paperclip$system$paperclip$, $paperclip$a78e3831-d7ed-4844-badc-70ba85ba3c1c$paperclip$, 0, NULL, $paperclip${"model":"claude-sonnet-4-6","biller":"anthropic","costUsd":0.39417764999999994,"provider":"anthropic","billingType":"subscription_included","inputTokens":25,"freshSession":true,"outputTokens":4296,"sessionReused":false,"rawInputTokens":25,"sessionRotated":false,"rawOutputTokens":4296,"cachedInputTokens":761113,"taskSessionReused":false,"persistedSessionId":"c0011f36-8c58-4ee0-a5e7-96a51a280338","rawCachedInputTokens":761113,"sessionRotationReason":null}$paperclip$, $paperclip${"type":"result","uuid":"800f194c-fccf-410f-9f29-dfe3574c248d","usage":{"speed":"standard","iterations":[],"input_tokens":25,"service_tier":"standard","inference_geo":"","output_tokens":4296,"cache_creation":{"ephemeral_1h_input_tokens":27021,"ephemeral_5m_input_tokens":0},"server_tool_use":{"web_fetch_requests":0,"web_search_requests":0},"cache_read_input_tokens":761113,"cache_creation_input_tokens":27021},"result":"**Phase A — Requirements Q&A (10 questions)**\n\nI'm Sage, and I'll be guiding you through a structured discovery session to produce your BRD + SRS + UX Blueprint. Please answer the following questions:\n\n---\n\n**Q1. What is the product or feature you want to build?**\n(Be as brief or detailed as you like — even \"digital wallet\" or \"task manager for teams\" is enough to start.)\n\n**Q2. Who are the primary users?**\n(e.g., consumers, B2B customers, internal ops team, mixed)\n\n**Q3. What is the core problem this product solves?**\n(What pain point or gap does it address?)\n\n**Q4. What stage is this at?**\n(MVP from scratch / adding a feature to an existing product / rewrite / research/pre-funding)\n\n**Q5. What is the primary market or region?**\n(Thailand/SEA, Global, EU, other)\n\n**Q6. What are the 2–3 most important things the product MUST do?**\n(The non-negotiables for v1)\n\n**Q7. What is explicitly OUT of scope for this phase?**\n(What should we intentionally leave for later?)\n\n**Q8. Are there any tech constraints or preferences?**\n(e.g., mobile-first, React Native, existing backend in Node.js, must use AWS, etc.)\n\n**Q9. Are there any regulatory or compliance concerns?**\n(e.g., financial regulations, PDPA/GDPR, healthcare data, age restrictions)\n\n**Q10. What does success look like in 6 months?**\n(Key metrics, outcomes, or milestones that would confirm this was worth building)\n\n---\n\nTake your time — more detail = better spec. Once you answer, I'll produce the full BRD + SRS + UX Blueprint.","subtype":"success","is_error":false,"num_turns":22,"modelUsage":{"claude-sonnet-4-6":{"costUSD":0.39417764999999994,"inputTokens":25,"outputTokens":4296,"contextWindow":200000,"maxOutputTokens":32000,"webSearchRequests":0,"cacheReadInputTokens":761113,"cacheCreationInputTokens":27021}},"session_id":"c0011f36-8c58-4ee0-a5e7-96a51a280338","duration_ms":173670,"stop_reason":"end_turn","total_cost_usd":0.39417764999999994,"duration_api_ms":94614,"fast_mode_state":"off","terminal_reason":"completed","permission_denials":[{"tool_name":"AskUserQuestion","tool_input":{"questions":[{"header":"Product Idea","options":[{"label":"I'll describe it below","description":"Type your product idea in the 'Other' field"},{"label":"Mobile app","description":"A mobile-first application"},{"label":"Web platform","description":"A web-based SaaS or portal"},{"label":"API / Backend service","description":"A headless service or integration layer"}],"question":"What product or feature do you want to build? (e.g., \"digital wallet\", \"e-commerce checkout\", \"AI customer support bot\")","multiSelect":false},{"header":"Target Users","options":[{"label":"Consumers (B2C)","description":"General public, end users"},{"label":"Businesses (B2B)","description":"Companies, teams, or professionals"},{"label":"Internal teams","description":"Employees, ops, or admin staff"},{"label":"Mixed","description":"Multiple user types"}],"question":"Who are the primary users?","multiSelect":false},{"header":"Stage","options":[{"label":"Brand new (MVP)","description":"Starting from zero — need to define everything"},{"label":"Existing product, new feature","description":"Adding a major module to something that exists"},{"label":"Rewrite / migration","description":"Replacing or modernizing an existing system"},{"label":"Research / pre-funding","description":"Exploring the concept, not yet building"}],"question":"What stage is this product at?","multiSelect":false},{"header":"Market","options":[{"label":"Thailand / SEA","description":"Southeast Asia focus"},{"label":"Global / US","description":"International or US-first"},{"label":"Europe","description":"EU market with GDPR considerations"},{"label":"Other / Not sure","description":"Specify in Other or leave open"}],"question":"What is the primary market or region?","multiSelect":false}]},"tool_use_id":"toolu_01VoZgjiQyuRdQHegTEpEc61"}]}$paperclip$, NULL, $paperclip$c0011f36-8c58-4ee0-a5e7-96a51a280338$paperclip$, $paperclip$local_file$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b/fb9504df-4a79-403a-8c73-efd73abf869c/da5df186-9330-4ca7-a694-4d69440fbe0d.ndjson$paperclip$, $paperclip$127734$paperclip$, $paperclip$12ea0ace9efbec62e4943fa75394d69a324c024719ca6666ccd90f320faca3a4$paperclip$, false, $paperclip$ | Differentiation | Over-engineering for MVP |\n| Crypto integration | Market trend | Regulatory uncertainty |\n\n### Not Recommended\n| Feature | Why Not |\n|---------|---------|\n| Social feed | Off-brand, privacy concern, no clear ROI |\n| Built-in marketplace | Scope explosion, better as integration |\n```\n\n### Phase 2: Super System Analysis\n\n```markdown\n## Super System Analysis\n\n### Stakeholders & Roles\n| Stakeholder | Role | Needs |\n|------------|------|-------|\n| End User (Consumer) | Primary user | Send/receive money, pay bills, track spending |\n| Merchant | Payment acceptor | Receive payments, view settlements |\n| Compliance Officer | Regulatory | KYC verification, transaction monitoring |\n| System Admin | Operations | User management, system health, dispute resolution |\n| Product Owner | Strategy | Analytics, feature usage, conversion data |\n\n### Key User Journeys\n1. **Registration & KYC** — Download → Register → Verify ID → Set PIN → Ready\n2. **P2P Transfer** — Open app → Select recipient → Enter amount → Confirm → Receipt\n3. **Bill Payment** — Select biller → Enter reference → Confirm → Receipt\n4. **Merchant Payment** — Scan QR → Confirm amount → PIN/Bio → Receipt\n5. **Dispute Resolution** — View transaction → Report issue → Track status → Resolution\n\n### System Context (Verbal Diagram)\nThe wallet system sits between the user's mobile device and multiple external systems:\n- **Payment Gateway** — processes actual fund movements\n- **KYC Provider** — identity verification (e.g., NDID, manual review)\n- **Bank APIs** — top-up from bank accounts, withdrawals\n- **Biller Aggregator** — bill payment routing\n- **Notification Service** — push, SMS, email\n- **Fraud Detection** — real-time transaction scoring\n- **Analytics Platform** — usage tracking, business intelligence\n\n### Major Components\n1. **Mobile App** (React Native / Flutter) — UI layer\n2. **API Gateway** — auth, rate limiting, routing\n3. **Auth Service** — registration, login, PIN, biometrics, 2FA\n4. **Wallet Service** — balance, transfers, transaction log\n5. **Payment Service** — external payment routing\n6. **KYC Service** — identity verification workflow\n7. **Notification Service** — multi-channel delivery\n8. **Admin Portal** — back-office operations\n\n### Main Data Entities\n- User (profile, KYC status, wallet)\n- Wallet (balance, currency, status)\n- Transaction (type, amount, from, to, status, timestamp)\n- KYC Record (document type, verification status, expiry)\n- Notification (type, channel, status, sent_at)\n\n### Non-Functional Requirements\n| Category | Requirement | Target |\n|----------|-------------|--------|\n| Performance | API response time | p95 < 500ms |\n| Availability | System uptime | 99.9% |\n| Security | Data encryption | AES-256 at rest, TLS 1.3 in transit |\n| Scalability | Concurrent users | 100K initial, scale to 1M |\n| Compliance | Data retention | Per BOT/PDPA requirements |\n| Localization | Languages | Thai (primary), English |\n```\n\n### Phase 3: BRD (Business Requirements Document)\n\n```markdown\n## BRD — Business Requirements\n\n### Problem Statement\n[Target users] in [market] lack a [reliable/affordable/convenient] way to [primary pain point].\nCurrent solutions [competitor gaps]. This creates an opportunity for [product] to [value proposition].\n\n### Business Goals & KPIs\n| Goal | KPI | Target (6 months) |\n|------|-----|-------------------|\n| User acquisition | Monthly active users | 50,000 MAU |\n| Transaction volume | Daily transactions | 10,000/day |\n| Revenue | Transaction fees | <fee structure TBD> |\n| Retention | D30 retention rate | > 40% |\n| Compliance | KYC completion rate | > 80% within 24h |\n\n### In-Scope\n- User registration and KYC\n- Wallet management (top-up, withdrawal)\n- P2P transfers\n- Transaction history and receipts\n- PIN and biometric authentication\n- Push notifications\n- Admin portal (basic)\n\n### Out-of-Scope (for this phase)\n- Merchant onboarding portal\n- Credit/lending features\n- Cryptocurrency\n- International remittance\n- Physical card issuance\n\n### Business Requirements (Grouped)\n**BR-AUTH: Authentication & Identity**\n- BR-AUTH-01: Users must complete KYC before transacting\n- BR-AUTH-02: PIN required for all financial transactions\n- BR-AUTH-03: Biometric login as optional convenience\n\n**BR-WALLET: Wallet Operations**\n- BR-WAL-01: Users can top up from linked bank accounts\n- BR-WAL-02: Users can transfer to other wallet users\n- BR-WAL-03: Users can view real-time balance\n- BR-WAL-04: All transactions generate receipts\n\n**BR-COMP: Compliance**\n- BR-COMP-01: System must comply with BOT e-money regulations\n- BR-COMP-02: Transaction data retained per PDPA requirements\n- BR-COMP-03: Suspicious transaction monitoring and reporting\n\n### Business Risks & Assumptions\n| # | Type | Description | Mitigation |\n|---|------|-------------|-----------|\n| R1 | Risk | Regulatory changes may require feature modification | Modular architecture, compliance buffer |\n| R2 | Risk | Low KYC completion rate blocks activation | Streamlined UX, progressive KYC |\n| A1 | Assumption | Bank API integration available | Confirm with partner banks |\n| A2 | Assumption | Users have smartphones with internet | Target urban demographics first |\n```\n\n### Phase 4: SRS (Software Requirements Specification)\n\n```markdown\n## SRS — Functional Requirements\n\n### Module: AUTH\n| ID | Requirement | Input | Output | Precondition | Postcondition |\n|----|------------|-------|--------|-------------|---------------|\n| FR-AUTH-01 | Register with phone number | phone, OTP | user account created | phone not registered | account in PENDING_KYC state |\n| FR-AUTH-02 | Complete KYC | ID photo, selfie | KYC status updated | account exists | status → VERIFIED or REJECTED |\n| FR-AUTH-03 | Set transaction PIN | 6-digit PIN | PIN stored (hashed) | KYC verified | PIN active |\n| FR-AUTH-04 | Login with biometric | fingerprint/face | session token | biometric enrolled | user authenticated |\n\n### Module: WALLET\n| ID | Requirement | Input | Output | Precondition | Postcondition |\n|----|------------|-------|--------|-------------|---------------|\n| FR-WAL-01 | Check balance | user_id | balance amount | authenticated | — |\n| FR-WAL-02 | Top up from bank | amount, bank_account | balance increased | KYC verified, bank linked | transaction recorded |\n| FR-WAL-03 | P2P transfer | recipient, amount, PIN | both balances updated | sufficient balance, valid PIN | transaction recorded, notifications sent |\n| FR-WAL-04 | View transaction history | user_id, filters | paginated list | authenticated | — |\n\n### Validation Rules\n- PIN: exactly 6 digits, no sequential (123456), no repeated (111111)\n- Transfer amount: min 1 THB, max 50,000 THB per transaction, daily limit 200,000 THB\n- Phone: Thai mobile format (+66XXXXXXXXX)\n- KYC documents: JPEG/PNG, max 10MB, readable quality\n\n### API Outline\n| Method | Endpoint | Purpose |\n|--------|----------|---------|\n| POST | /auth/register | Phone + OTP registration |\n| POST | /auth/verify-otp | OTP verification |\n| POST | /auth/kyc | Submit KYC documents |\n| POST | /auth/pin | Set/change PIN |\n| GET | /wallet/balance | Get current balance |\n| POST | /wallet/topup | Top up from bank |\n| POST | /wallet/transfer | P2P transfer |\n| GET | /wallet/transactions | Transaction history |\n\n### Integration Requirements\n| External System | Protocol | Purpose |\n|----------------|----------|---------|\n| Bank APIs | REST + OAuth2 | Top-up, withdrawal |\n| KYC Provider | REST + webhook | Identity verification |\n| SMS Gateway | REST | OTP delivery |\n| Push Service | FCM/APNS | Notifications |\n| Fraud Engine | Event stream | Real-time scoring |\n\n### Cross-Cutting Concerns\n- **Security**: JWT tokens (15min access, 7d refresh), rate limiting (5 OTP/hour), request signing\n- **Logging**: Structured JSON, transaction audit trail, PII masking in logs\n- **Monitoring**: Health checks, latency dashboards, error rate alerts, transaction anomaly detection\n- **Localization**: Thai (default), English, date/currency formatting per locale\n```\n\n### Phase 5: Figma-Ready UX/UI Blueprint\n\n```markdown\n## UX/UI Blueprint\n\n### Key Flows\n1. Onboarding: Splash → Phone Input → OTP → KYC Upload → PIN Setup → Home\n2. Transfer: Home → Send → Recipient → Amount → Confirm (PIN) → Success\n3. Top-up: Home → Top-up → Bank Select → Amount → Confirm → Success\n4. History: Home → Transactions → Filter → Detail → Receipt\n\n### Screen Inventory\n| Screen | States |\n|--------|--------|\n| Splash | Loading, Update Required |\n| Phone Input | Empty, Typing, Validating, Error (invalid format), Error (already registered) |\n| OTP Verification | Waiting, Typing, Verifying, Error (wrong OTP), Error (expired), Resend cooldown |\n| KYC Upload | Empty, Camera active, Preview, Uploading, Success, Error (unreadable), Rejected |\n| PIN Setup | Empty, Entering, Confirming, Mismatch error, Success |\n| Home | Normal (with balance), Empty (no transactions), Loading, Error (network), KYC Pending banner |\n| Send Money | Recipient search, Amount input, Confirm modal, Processing, Success + receipt, Error (insufficient), Error (network) |\n| Transaction History | List view, Empty state, Loading skeleton, Filter panel, Pull-to-refresh |\n| Transaction Detail | Normal, Dispute button, Disputed status |\n| Settings | Profile, Security (PIN change, biometric toggle), Linked banks, Language, Logout |\n\n### Core Components\n- **Balance Card** — prominent balance display with hide toggle\n- **Quick Actions** — Send, Top-up, Pay, History (icon grid)\n- **Transaction Row** — icon + name + amount + time + status badge\n- **PIN Pad** — custom numeric keyboard with biometric shortcut\n- **Receipt Card** — shareable transaction receipt\n- **Status Badge** — Success (green), Pending (amber), Failed (red)\n- **Empty State** — illustration + message + CTA button\n- **Skeleton Loader** — placeholder shimmer matching content layout\n\n### Navigation Pattern\n- Bottom tab bar: Home, Pay, History, Profile\n- Modal sheets for confirmations and PIN entry\n- Stack navigation within each tab\n- No drawer menu (mobile wallet convention)\n\n### UX Guidelines\n- One primary action per screen\n- Confirm before any financial action (amount → confirm → PIN → done)\n- Show loading states for ALL async operations\n- Error messages must be actionable: \"Insufficient balance. Top up?\" not \"Error 402\"\n- Biometric prompt before PIN pad (convenience first)\n- Receipt always auto-generated and shareable\n```\n\n### Phase 6: PBIs (Product Backlog Items)\n\nGenerate INVEST-compliant PBIs with multi-role readiness:\n\n```markdown\n## PBI Example\n\n### PBI-001: User Registration with Phone Number\n**Type:** User Story\n**Epic:** Onboarding\n\n**Story:** As a new user, I want to register with my phone number so that I can create a wallet account.\n\n**Business Value:** Foundation for all other features — no registration = no users.\n\n**Acceptance Criteria:**\n1. Given a valid Thai phone number (+66XXXXXXXXX), when I submit, then I receive an OTP via SMS within 30 seconds\n2. Given an already-registered phone, when I submit, then I see \"This number is already registered. Login instead?\" with a login link\n3. Given an invalid phone format, when I submit, then I see inline validation \"Please enter a valid Thai phone number\"\n4. Given OTP sent, when 60 seconds pass without verification, then the OTP expires and I can request a new one\n5. Given correct OTP, when I verify, then my account is created with status PENDING_KYC\n\n**QA Notes:**\n- Positive: valid phone → OTP received → verify → account created\n- Negative: invalid format, already registered, wrong OTP, expired OTP, network timeout\n- Boundary: OTP at exactly 60s, phone with leading zero vs +66, max OTP retries (5)\n- Data: test with real carrier numbers (AIS, DTAC, TRUE prefixes)\n\n**DEV Notes:**\n- Service: auth-service\n- API: POST /auth/register, POST /auth/verify-otp\n- DB: Create user record (status: PENDING_KYC), store OTP hash with TTL\n- SMS: Integrate with SMS gateway (rate limit: 5 OTP/hour/phone)\n- Error handling: SMS delivery failure → show \"SMS not delivered, try again\" with retry button\n- Idempotency: same phone + same session → return existing OTP, don't create duplicate\n\n**Figma Mapping:**\n- Screens: Phone Input, OTP Verification\n- States: Empty, Typing, Validating, Error (3 variants), Resend cooldown timer\n- Components: Phone input field with +66 prefix, OTP 6-digit input, Countdown timer, Error toast\n\n**Dependencies:** SMS Gateway integration (PBI-TECH-01)\n**Risks:** SMS delivery delays in rural areas\n**Assumptions:** User has active Thai mobile number\n**Research Note:** PromptPay registration uses similar phone-first flow; industry standard in Thai fintech\n```\n\n### Phase 7: Role-Based Summary\n\n```markdown\n## What Each Role Can Start Doing Now\n\n### PM / BA\n- Review feature landscape and challenge priorities\n- Validate business goals and KPIs with stakeholders\n- Refine out-of-scope decisions\n- Create Jira epics from the PBI groupings\n\n### UX / Figma Designers\n- Build Figma frames from the Screen Inventory\n- Design all listed states (empty, loading, error, success)\n- Create component library from Core Components list\n- Prototype the 4 key flows\n\n### Developers\n- Set up project scaffolding (API gateway, auth service, wallet service)\n- Implement PBIs in suggested priority order\n- Use API outline for contract-first development\n- Reference DEV notes in each PBI for service/data details\n\n### QA\n- Write test cases from acceptance criteria (already Given/When/Then)\n- Use QA notes for edge cases and boundary testing\n- Set up test data for Thai phone numbers, OTP scenarios\n- Plan integration tests for bank API and KYC provider\n\n### Compliance / Security\n- Review regulatory requirements (BR-COMP-01 through 03)\n- Validate KYC flow against BOT requirements\n- Review data retention policy alignment with PDPA\n- Assess fraud detection requirements\n```\n\n### Phase 8: Open Questions & Gaps\n\n```markdown\n## Open Questions & Gaps\n\n| # | Question | Owner | Impact if Unresolved |\n|---|---------|-------|---------------------|\n| Q1 | Which KYC provider will be used? (NDID, manual, third-party) | PM + Compliance | Blocks KYC flow design |\n| Q2 | Exact transaction fee structure? | Business | Affects transfer flow UX |\n| Q3 | Which banks for initial top-up integration? | PM + Partnerships | Blocks top-up feature |\n| Q4 | Daily/monthly transaction limits per user tier? | Compliance | Affects validation rules |\n| Q5 | Dispute resolution SLA? | Operations | Affects dispute flow design |\n| Q6 | Multi-currency support in v1? | PM | Affects data model complexity |\n\n⚠️ **Compliance Notice:** This specification covers a regulated financial product.\nAll requirements marked BR-COMP-* must be reviewed by legal and compliance teams\nbefore implementation. This document does not constitute legal or regulatory advice.\n```\n\n## Output Structure\n\nWhen this skill is triggered, produce all 9 sections in order:\n\n1. **Context Recap & Assumptions** — parsed brief + marked assumptions\n2. **Research Insights & Feature Landscape** — must-have / nice-to-have / experimental / not-recommended\n3. **Super System Analysis** — stakeholders, journeys, context, components, data, NFRs\n4. **BRD** — problem, goals, KPIs, scope, grouped requirements, risks\n5. **SRS** — functional requirements per module, validation, APIs, data model, integrations, cross-cutting\n6. **UX/UI Blueprint** — flows, screens, states, components, navigation, guidelines (Figma-ready)\n7. **PBIs** — INVEST-compliant, grouped by epic, each with: AC, QA notes, DEV notes, Figma mapping\n8. **Role Summary** — what PM, UX, Dev, QA, Compliance can start doing immediately\n9. **Open Questions** — what the real team must still decide\n\n## Formatting Rules\n\n- Mirror user's language for body text (Thai/English)\n- Keep framework terms in English: BRD, SRS, PBI, INVEST, MVP, KPI, API\n- Use requirement IDs: BR-XXX-NN (business), FR-XXX-NN (functional), NFR-XXX-NN (non-functional)\n- Use PBI IDs: PBI-NNN for stories, PBI-TECH-NNN for tech enablers, PBI-UX-NNN for design tasks\n- Tables for structured data, prose for narratives\n- Mermaid sequence diagrams for complex flows when helpful\n\n## Safety & Compliance Rules\n\n- **Never invent** confidential data, exact contracts, internal numbers, or real customer details\n- Use placeholders: `<fee structure TBD>`, `<provider name TBD>`, `<legal review required>`\n- For regulated domains (finance, health, safety, privacy): stay high-level on compliance, add explicit review notices\n- **Never provide** legal, medical, or investment advice\n- Always include the compliance notice in the Open Questions section for regulated products\n\n## Integration with AEGIS\n\n- **Owned by:** 📐 Sage (primary), with input from 🖌️ Pixel (UX sections)\n- **Feeds into:** ⚡ Bolt (DEV notes → implementation), 🛡️ Vigil (AC → test cases), 🔧 Forge (PBIs → sprint-tracker)\n- **Enhanced by:** Research via web search (when available)\n- **Chained from:** `project-navigator` recommends super-spec for new products\n- **Chained to:** `code-standards` (after spec, before implementation)\n\nThis is the most comprehensive skill in AEGIS. One prompt → entire team can start working.\n"}]},"parent_tool_use_id":null,"session_id":"c0011f36-8c58-4ee0-a5e7-96a51a280338","uuid":"53d4f957-656b-4c82-9db8-bbdb2e527487","timestamp":"2026-04-03T07:11:37.520Z","isSynthetic":true}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_018MS6Ty79SnYd8v9Q714djS","type":"message","role":"assistant","content":[{"type":"thinking","thinking":"Now I understand the super-spec skill. I need to conduct Phase A with the human user - asking 10 structured questions about what they want to build, then produce BRD + SRS + UX Blueprint.\n\nThe task description says \"Phase A: Sage conducts structured Q&A (10 questions) with human.\" Let me ask the user 10 structured questions to gather requirements for the spec.\n\nI'll ask 10 questions via AskUserQuestion, but that tool only supports 1-4 questions at a time. Let me start with the most essential questions and gather what I need. \n\nActually, I should ask the questions conversationally rather than all at once. \n\nI'm realizing there's some ambiguity here - the title mentions creating a specification template, but the description clearly indicates I should be gathering requirements from the user about what they want to build. Let me clarify by asking what product or feature they're looking to specify.","signature":"EucLClsIDBgCKkCiVYdsKgqYrjqr4zfKS1xruTnjIvltWmYf4eXgXofh32QX2BVQLV2OH8N+IgCmjlHmGkOkj4SvckoaLaVWozbzMhFjbGF1ZGUtc29ubmV0LTQtNjgAEgxMXs59gu4MVo7dI3waDL/K3/pMW+a1AbabWiIwCMi7fSFn4yCOnhJrTdzQ2Vm9d9VIUzkd0WlRQxHdsFDq7pj4/QNMI/soNeyepCO+KrkKmUHhhVvafb5G3jZtHKOR21MpCtUQH6C8n7G4ocVZII4lhQbz9yBJj6M4STbY08Cz1QiB0XWBuJSyG0Sa/L+IfkSPthyjEZfvtgNZdskIhQec4qgoFzE3pHtOg/StxbfbGlnlFalougjMAz5N6ZE6WpCFSFouaS6yQzjYPu6CtgzfLYsGO5sFC6V9a4l9DijQhwe+bWLf55zaa0/37T8fIy4e9vrYyla0ZcaS7H6qlyg5Ra1Df9BLbawo2Kt5aSICkN7HK2FXMbbB9aWquXvJlwQEStyovyxGq8fY+HWlVPBYrZvcM3qxOX+9ZdAzGItktJBhRj6+DsMW2gD0ll0Xa38AGGUGUQo3+3PYePmIw3IUExLpILiVB64e4zJ7ukdhIWo803HqThgul36ZRBkvq8OQ2wQOdz0FAeKy+kvDRvMAebMPA8/Wg9VYVy6d7l2FYwKU8XP0GpEvOBQZrJeOmBaHsHr0T7KhVl3ayPXUIxa5jWuriePhknst3ZaFxx9UnIYibRN2MJB4yetzClgWoaD+WzLkEAWckcvOKgWi4HQyDtujXPUbpaaA/YLnVq7nJlt1wf57hsCEbu95HXO+qcnPj+xX+Oh7R8C+fCttpgMaGQPXSxsco49q71C7Kg9vSia3Htcn/fYP4CkqU61f62o5qLG5NlBQUC9yvqRYeTLHWSU0fdgRmx7ylJFM+0TFRvCuryOkjV/qmVolMWyMfK8xPEK2WO+0QXMU8EeZ5N38LDDBGB/xMsw7TmF1UU5YZcJH+Nv5hFL2SmZjn4JonbGt0OuUmDfyEtezqyeWu2DJh/Eu5KMQfqo6gGlexwHqoT2RsLRVi7MMoLmNAtt0domV4nJtw/ayklyAbDuj1oUFcFxJPbRBIqZk6O/r+FIFq7FWOXAsGyeBZhOrtWVPb5bHwO+mwalb62S38L9ZSBHSZKfe69hlPUaHsHiJ5JGqgEJHoHDj7ytShArsx2v3Bq9nyq3vN0USU2jlQ6Ga4mmY4c8Oq/P3Zng9fwly1HUSdf2D60kisfYrxm5nsMqLwM2nMbP7TvNJBGqvxLCbVEhwc/1GX1YP6DM6C465K8l62HvsScLPtqAmyjB6SzNAsta12Z0leiTukDwWGSJh/Nt0Vmp6evHsURzDOl6Dqs3dAUBOlIgDvt2PLZdvBkpqb9lyfv/XR8JmLwMk3PAULAFyNvpSngNfZclMhN8lBp2nHABXLFNF681bGRvQxXnU+4HzjnD6L+CyX/7uXX4JcjPmQ8ctBhxUjAXaINml5WCrriPs7SCOgLBhhJsD/+D4GAhFzmDIHFHqAhDokycoJYlCeY4/7fY4wN2goX1RhxkDm4JBCadduN3h3FlqjgbbnnCrTDVCe/WE/cOYQiu8FJlXI6dQ0R8Lu3fdFHz083Ke4mVdmst0nRXiwiDZOUGOO/sTgdv3o82U/47OLFV9xqLzCqCH7DSVEBmbdX0vJ3VFUHo0HQ0kpbdfaXgeeVAvzuVoBgfdbpcLiUIQewZhZ8Pu2ACN0tkytBRfnih1eUVa5qWCsHVQAXi5FSk5/0xOPyN67PVnBXf13UXWgB461QmuTvwtu3MgBJq6PWoDYikn/eqQyd2NPB8X7g9hxxfmNTYxdvT0+uzo+OqXWkhVUfv1YTJ/MVIXSRvvHjTX3/mrGbQjWHThtUpuJ1ZRq0mgXxGXMZiAslEWWuyWLC7+DfPr/7JcHDJ6Qpxcxg9WUv9XuqsI/jnK0urVqxhsSqvYgMNolmJ5sJ56q5HoTUqrWoHw4IsUYcApQXQYAQ=="}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":2,"cache_creation_input_tokens":6697,"cache_read_input_tokens":41820,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":6697},"output_tokens":8,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"c0011f36-8c58-4ee0-a5e7-96a51a280338","uuid":"c9b8e8ff-0d86-4887-94c2-c6c98bd4c89e"}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_018MS6Ty79SnYd8v9Q714djS","type":"message","role":"assistant","content":[{"type":"text","text":"I'm ready to conduct the Phase A Q&A. Let me gather the essential information across a few rounds of questions."}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":2,"cache_creation_input_tokens":6697,"cache_read_input_tokens":41820,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":6697},"output_tokens":8,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"c0011f36-8c58-4ee0-a5e7-96a51a280338","uuid":"4710c602-dbe1-4205-bd02-a6b0389dab6c"}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_018MS6Ty79SnYd8v9Q714djS","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01VoZgjiQyuRdQHegTEpEc61","name":"AskUserQuestion","input":{"questions":[{"question":"What product or feature do you want to build? (e.g., \"digital wallet\", \"e-commerce checkout\", \"AI customer support bot\")","header":"Product Idea","multiSelect":false,"options":[{"label":"I'll describe it below","description":"Type your product idea in the 'Other' field"},{"label":"Mobile app","description":"A mobile-first application"},{"label":"Web platform","description":"A web-based SaaS or portal"},{"label":"API / Backend service","description":"A headless service or integration layer"}]},{"question":"Who are the primary users?","header":"Target Users","multiSelect":false,"options":[{"label":"Consumers (B2C)","description":"General public, end users"},{"label":"Businesses (B2B)","description":"Companies, teams, or professionals"},{"label":"Internal teams","description":"Employees, ops, or admin staff"},{"label":"Mixed","description":"Multiple user types"}]},{"question":"What stage is this product at?","header":"Stage","multiSelect":false,"options":[{"label":"Brand new (MVP)","description":"Starting from zero — need to define everything"},{"label":"Existing product, new feature","description":"Adding a major module to something that exists"},{"label":"Rewrite / migration","description":"Replacing or modernizing an existing system"},{"label":"Research / pre-funding","description":"Exploring the concept, not yet building"}]},{"question":"What is the primary market or region?","header":"Market","multiSelect":false,"options":[{"label":"Thailand / SEA","description":"Southeast Asia focus"},{"label":"Global / US","description":"International or US-first"},{"label":"Europe","description":"EU market with GDPR considerations"},{"label":"Other / Not sure","description":"Specify in Other or leave open"}]}]},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":2,"cache_creation_input_tokens":6697,"cache_read_input_tokens":41820,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":6697},"output_tokens":8,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"c0011f36-8c58-4ee0-a5e7-96a51a280338","uuid":"7ffea4fe-740d-45b1-a744-70b1b6f0569b"}
{"type":"user","message":{"role":"user","content":[{"type":"tool_result","content":"Answer questions?","is_error":true,"tool_use_id":"toolu_01VoZgjiQyuRdQHegTEpEc61"}]},"parent_tool_use_id":null,"session_id":"c0011f36-8c58-4ee0-a5e7-96a51a280338","uuid":"e5d48c84-c859-43d2-a9fc-0a96ec874d2f","timestamp":"2026-04-03T07:11:56.748Z","tool_use_result":"Error: Answer questions?"}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_011iFSuvHBu97RzJ7svZLGDF","type":"message","role":"assistant","content":[{"type":"thinking","thinking":"The user didn't answer the questions. Let me try a different approach - maybe I should just present the questions as text and wait for the user to respond. Let me ask them directly in text.","signature":"EvsCClsIDBgCKkDOeJlb9UiYIcfQTVg78lgO4xIAfDu/DgEAT4AchkoA8k5R4YWZVe0HZ3bxsRRfwZBg6OpZBvBx8mNHe6TEPuEoMhFjbGF1ZGUtc29ubmV0LTQtNjgAEgzCMCv3CXyMsLnxtdAaDIcQ6s7O91YREW4+5SIwDPBPLJdkeQ1UH7P6pfZP/90PojX5Yb7nexeyloOEG+7lGoaYs0xy3JDOj79sA474Ks0Bit+Ba08PFVz6zM8iYCSSO0ptXnxAQK/tPXJn9y4hA8M5ptDXWYseMcDzPTAqTNQ+uLmvDgGM9Lxkt00wVkdfirleMsqzpZAvP201CMBfZOrfKMhccl5OwrqnV12Y5eAFulicBDgQXgoPuMQaRbX99ktkmWXjUTPUL9ez/du9KlxTbUhXqIqDssx5WLwZpYGAJZojtkKB3HsjDOReehbFYwbLnREoUyIlHLRSlq32oa9nagItKS7z/R2j0F/B6Hmo3xW7tt5H+WEr/lTEFRgB"}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":930,"cache_read_input_tokens":48517,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":930},"output_tokens":8,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"c0011f36-8c58-4ee0-a5e7-96a51a280338","uuid":"030a0490-33de-4401-a90d-792caab413b8"}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_011iFSuvHBu97RzJ7svZLGDF","type":"message","role":"assistant","content":[{"type":"text","text":"**Phase A — Requirements Q&A (10 questions)**\n\nI'm Sage, and I'll be guiding you through a structured discovery session to produce your BRD + SRS + UX Blueprint. Please answer the following questions:\n\n---\n\n**Q1. What is the product or feature you want to build?**\n(Be as brief or detailed as you like — even \"digital wallet\" or \"task manager for teams\" is enough to start.)\n\n**Q2. Who are the primary users?**\n(e.g., consumers, B2B customers, internal ops team, mixed)\n\n**Q3. What is the core problem this product solves?**\n(What pain point or gap does it address?)\n\n**Q4. What stage is this at?**\n(MVP from scratch / adding a feature to an existing product / rewrite / research/pre-funding)\n\n**Q5. What is the primary market or region?**\n(Thailand/SEA, Global, EU, other)\n\n**Q6. What are the 2–3 most important things the product MUST do?**\n(The non-negotiables for v1)\n\n**Q7. What is explicitly OUT of scope for this phase?**\n(What should we intentionally leave for later?)\n\n**Q8. Are there any tech constraints or preferences?**\n(e.g., mobile-first, React Native, existing backend in Node.js, must use AWS, etc.)\n\n**Q9. Are there any regulatory or compliance concerns?**\n(e.g., financial regulations, PDPA/GDPR, healthcare data, age restrictions)\n\n**Q10. What does success look like in 6 months?**\n(Key metrics, outcomes, or milestones that would confirm this was worth building)\n\n---\n\nTake your time — more detail = better spec. Once you answer, I'll produce the full BRD + SRS + UX Blueprint."}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":930,"cache_read_input_tokens":48517,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":930},"output_tokens":8,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"c0011f36-8c58-4ee0-a5e7-96a51a280338","uuid":"fe24ed94-8966-4451-9861-138a281097e5"}
{"type":"result","subtype":"success","is_error":false,"duration_ms":173670,"duration_api_ms":94614,"num_turns":22,"result":"**Phase A — Requirements Q&A (10 questions)**\n\nI'm Sage, and I'll be guiding you through a structured discovery session to produce your BRD + SRS + UX Blueprint. Please answer the following questions:\n\n---\n\n**Q1. What is the product or feature you want to build?**\n(Be as brief or detailed as you like — even \"digital wallet\" or \"task manager for teams\" is enough to start.)\n\n**Q2. Who are the primary users?**\n(e.g., consumers, B2B customers, internal ops team, mixed)\n\n**Q3. What is the core problem this product solves?**\n(What pain point or gap does it address?)\n\n**Q4. What stage is this at?**\n(MVP from scratch / adding a feature to an existing product / rewrite / research/pre-funding)\n\n**Q5. What is the primary market or region?**\n(Thailand/SEA, Global, EU, other)\n\n**Q6. What are the 2–3 most important things the product MUST do?**\n(The non-negotiables for v1)\n\n**Q7. What is explicitly OUT of scope for this phase?**\n(What should we intentionally leave for later?)\n\n**Q8. Are there any tech constraints or preferences?**\n(e.g., mobile-first, React Native, existing backend in Node.js, must use AWS, etc.)\n\n**Q9. Are there any regulatory or compliance concerns?**\n(e.g., financial regulations, PDPA/GDPR, healthcare data, age restrictions)\n\n**Q10. What does success look like in 6 months?**\n(Key metrics, outcomes, or milestones that would confirm this was worth building)\n\n---\n\nTake your time — more detail = better spec. Once you answer, I'll produce the full BRD + SRS + UX Blueprint.","stop_reason":"end_turn","session_id":"c0011f36-8c58-4ee0-a5e7-96a51a280338","total_cost_usd":0.39417764999999994,"usage":{"input_tokens":25,"cache_creation_input_tokens":27021,"cache_read_input_tokens":761113,"output_tokens":4296,"server_tool_use":{"web_search_requests":0,"web_fetch_requests":0},"service_tier":"standard","cache_creation":{"ephemeral_1h_input_tokens":27021,"ephemeral_5m_input_tokens":0},"inference_geo":"","iterations":[],"speed":"standard"},"modelUsage":{"claude-sonnet-4-6":{"inputTokens":25,"outputTokens":4296,"cacheReadInputTokens":761113,"cacheCreationInputTokens":27021,"webSearchRequests":0,"costUSD":0.39417764999999994,"contextWindow":200000,"maxOutputTokens":32000}},"permission_denials":[{"tool_name":"AskUserQuestion","tool_use_id":"toolu_01VoZgjiQyuRdQHegTEpEc61","tool_input":{"questions":[{"question":"What product or feature do you want to build? (e.g., \"digital wallet\", \"e-commerce checkout\", \"AI customer support bot\")","header":"Product Idea","options":[{"label":"I'll describe it below","description":"Type your product idea in the 'Other' field"},{"label":"Mobile app","description":"A mobile-first application"},{"label":"Web platform","description":"A web-based SaaS or portal"},{"label":"API / Backend service","description":"A headless service or integration layer"}],"multiSelect":false},{"question":"Who are the primary users?","header":"Target Users","options":[{"label":"Consumers (B2C)","description":"General public, end users"},{"label":"Businesses (B2B)","description":"Companies, teams, or professionals"},{"label":"Internal teams","description":"Employees, ops, or admin staff"},{"label":"Mixed","description":"Multiple user types"}],"multiSelect":false},{"question":"What stage is this product at?","header":"Stage","options":[{"label":"Brand new (MVP)","description":"Starting from zero — need to define everything"},{"label":"Existing product, new feature","description":"Adding a major module to something that exists"},{"label":"Rewrite / migration","description":"Replacing or modernizing an existing system"},{"label":"Research / pre-funding","description":"Exploring the concept, not yet building"}],"multiSelect":false},{"question":"What is the primary market or region?","header":"Market","options":[{"label":"Thailand / SEA","description":"Southeast Asia focus"},{"label":"Global / US","description":"International or US-first"},{"label":"Europe","description":"EU market with GDPR considerations"},{"label":"Other / Not sure","description":"Specify in Other or leave open"}],"multiSelect":false}]}}],"terminal_reason":"completed","fast_mode_state":"off","uuid":"800f194c-fccf-410f-9f29-dfe3574c248d"}
$paperclip$, $paperclip$$paperclip$, NULL, 38048, $paperclip$2026-04-03T07:09:13.778Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$automation$paperclip$, $paperclip$succeeded$paperclip$, $paperclip$2026-04-03T07:15:07.825Z$paperclip$, $paperclip$2026-04-03T07:17:10.807Z$paperclip$, NULL, NULL, $paperclip${"source":"approval.approved","taskId":"af75be97-329e-4d28-80d9-27b03db4f7c6","issueId":"af75be97-329e-4d28-80d9-27b03db4f7c6","taskKey":"af75be97-329e-4d28-80d9-27b03db4f7c6","issueIds":["af75be97-329e-4d28-80d9-27b03db4f7c6"],"projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","approvalId":"8112ed6e-4eae-4360-9ac1-c5e88764c1b5","wakeReason":"approval_approved","wakeSource":"automation","approvalStatus":"approved","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","mode":"shared_workspace","source":"project_primary","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/1e6d0b76-3817-4502-901e-7dd1356cd771","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[],"executionWorkspaceId":"474acb14-54f2-4547-a389-66b4b881c5ad"}$paperclip$, $paperclip$2026-04-03T07:15:07.815Z$paperclip$, $paperclip$2026-04-03T07:17:10.807Z$paperclip$, $paperclip$system$paperclip$, $paperclip$740b95a5-1a9e-41d3-aa72-75de1791ccf2$paperclip$, 0, NULL, $paperclip${"model":"claude-opus-4-6","biller":"anthropic","costUsd":0.9727009999999999,"provider":"anthropic","billingType":"subscription_included","inputTokens":20,"usageSource":"session_delta","freshSession":false,"outputTokens":5323,"sessionReused":true,"rawInputTokens":20,"sessionRotated":false,"rawOutputTokens":5323,"cachedInputTokens":308483,"taskSessionReused":true,"persistedSessionId":"60e284df-eb26-46b8-8507-391b2bddce9d","rawCachedInputTokens":1116727,"sessionRotationReason":null}$paperclip$, $paperclip${"type":"result","uuid":"8b7e5c82-6690-4274-be94-efa4903d2309","usage":{"speed":"standard","iterations":[],"input_tokens":20,"service_tier":"standard","inference_geo":"","output_tokens":5323,"cache_creation":{"ephemeral_1h_input_tokens":44986,"ephemeral_5m_input_tokens":0},"server_tool_use":{"web_fetch_requests":0,"web_search_requests":0},"cache_read_input_tokens":1116727,"cache_creation_input_tokens":44986},"result":"Heartbeat 2 complete. Summary:\n\n- **CTO hire approved** — Navi is active\n- **AEGA-2 created** and assigned to Navi: build org, plan Sprint 1, drive spec creation\n- **AEGA-1 unblocked** — now in_progress, waiting for Navi to engage\n- **Next**: Navi picks up AEGA-2, assesses needed agents, requests hires. I'll submit hire requests as they come in.\n\nThe machine is moving. Navi should wake on the assignment and start planning.","subtype":"success","is_error":false,"num_turns":20,"modelUsage":{"claude-opus-4-6":{"costUSD":0.9727009999999999,"inputTokens":20,"outputTokens":5323,"contextWindow":200000,"maxOutputTokens":64000,"webSearchRequests":0,"cacheReadInputTokens":1116727,"cacheCreationInputTokens":44986}},"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","duration_ms":121830,"stop_reason":"end_turn","total_cost_usd":0.9727009999999999,"duration_api_ms":120289,"fast_mode_state":"off","terminal_reason":"completed","permission_denials":[]}$paperclip$, $paperclip$60e284df-eb26-46b8-8507-391b2bddce9d$paperclip$, $paperclip$60e284df-eb26-46b8-8507-391b2bddce9d$paperclip$, $paperclip$local_file$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af/1e6d0b76-3817-4502-901e-7dd1356cd771/d1c08dfe-79d2-4b00-bebe-cf556cb7b15e.ndjson$paperclip$, $paperclip$75973$paperclip$, $paperclip$34d6b3d0e0f9737bbc05d949579d5b912e1d1f85a417110988ba01434ba43645$paperclip$, false, $paperclip$-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default.","is_error":true,"tool_use_id":"toolu_01GbzhG9vHohZBNQuzPgwUmB"}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"420134d0-7c3b-44d1-81b3-1af16bf7380f","timestamp":"2026-04-03T07:15:57.780Z","tool_use_result":"Error: File does not exist. Note: your current working directory is /Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default."}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01KpoV47EQxRnmd9vfjm4eTx","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_018udRv6PxHa8pPKP6jQGKGU","name":"Glob","input":{"pattern":"**/skills/paperclip/references/api-reference.md","path":"/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":388,"cache_read_input_tokens":63951,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":388},"output_tokens":56,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"57fdf814-c1d6-4ad9-bf57-8fe92d13bf56"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_018udRv6PxHa8pPKP6jQGKGU","type":"tool_result","content":"No files found"}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"743ff0e0-838f-478b-8016-5d703bf76ac1","timestamp":"2026-04-03T07:16:01.904Z","tool_use_result":{"filenames":[],"durationMs":336,"numFiles":0,"truncated":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_012QxZVUw22antxHAu485Rrt","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01UhjDZhK1ncFmsoWsqNxXYQ","name":"Bash","input":{"command":"find /var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-* -name \"api-reference.md\" 2>/dev/null | head -5","description":"Find API reference file"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":126,"cache_read_input_tokens":64339,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":126},"output_tokens":67,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"30ef9e41-e732-4eb7-ac53-19c89e464b35"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01UhjDZhK1ncFmsoWsqNxXYQ","type":"tool_result","content":"(Bash completed with no output)","is_error":false}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"9289254b-dd46-4b7b-b701-5ffc76c3e229","timestamp":"2026-04-03T07:16:05.461Z","tool_use_result":{"stdout":"","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01Tx5RiZu4YB2KUyUQXuzmGT","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01UH2bmBdcUDeFETV2JejdEy","name":"Bash","input":{"command":"find /var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-* -type f -name \"*.md\" 2>/dev/null | head -20","description":"Find available skill docs"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":146,"cache_read_input_tokens":64465,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":146},"output_tokens":73,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"273debd7-f68a-40c3-8af1-803729e4d62c"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01UH2bmBdcUDeFETV2JejdEy","type":"tool_result","content":"/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-iRuj9q/agent-instructions.md","is_error":false}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"8bcd03dd-7308-4a1c-9d9b-65c0e0f51310","timestamp":"2026-04-03T07:16:09.454Z","tool_use_result":{"stdout":"/var/folders/zh/dt5fd8y14j977lppwlb773jh0000gn/T/paperclip-skills-iRuj9q/agent-instructions.md","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01ESxD9a2DpY25cQbMUM4Hwi","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_015FUL2are8PQEtSzMHkXzhk","name":"Bash","input":{"command":"ls -la ~/.claude/skills/paperclip/references/ 2>/dev/null || ls -la ~/.claude/skills/ 2>/dev/null | head -20","description":"Check skill references"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":186,"cache_read_input_tokens":64611,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":186},"output_tokens":51,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"82d6267b-ada8-4b7c-91bb-54d43839c84e"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_015FUL2are8PQEtSzMHkXzhk","type":"tool_result","content":"total 96\ndrwxr-xr-x@ 5 phariyawit.jiap  staff    160 Apr  3 13:05 .\ndrwxr-xr-x@ 4 phariyawit.jiap  staff    128 Apr  3 13:05 ..\n-rw-r--r--@ 1 phariyawit.jiap  staff  29719 Apr  3 13:05 api-reference.md\n-rw-r--r--@ 1 phariyawit.jiap  staff   6731 Apr  3 13:05 company-skills.md\n-rw-r--r--@ 1 phariyawit.jiap  staff   5126 Apr  3 13:05 routines.md","is_error":false}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"b8ed5273-3b81-419f-ac95-a6c7c2d77cab","timestamp":"2026-04-03T07:16:12.874Z","tool_use_result":{"stdout":"total 96\ndrwxr-xr-x@ 5 phariyawit.jiap  staff    160 Apr  3 13:05 .\ndrwxr-xr-x@ 4 phariyawit.jiap  staff    128 Apr  3 13:05 ..\n-rw-r--r--@ 1 phariyawit.jiap  staff  29719 Apr  3 13:05 api-reference.md\n-rw-r--r--@ 1 phariyawit.jiap  staff   6731 Apr  3 13:05 company-skills.md\n-rw-r--r--@ 1 phariyawit.jiap  staff   5126 Apr  3 13:05 routines.md","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01SyTAP6wxJ2jZYKjbyjw66o","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_0134y9K6TQg6mmrMf4kpjxUT","name":"Bash","input":{"command":"grep -n -i \"grant\\|permission\\|canCreateAgents\" ~/.claude/skills/paperclip/references/api-reference.md | head -20","description":"Search for permission grants in API ref"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":310,"cache_read_input_tokens":64797,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":310},"output_tokens":42,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"413e07ef-83ec-4ce1-a944-8bcb2b646dbe"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_0134y9K6TQg6mmrMf4kpjxUT","type":"tool_result","content":"411:- board users with invite permission\n582:| 403  | Unauthorized       | You don't have permission for this action                            |","is_error":false}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"66f57daa-d1fe-4b7b-a670-8d55d8f06c3c","timestamp":"2026-04-03T07:16:16.508Z","tool_use_result":{"stdout":"411:- board users with invite permission\n582:| 403  | Unauthorized       | You don't have permission for this action                            |","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_015dSWihpBoziC6msfYd2zNJ","type":"message","role":"assistant","content":[{"type":"text","text":"Permissions aren't grantable via API by agents — it's a board-level setting on hire. I'll handle hiring myself since I have `canCreateAgents`. The efficient approach: create the key subtask for Navi (org build-out and spec creation), and I'll hire the critical first-wave agents Navi needs.\n\nLet me focus on what matters: get Navi working. I'll create a subtask for Navi to own the technical activation, and I'll create the first specialist hire (Sage for spec work) in parallel."}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":154,"cache_read_input_tokens":65107,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":154},"output_tokens":2,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"9d72dda2-7130-42ee-ae62-6278ec9575bc"}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_015dSWihpBoziC6msfYd2zNJ","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01L1hvZZxFSydF3xCshu7e2o","name":"TodoWrite","input":{"todos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtask for Navi to own technical activation","status":"in_progress","activeForm":"Creating subtask for Navi"},{"content":"Hire Sage (Specification Architect) for BRD/SRS work","status":"pending","activeForm":"Hiring Sage agent"},{"content":"Unblock AEGA-1 and update with Heartbeat 2 progress","status":"pending","activeForm":"Updating AEGA-1"}]},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":154,"cache_read_input_tokens":65107,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":154},"output_tokens":2,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"69f5b3f9-060f-42ea-b852-49e9a20f9744"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01L1hvZZxFSydF3xCshu7e2o","type":"tool_result","content":"Todos have been modified successfully. Ensure that you continue to use the todo list to track your progress. Please proceed with the current tasks if applicable"}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"1bae13d9-dfad-49c6-812e-1355a889af30","timestamp":"2026-04-03T07:16:26.054Z","tool_use_result":{"oldTodos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtasks for org build-out and Sprint 1 planning","status":"pending","activeForm":"Creating subtasks"},{"content":"Delegate spec creation to appropriate agent once team exists","status":"pending","activeForm":"Delegating spec creation"}],"newTodos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtask for Navi to own technical activation","status":"in_progress","activeForm":"Creating subtask for Navi"},{"content":"Hire Sage (Specification Architect) for BRD/SRS work","status":"pending","activeForm":"Hiring Sage agent"},{"content":"Unblock AEGA-1 and update with Heartbeat 2 progress","status":"pending","activeForm":"Updating AEGA-1"}],"verificationNudgeNeeded":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01CQkUyffQS3KEufoH25xwkP","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_014BsNRmMJKAj1r6MyYuLHKv","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_03945ccbef0d93f3031e1fc80f0805163ef0b55dcd1f88ca' && curl -sS -X POST \"$PAPERCLIP_API_URL/api/companies/$PAPERCLIP_COMPANY_ID/issues\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" \\\n  -H \"X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID\" \\\n  -H \"Content-Type: application/json\" \\\n  -d '{\n    \"title\": \"Build AEGIS org, create Sprint 1 plan, and delegate spec creation\",\n    \"description\": \"## Context\\nYou are Navi, CTO of AEGIS. Mother Brain (CEO) has activated the company and hired you as the first agent.\\n\\n## Current State\\n- Green-field: no code, no specs, no other agents besides you and CEO\\n- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline, 5-Gate Quality System, ISO 29110 compliance\\n- No BRD or SRS exists yet — this is the critical blocker\\n\\n## Your Mission\\n1. **Assess what agents are needed** for Sprint 1 (spec phase). At minimum: a Specification Architect (\\\"Sage\\\") to write BRD + SRS\\n2. **Request agent hires from CEO** — post comments on this task listing who you need hired, with role, capabilities, and rationale. CEO will submit hire requests.\\n3. **Once Sage is available**, create and assign a subtask for BRD + SRS specification using the super-spec skill\\n4. **Plan Sprint 1** — break the SDLC pipeline Phase A (IDEA → SPEC) into concrete tasks\\n5. **Report back** with your plan and any blockers\\n\\n## Constraints\\n- You cannot hire agents directly (no canCreateAgents permission). Request hires from CEO via comments.\\n- Use the paperclip skill for all coordination.\\n- Model routing: Opus thinks, Sonnet builds, Haiku gathers.\",\n    \"status\": \"todo\",\n    \"priority\": \"high\",\n    \"assigneeAgentId\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n    \"parentId\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n    \"goalId\": \"f37b9d3a-60c7-431a-a03d-b9eda150e5ae\",\n    \"projectId\": \"15cf70f4-7785-4fa2-8d79-abadf14d8bb8\"\n  }' | python3 -m json.tool","description":"Create subtask for Navi"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":413,"cache_read_input_tokens":65261,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":413},"output_tokens":73,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"23b54ccf-5d24-4080-8225-1023f765dd77"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_014BsNRmMJKAj1r6MyYuLHKv","type":"tool_result","content":"{\n    \"id\": \"d447cdfb-1655-41ba-b222-a7fad582e53c\",\n    \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n    \"projectId\": \"15cf70f4-7785-4fa2-8d79-abadf14d8bb8\",\n    \"projectWorkspaceId\": null,\n    \"goalId\": \"f37b9d3a-60c7-431a-a03d-b9eda150e5ae\",\n    \"parentId\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n    \"title\": \"Build AEGIS org, create Sprint 1 plan, and delegate spec creation\",\n    \"description\": \"## Context\\nYou are Navi, CTO of AEGIS. Mother Brain (CEO) has activated the company and hired you as the first agent.\\n\\n## Current State\\n- Green-field: no code, no specs, no other agents besides you and CEO\\n- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline, 5-Gate Quality System, ISO 29110 compliance\\n- No BRD or SRS exists yet \\u2014 this is the critical blocker\\n\\n## Your Mission\\n1. **Assess what agents are needed** for Sprint 1 (spec phase). At minimum: a Specification Architect (\\\"Sage\\\") to write BRD + SRS\\n2. **Request agent hires from CEO** \\u2014 post comments on this task listing who you need hired, with role, capabilities, and rationale. CEO will submit hire requests.\\n3. **Once Sage is available**, create and assign a subtask for BRD + SRS specification using the super-spec skill\\n4. **Plan Sprint 1** \\u2014 break the SDLC pipeline Phase A (IDEA \\u2192 SPEC) into concrete tasks\\n5. **Report back** with your plan and any blockers\\n\\n## Constraints\\n- You cannot hire agents directly (no canCreateAgents permission). Request hires from CEO via comments.\\n- Use the paperclip skill for all coordination.\\n- Model routing: Opus thinks, Sonnet builds, Haiku gathers.\",\n    \"status\": \"todo\",\n    \"priority\": \"high\",\n    \"assigneeAgentId\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n    \"assigneeUserId\": null,\n    \"checkoutRunId\": null,\n    \"executionRunId\": null,\n    \"executionAgentNameKey\": null,\n    \"executionLockedAt\": null,\n    \"createdByAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n    \"createdByUserId\": null,\n    \"issueNumber\": 2,\n    \"identifier\": \"AEGA-2\",\n    \"originKind\": \"manual\",\n    \"originId\": null,\n    \"originRunId\": null,\n    \"requestDepth\": 0,\n    \"billingCode\": null,\n    \"assigneeAdapterOverrides\": null,\n    \"executionWorkspaceId\": null,\n    \"executionWorkspacePreference\": null,\n    \"executionWorkspaceSettings\": null,\n    \"startedAt\": null,\n    \"completedAt\": null,\n    \"cancelledAt\": null,\n    \"hiddenAt\": null,\n    \"createdAt\": \"2026-04-03T07:16:43.117Z\",\n    \"updatedAt\": \"2026-04-03T07:16:43.117Z\",\n    \"labels\": [],\n    \"labelIds\": []\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"0f5f5922-7108-4c94-bbbb-633d962f8715","timestamp":"2026-04-03T07:16:43.209Z","tool_use_result":{"stdout":"{\n    \"id\": \"d447cdfb-1655-41ba-b222-a7fad582e53c\",\n    \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n    \"projectId\": \"15cf70f4-7785-4fa2-8d79-abadf14d8bb8\",\n    \"projectWorkspaceId\": null,\n    \"goalId\": \"f37b9d3a-60c7-431a-a03d-b9eda150e5ae\",\n    \"parentId\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n    \"title\": \"Build AEGIS org, create Sprint 1 plan, and delegate spec creation\",\n    \"description\": \"## Context\\nYou are Navi, CTO of AEGIS. Mother Brain (CEO) has activated the company and hired you as the first agent.\\n\\n## Current State\\n- Green-field: no code, no specs, no other agents besides you and CEO\\n- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline, 5-Gate Quality System, ISO 29110 compliance\\n- No BRD or SRS exists yet \\u2014 this is the critical blocker\\n\\n## Your Mission\\n1. **Assess what agents are needed** for Sprint 1 (spec phase). At minimum: a Specification Architect (\\\"Sage\\\") to write BRD + SRS\\n2. **Request agent hires from CEO** \\u2014 post comments on this task listing who you need hired, with role, capabilities, and rationale. CEO will submit hire requests.\\n3. **Once Sage is available**, create and assign a subtask for BRD + SRS specification using the super-spec skill\\n4. **Plan Sprint 1** \\u2014 break the SDLC pipeline Phase A (IDEA \\u2192 SPEC) into concrete tasks\\n5. **Report back** with your plan and any blockers\\n\\n## Constraints\\n- You cannot hire agents directly (no canCreateAgents permission). Request hires from CEO via comments.\\n- Use the paperclip skill for all coordination.\\n- Model routing: Opus thinks, Sonnet builds, Haiku gathers.\",\n    \"status\": \"todo\",\n    \"priority\": \"high\",\n    \"assigneeAgentId\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n    \"assigneeUserId\": null,\n    \"checkoutRunId\": null,\n    \"executionRunId\": null,\n    \"executionAgentNameKey\": null,\n    \"executionLockedAt\": null,\n    \"createdByAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n    \"createdByUserId\": null,\n    \"issueNumber\": 2,\n    \"identifier\": \"AEGA-2\",\n    \"originKind\": \"manual\",\n    \"originId\": null,\n    \"originRunId\": null,\n    \"requestDepth\": 0,\n    \"billingCode\": null,\n    \"assigneeAdapterOverrides\": null,\n    \"executionWorkspaceId\": null,\n    \"executionWorkspacePreference\": null,\n    \"executionWorkspaceSettings\": null,\n    \"startedAt\": null,\n    \"completedAt\": null,\n    \"cancelledAt\": null,\n    \"hiddenAt\": null,\n    \"createdAt\": \"2026-04-03T07:16:43.117Z\",\n    \"updatedAt\": \"2026-04-03T07:16:43.117Z\",\n    \"labels\": [],\n    \"labelIds\": []\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01ExgeNacn1njsgkf6Bkhc6c","type":"message","role":"assistant","content":[{"type":"text","text":"Subtask AEGA-2 created and assigned to Navi. Now let me unblock AEGA-1 and update with progress."}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":1711,"cache_read_input_tokens":65674,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":1711},"output_tokens":2,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"5fc44854-9a6c-40eb-8b48-4a17bfa4e5f0"}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01ExgeNacn1njsgkf6Bkhc6c","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01NzVb3cZB46wT9UNJZcmEwz","name":"TodoWrite","input":{"todos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtask for Navi to own technical activation","status":"completed","activeForm":"Creating subtask for Navi"},{"content":"Hire Sage (Specification Architect) for BRD/SRS work","status":"pending","activeForm":"Hiring Sage agent"},{"content":"Unblock AEGA-1 and update with Heartbeat 2 progress","status":"in_progress","activeForm":"Updating AEGA-1"}]},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":1711,"cache_read_input_tokens":65674,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":1711},"output_tokens":2,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"a34587a8-79d9-4a34-8405-85c05875dca4"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01NzVb3cZB46wT9UNJZcmEwz","type":"tool_result","content":"Todos have been modified successfully. Ensure that you continue to use the todo list to track your progress. Please proceed with the current tasks if applicable"}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"8623dfef-6f8c-4592-9eec-4774260e86d5","timestamp":"2026-04-03T07:16:48.225Z","tool_use_result":{"oldTodos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtask for Navi to own technical activation","status":"in_progress","activeForm":"Creating subtask for Navi"},{"content":"Hire Sage (Specification Architect) for BRD/SRS work","status":"pending","activeForm":"Hiring Sage agent"},{"content":"Unblock AEGA-1 and update with Heartbeat 2 progress","status":"pending","activeForm":"Updating AEGA-1"}],"newTodos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtask for Navi to own technical activation","status":"completed","activeForm":"Creating subtask for Navi"},{"content":"Hire Sage (Specification Architect) for BRD/SRS work","status":"pending","activeForm":"Hiring Sage agent"},{"content":"Unblock AEGA-1 and update with Heartbeat 2 progress","status":"in_progress","activeForm":"Updating AEGA-1"}],"verificationNudgeNeeded":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01EZTFPnfGUDPH1GCETRPbKd","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_017177HZKXStDe64Hh5Bni4r","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_03945ccbef0d93f3031e1fc80f0805163ef0b55dcd1f88ca' && curl -sS -X PATCH \"$PAPERCLIP_API_URL/api/issues/af75be97-329e-4d28-80d9-27b03db4f7c6\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" \\\n  -H \"X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID\" \\\n  -H \"Content-Type: application/json\" \\\n  -d '{\n    \"status\": \"in_progress\",\n    \"comment\": \"## Heartbeat 2 — CTO approved, delegation started\\n\\n**Approval resolved:**\\n- Navi (CTO) hire approved by board: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\\n- Agent [Navi](/AEGA/agents/navi) is now active and idle\\n\\n**Actions taken:**\\n- Created subtask [AEGA-2](/AEGA/issues/AEGA-2) — \\\"Build AEGIS org, create Sprint 1 plan, and delegate spec creation\\\"\\n- Assigned to Navi with full context on green-field state and spec-first priority\\n- Navi instructed to assess needed agents, request hires, and plan Sprint 1\\n\\n**Hiring model:**\\n- Navi does not have canCreateAgents — will request hires via comments\\n- I (CEO) will submit hire requests as Navi identifies needed roles\\n- First expected hire: Sage (Specification Architect) for BRD + SRS\\n\\n**Status**: Unblocked. Waiting for Navi to pick up [AEGA-2](/AEGA/issues/AEGA-2).\"\n  }' | python3 -c \"import sys,json; d=json.load(sys.stdin); print(f\\\"AEGA-1 status: {d['status']}\\\")\"","description":"Unblock AEGA-1 with progress update"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":325,"cache_read_input_tokens":67385,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":325},"output_tokens":72,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"cd4ac632-ec71-464d-b897-9136ffe4a4d1"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_017177HZKXStDe64Hh5Bni4r","type":"tool_result","content":"AEGA-1 status: in_progress","is_error":false}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"8f313f0c-9e5a-4f74-9b50-b06ef2875d7c","timestamp":"2026-04-03T07:17:00.617Z","tool_use_result":{"stdout":"AEGA-1 status: in_progress","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_017pf3f6kTinUc4DvJni3RuR","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_014a3mJ4KArpcptwKQbWk2j6","name":"TodoWrite","input":{"todos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtask for Navi to own technical activation","status":"completed","activeForm":"Creating subtask for Navi"},{"content":"Unblock AEGA-1 and update with Heartbeat 2 progress","status":"completed","activeForm":"Updating AEGA-1"},{"content":"Hire Sage and other agents as Navi requests them","status":"pending","activeForm":"Waiting for Navi's hire requests"}]},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":631,"cache_read_input_tokens":67710,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":631},"output_tokens":73,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"553feae9-d2dc-420f-9183-2ce9155d15c5"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_014a3mJ4KArpcptwKQbWk2j6","type":"tool_result","content":"Todos have been modified successfully. Ensure that you continue to use the todo list to track your progress. Please proceed with the current tasks if applicable"}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"a7cd5236-0aa3-4fe9-be6a-b9126d3609bc","timestamp":"2026-04-03T07:17:05.013Z","tool_use_result":{"oldTodos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtask for Navi to own technical activation","status":"completed","activeForm":"Creating subtask for Navi"},{"content":"Hire Sage (Specification Architect) for BRD/SRS work","status":"pending","activeForm":"Hiring Sage agent"},{"content":"Unblock AEGA-1 and update with Heartbeat 2 progress","status":"in_progress","activeForm":"Updating AEGA-1"}],"newTodos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtask for Navi to own technical activation","status":"completed","activeForm":"Creating subtask for Navi"},{"content":"Unblock AEGA-1 and update with Heartbeat 2 progress","status":"completed","activeForm":"Updating AEGA-1"},{"content":"Hire Sage and other agents as Navi requests them","status":"pending","activeForm":"Waiting for Navi's hire requests"}],"verificationNudgeNeeded":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_011SSYvdLHyYAugFAV9Y7R8E","type":"message","role":"assistant","content":[{"type":"text","text":"Heartbeat 2 complete. Summary:\n\n- **CTO hire approved** — Navi is active\n- **AEGA-2 created** and assigned to Navi: build org, plan Sprint 1, drive spec creation\n- **AEGA-1 unblocked** — now in_progress, waiting for Navi to engage\n- **Next**: Navi picks up AEGA-2, assesses needed agents, requests hires. I'll submit hire requests as they come in.\n\nThe machine is moving. Navi should wake on the assignment and start planning."}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":288,"cache_read_input_tokens":68341,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":288},"output_tokens":2,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"69e90992-75e7-48a1-ab34-1f259d929ff2"}
{"type":"result","subtype":"success","is_error":false,"duration_ms":121830,"duration_api_ms":120289,"num_turns":20,"result":"Heartbeat 2 complete. Summary:\n\n- **CTO hire approved** — Navi is active\n- **AEGA-2 created** and assigned to Navi: build org, plan Sprint 1, drive spec creation\n- **AEGA-1 unblocked** — now in_progress, waiting for Navi to engage\n- **Next**: Navi picks up AEGA-2, assesses needed agents, requests hires. I'll submit hire requests as they come in.\n\nThe machine is moving. Navi should wake on the assignment and start planning.","stop_reason":"end_turn","session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","total_cost_usd":0.9727009999999999,"usage":{"input_tokens":20,"cache_creation_input_tokens":44986,"cache_read_input_tokens":1116727,"output_tokens":5323,"server_tool_use":{"web_search_requests":0,"web_fetch_requests":0},"service_tier":"standard","cache_creation":{"ephemeral_1h_input_tokens":44986,"ephemeral_5m_input_tokens":0},"inference_geo":"","iterations":[],"speed":"standard"},"modelUsage":{"claude-opus-4-6":{"inputTokens":20,"outputTokens":5323,"cacheReadInputTokens":1116727,"cacheCreationInputTokens":44986,"webSearchRequests":0,"costUSD":0.9727009999999999,"contextWindow":200000,"maxOutputTokens":64000}},"permission_denials":[],"terminal_reason":"completed","fast_mode_state":"off","uuid":"8b7e5c82-6690-4274-be94-efa4903d2309"}
$paperclip$, $paperclip$$paperclip$, NULL, 39169, $paperclip$2026-04-03T07:15:07.869Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$assignment$paperclip$, $paperclip$succeeded$paperclip$, $paperclip$2026-04-03T07:11:04.213Z$paperclip$, $paperclip$2026-04-03T07:13:27.160Z$paperclip$, NULL, NULL, $paperclip${"source":"issue.create","taskId":"af75be97-329e-4d28-80d9-27b03db4f7c6","issueId":"af75be97-329e-4d28-80d9-27b03db4f7c6","taskKey":"af75be97-329e-4d28-80d9-27b03db4f7c6","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","wakeReason":"issue_assigned","wakeSource":"assignment","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","mode":"shared_workspace","source":"project_primary","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/1e6d0b76-3817-4502-901e-7dd1356cd771","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[],"executionWorkspaceId":"3b5f9c75-8246-4bf0-8336-f7871efcaae0"}$paperclip$, $paperclip$2026-04-03T07:11:04.198Z$paperclip$, $paperclip$2026-04-03T07:13:27.160Z$paperclip$, $paperclip$system$paperclip$, $paperclip$108b8156-6149-4727-84b2-01d7292c6f92$paperclip$, 0, NULL, $paperclip${"model":"claude-opus-4-6","biller":"anthropic","costUsd":0.9773782499999998,"provider":"anthropic","billingType":"subscription_included","inputTokens":25,"freshSession":true,"outputTokens":6309,"sessionReused":false,"rawInputTokens":25,"sessionRotated":false,"rawOutputTokens":6309,"cachedInputTokens":808244,"taskSessionReused":false,"persistedSessionId":"60e284df-eb26-46b8-8507-391b2bddce9d","rawCachedInputTokens":808244,"sessionRotationReason":null}$paperclip$, $paperclip${"type":"result","uuid":"1af4cbfd-56eb-4b39-b9a4-e67f88ffbe0c","usage":{"speed":"standard","iterations":[],"input_tokens":25,"service_tier":"standard","inference_geo":"","output_tokens":6309,"cache_creation":{"ephemeral_1h_input_tokens":66465,"ephemeral_5m_input_tokens":0},"server_tool_use":{"web_fetch_requests":0,"web_search_requests":0},"cache_read_input_tokens":808244,"cache_creation_input_tokens":66465},"result":"Heartbeat complete. Here's where things stand:\n\n**AEGA-1 — Activate AEGIS**\n- Scanned project: green-field. No code, no agents, no specs.\n- Submitted CTO hire for **Navi** (claude-sonnet-4-6, reports to me)\n- Approval pending board review: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\n- Task marked **blocked** until CTO is approved\n\n**Rationale:** CTO is the single delegation point for all technical work. Once approved, Navi will own hiring the remaining specialist agents and kicking off Sprint 1 with spec creation. No point building bottom-up when the chain of command doesn't exist yet.\n\n**Board action needed:** Approve the CTO hire so we can start building.","subtype":"success","is_error":false,"num_turns":30,"modelUsage":{"claude-opus-4-6":{"costUSD":0.9773782499999998,"inputTokens":25,"outputTokens":6309,"contextWindow":200000,"maxOutputTokens":64000,"webSearchRequests":0,"cacheReadInputTokens":808244,"cacheCreationInputTokens":66465}},"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","duration_ms":141506,"stop_reason":"end_turn","total_cost_usd":0.9773782499999998,"duration_api_ms":137924,"fast_mode_state":"off","terminal_reason":"completed","permission_denials":[]}$paperclip$, NULL, $paperclip$60e284df-eb26-46b8-8507-391b2bddce9d$paperclip$, $paperclip$local_file$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af/1e6d0b76-3817-4502-901e-7dd1356cd771/a59f0164-e5a8-45bf-8525-f5c02c090957.ndjson$paperclip$, $paperclip$191781$paperclip$, $paperclip$1fce5872ec897aa67d9f897008c6af7ea91849e1fb2b9c3e212d151be5e8deb7$paperclip$, false, $paperclip$",\n            \"instructionsRootPath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions\",\n            \"instructionsEntryFile\": \"AGENTS.md\",\n            \"instructionsBundleMode\": \"managed\",\n            \"dangerouslySkipPermissions\": true\n        },\n        \"runtimeConfig\": {\n            \"heartbeat\": {\n                \"enabled\": true,\n                \"cooldownSec\": 10,\n                \"intervalSec\": 3600,\n                \"wakeOnDemand\": true,\n                \"maxConcurrentRuns\": 1\n            }\n        },\n        \"budgetMonthlyCents\": 0,\n        \"spentMonthlyCents\": 0,\n        \"pauseReason\": null,\n        \"pausedAt\": null,\n        \"permissions\": {\n            \"canCreateAgents\": false\n        },\n        \"lastHeartbeatAt\": null,\n        \"metadata\": null,\n        \"createdAt\": \"2026-04-03T07:12:53.816Z\",\n        \"updatedAt\": \"2026-04-03T07:12:53.819Z\",\n        \"urlKey\": \"navi\"\n    },\n    \"approval\": {\n        \"id\": \"8112ed6e-4eae-4360-9ac1-c5e88764c1b5\",\n        \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n        \"type\": \"hire_agent\",\n        \"requestedByAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n        \"requestedByUserId\": null,\n        \"status\": \"pending\",\n        \"payload\": {\n            \"icon\": \"cpu\",\n            \"name\": \"Navi\",\n            \"role\": \"cto\",\n            \"title\": \"Chief Technology Officer\",\n            \"agentId\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n            \"metadata\": {},\n            \"reportsTo\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n            \"adapterType\": \"claude_local\",\n            \"capabilities\": \"Owns technical roadmap, architecture, engineering staffing, code quality, and execution. Manages all specialist agents: engineers, QA, security, DevOps, infrastructure. Delegates implementation work, reviews technical decisions, and ensures delivery quality.\",\n            \"adapterConfig\": {\n                \"model\": \"claude-sonnet-4-6\",\n                \"graceSec\": 15,\n                \"timeoutSec\": 0,\n                \"maxTurnsPerRun\": 500,\n                \"instructionsFilePath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions/AGENTS.md\",\n                \"instructionsRootPath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions\",\n                \"instructionsEntryFile\": \"AGENTS.md\",\n                \"instructionsBundleMode\": \"managed\",\n                \"dangerouslySkipPermissions\": true\n            },\n            \"desiredSkills\": null,\n            \"runtimeConfig\": {\n                \"heartbeat\": {\n                    \"enabled\": true,\n                    \"cooldownSec\": 10,\n                    \"intervalSec\": 3600,\n                    \"wakeOnDemand\": true,\n                    \"maxConcurrentRuns\": 1\n                }\n            },\n            \"budgetMonthlyCents\": 0,\n            \"requestedByAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n            \"requestedConfigurationSnapshot\": {\n                \"adapterType\": \"claude_local\",\n                \"adapterConfig\": {\n                    \"model\": \"claude-sonnet-4-6\",\n                    \"graceSec\": 15,\n                    \"timeoutSec\": 0,\n                    \"maxTurnsPerRun\": 500,\n                    \"instructionsFilePath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions/AGENTS.md\",\n                    \"instructionsRootPath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions\",\n                    \"instructionsEntryFile\": \"AGENTS.md\",\n                    \"instructionsBundleMode\": \"managed\",\n                    \"dangerouslySkipPermissions\": true\n                },\n                \"desiredSkills\": null,\n                \"runtimeConfig\": {\n                    \"heartbeat\": {\n                        \"enabled\": true,\n                        \"cooldownSec\": 10,\n                        \"intervalSec\": 3600,\n                        \"wakeOnDemand\": true,\n                        \"maxConcurrentRuns\": 1\n                    }\n                }\n            }\n        },\n        \"decisionNote\": null,\n        \"decidedByUserId\": null,\n        \"decidedAt\": null,\n        \"createdAt\": \"2026-04-03T07:12:53.820Z\",\n        \"updatedAt\": \"2026-04-03T07:12:53.820Z\"\n    }\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"d854e873-56e4-48af-9206-a29339e8c287","timestamp":"2026-04-03T07:12:53.852Z","tool_use_result":{"stdout":"{\n    \"agent\": {\n        \"id\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n        \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n        \"name\": \"Navi\",\n        \"role\": \"cto\",\n        \"title\": \"Chief Technology Officer\",\n        \"icon\": \"cpu\",\n        \"status\": \"pending_approval\",\n        \"reportsTo\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n        \"capabilities\": \"Owns technical roadmap, architecture, engineering staffing, code quality, and execution. Manages all specialist agents: engineers, QA, security, DevOps, infrastructure. Delegates implementation work, reviews technical decisions, and ensures delivery quality.\",\n        \"adapterType\": \"claude_local\",\n        \"adapterConfig\": {\n            \"model\": \"claude-sonnet-4-6\",\n            \"graceSec\": 15,\n            \"timeoutSec\": 0,\n            \"maxTurnsPerRun\": 500,\n            \"instructionsFilePath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions/AGENTS.md\",\n            \"instructionsRootPath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions\",\n            \"instructionsEntryFile\": \"AGENTS.md\",\n            \"instructionsBundleMode\": \"managed\",\n            \"dangerouslySkipPermissions\": true\n        },\n        \"runtimeConfig\": {\n            \"heartbeat\": {\n                \"enabled\": true,\n                \"cooldownSec\": 10,\n                \"intervalSec\": 3600,\n                \"wakeOnDemand\": true,\n                \"maxConcurrentRuns\": 1\n            }\n        },\n        \"budgetMonthlyCents\": 0,\n        \"spentMonthlyCents\": 0,\n        \"pauseReason\": null,\n        \"pausedAt\": null,\n        \"permissions\": {\n            \"canCreateAgents\": false\n        },\n        \"lastHeartbeatAt\": null,\n        \"metadata\": null,\n        \"createdAt\": \"2026-04-03T07:12:53.816Z\",\n        \"updatedAt\": \"2026-04-03T07:12:53.819Z\",\n        \"urlKey\": \"navi\"\n    },\n    \"approval\": {\n        \"id\": \"8112ed6e-4eae-4360-9ac1-c5e88764c1b5\",\n        \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n        \"type\": \"hire_agent\",\n        \"requestedByAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n        \"requestedByUserId\": null,\n        \"status\": \"pending\",\n        \"payload\": {\n            \"icon\": \"cpu\",\n            \"name\": \"Navi\",\n            \"role\": \"cto\",\n            \"title\": \"Chief Technology Officer\",\n            \"agentId\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n            \"metadata\": {},\n            \"reportsTo\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n            \"adapterType\": \"claude_local\",\n            \"capabilities\": \"Owns technical roadmap, architecture, engineering staffing, code quality, and execution. Manages all specialist agents: engineers, QA, security, DevOps, infrastructure. Delegates implementation work, reviews technical decisions, and ensures delivery quality.\",\n            \"adapterConfig\": {\n                \"model\": \"claude-sonnet-4-6\",\n                \"graceSec\": 15,\n                \"timeoutSec\": 0,\n                \"maxTurnsPerRun\": 500,\n                \"instructionsFilePath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions/AGENTS.md\",\n                \"instructionsRootPath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions\",\n                \"instructionsEntryFile\": \"AGENTS.md\",\n                \"instructionsBundleMode\": \"managed\",\n                \"dangerouslySkipPermissions\": true\n            },\n            \"desiredSkills\": null,\n            \"runtimeConfig\": {\n                \"heartbeat\": {\n                    \"enabled\": true,\n                    \"cooldownSec\": 10,\n                    \"intervalSec\": 3600,\n                    \"wakeOnDemand\": true,\n                    \"maxConcurrentRuns\": 1\n                }\n            },\n            \"budgetMonthlyCents\": 0,\n            \"requestedByAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n            \"requestedConfigurationSnapshot\": {\n                \"adapterType\": \"claude_local\",\n                \"adapterConfig\": {\n                    \"model\": \"claude-sonnet-4-6\",\n                    \"graceSec\": 15,\n                    \"timeoutSec\": 0,\n                    \"maxTurnsPerRun\": 500,\n                    \"instructionsFilePath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions/AGENTS.md\",\n                    \"instructionsRootPath\": \"/Users/phariyawit.jiap/.paperclip/instances/default/companies/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/agents/3df78889-0a61-4fed-bb04-6c3134c3d2d8/instructions\",\n                    \"instructionsEntryFile\": \"AGENTS.md\",\n                    \"instructionsBundleMode\": \"managed\",\n                    \"dangerouslySkipPermissions\": true\n                },\n                \"desiredSkills\": null,\n                \"runtimeConfig\": {\n                    \"heartbeat\": {\n                        \"enabled\": true,\n                        \"cooldownSec\": 10,\n                        \"intervalSec\": 3600,\n                        \"wakeOnDemand\": true,\n                        \"maxConcurrentRuns\": 1\n                    }\n                }\n            }\n        },\n        \"decisionNote\": null,\n        \"decidedByUserId\": null,\n        \"decidedAt\": null,\n        \"createdAt\": \"2026-04-03T07:12:53.820Z\",\n        \"updatedAt\": \"2026-04-03T07:12:53.820Z\"\n    }\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01TB6MyofKxPDXdoDv4HUtWy","type":"message","role":"assistant","content":[{"type":"text","text":"CTO hire submitted. Agent `Navi` (3df78889) is `pending_approval`. Approval ID: `8112ed6e-4eae-4360-9ac1-c5e88764c1b5`.\n\nNow let me comment on the approval thread and update AEGA-1 with my progress."}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":2518,"cache_read_input_tokens":53750,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":2518},"output_tokens":1,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"e6db4951-7e15-44a8-aa9f-5375db125900"}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01TB6MyofKxPDXdoDv4HUtWy","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01P9fcpLQR97xfbcL1qc5yE3","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_03945ccbef0d93f3031e1fc80f0805163ef0b55dcd1f88ca' && curl -sS -X POST \"$PAPERCLIP_API_URL/api/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5/comments\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" \\\n  -H \"X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID\" \\\n  -H \"Content-Type: application/json\" \\\n  -d '{\n    \"body\": \"## CTO hire request submitted\\n\\n- **Agent**: Navi — Chief Technology Officer\\n- **Model**: claude-sonnet-4-6 (Sonnet builds, Opus thinks)\\n- **Reports to**: Mother Brain (CEO)\\n- **Capabilities**: Technical roadmap, architecture, engineering staffing, code quality, execution. Manages all specialist agents.\\n- **Rationale**: First hire. CTO is the single delegation point for all technical work. Once approved, Navi will own hiring the remaining 12 specialist agents and driving Sprint 1.\\n\\n- Approval: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\\n- Pending agent: [Navi](/AEGA/agents/navi)\\n- Source issue: [AEGA-1](/AEGA/issues/AEGA-1)\"\n  }' | python3 -m json.tool","description":"Comment on approval"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":2518,"cache_read_input_tokens":53750,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":2518},"output_tokens":1,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"fddea543-e980-4743-9301-d9188796469d"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01P9fcpLQR97xfbcL1qc5yE3","type":"tool_result","content":"{\n    \"id\": \"864732d2-d28b-4d8f-86b5-f0f39b2ab0bd\",\n    \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n    \"approvalId\": \"8112ed6e-4eae-4360-9ac1-c5e88764c1b5\",\n    \"authorAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n    \"authorUserId\": null,\n    \"body\": \"## CTO hire request submitted\\n\\n- **Agent**: Navi \\u2014 Chief Technology Officer\\n- **Model**: claude-sonnet-4-6 (Sonnet builds, Opus thinks)\\n- **Reports to**: Mother Brain (CEO)\\n- **Capabilities**: Technical roadmap, architecture, engineering staffing, code quality, execution. Manages all specialist agents.\\n- **Rationale**: First hire. CTO is the single delegation point for all technical work. Once approved, Navi will own hiring the remaining 12 specialist agents and driving Sprint 1.\\n\\n- Approval: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\\n- Pending agent: [Navi](/AEGA/agents/navi)\\n- Source issue: [AEGA-1](/AEGA/issues/AEGA-1)\",\n    \"createdAt\": \"2026-04-03T07:13:04.800Z\",\n    \"updatedAt\": \"2026-04-03T07:13:04.800Z\"\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"df3baf7f-6d35-497e-975c-06634b23748e","timestamp":"2026-04-03T07:13:04.836Z","tool_use_result":{"stdout":"{\n    \"id\": \"864732d2-d28b-4d8f-86b5-f0f39b2ab0bd\",\n    \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n    \"approvalId\": \"8112ed6e-4eae-4360-9ac1-c5e88764c1b5\",\n    \"authorAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n    \"authorUserId\": null,\n    \"body\": \"## CTO hire request submitted\\n\\n- **Agent**: Navi \\u2014 Chief Technology Officer\\n- **Model**: claude-sonnet-4-6 (Sonnet builds, Opus thinks)\\n- **Reports to**: Mother Brain (CEO)\\n- **Capabilities**: Technical roadmap, architecture, engineering staffing, code quality, execution. Manages all specialist agents.\\n- **Rationale**: First hire. CTO is the single delegation point for all technical work. Once approved, Navi will own hiring the remaining 12 specialist agents and driving Sprint 1.\\n\\n- Approval: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\\n- Pending agent: [Navi](/AEGA/agents/navi)\\n- Source issue: [AEGA-1](/AEGA/issues/AEGA-1)\",\n    \"createdAt\": \"2026-04-03T07:13:04.800Z\",\n    \"updatedAt\": \"2026-04-03T07:13:04.800Z\"\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01TB6MyofKxPDXdoDv4HUtWy","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_011Ffxu5fLRE1KX67eyL7j3j","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_03945ccbef0d93f3031e1fc80f0805163ef0b55dcd1f88ca' && curl -sS -X PATCH \"$PAPERCLIP_API_URL/api/issues/af75be97-329e-4d28-80d9-27b03db4f7c6\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" \\\n  -H \"X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID\" \\\n  -H \"Content-Type: application/json\" \\\n  -d '{\n    \"comment\": \"## Heartbeat 1 — Initial assessment and CTO hire\\n\\n**Situation:**\\n- Green-field activation. Only CEO (me) exists. Zero agents, zero code, zero specs.\\n- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline.\\n- No spec exists → P8 priority: must create BRD + SRS before any build work.\\n\\n**Actions taken:**\\n- Scanned project workspace: empty. No git repo, no files, no existing agents.\\n- Submitted CTO hire request for **Navi** (claude-sonnet-4-6, reports to me).\\n- Approval pending board review: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\\n\\n**Next steps (blocked on CTO approval):**\\n1. Once Navi is approved → delegate org build-out (hire remaining 12 agents)\\n2. Create subtask for BRD + SRS specification\\n3. Break company goal into Sprint 1 tasks\\n4. Assign spec creation to Sage (Specification Architect) once hired\\n\\n**Status**: Blocked on board approval of CTO hire.\",\n    \"status\": \"blocked\"\n  }' | python3 -m json.tool","description":"Update AEGA-1 with progress"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":2518,"cache_read_input_tokens":53750,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":2518},"output_tokens":1,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"2ca3a834-daaa-46b7-bc2f-b68d73b0c938"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_011Ffxu5fLRE1KX67eyL7j3j","type":"tool_result","content":"{\n    \"id\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n    \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n    \"projectId\": \"15cf70f4-7785-4fa2-8d79-abadf14d8bb8\",\n    \"projectWorkspaceId\": null,\n    \"goalId\": \"f37b9d3a-60c7-431a-a03d-b9eda150e5ae\",\n    \"parentId\": null,\n    \"title\": \"Activate AEGIS: Scan project state, hire remaining agents, and begin Sprint 1\",\n    \"description\": \"You are Mother Brain \\u2014 the autonomous decision engine of AEGIS.\\n\\nYour mission:\\n1. Scan the current project state (git, files, existing agents, goals)\\n2. Review the 13-agent org chart already created (Navi, Sage, Bolt, Vigil, Havoc, Forge, Pixel, Muse, Sentinel, Probe, Scribe, Ops)\\n3. Verify all agents report to correct hierarchy (you \\u2192 Navi \\u2192 specialists)\\n4. Break the company goal into Sprint 1 tasks using the 14-stage SDLC pipeline\\n5. Assign high-priority tasks to appropriate agents via issues\\n6. Begin Phase A: Delegate to Sage for BRD + SRS specification if no spec exists\\n\\nDecision Priority: P8 (No spec exists) \\u2192 run spec creation \\u2192 breakdown \\u2192 sprint plan \\u2192 build\\n\\nRules:\\n- Do NOT ask what to do \\u2014 analyze, decide, execute, report\\n- Announce what you are doing with rationale\\n- Stop on critical QualityGate failures\\n- Respect context budget zones (GREEN/YELLOW/ORANGE/RED)\",\n    \"status\": \"blocked\",\n    \"priority\": \"medium\",\n    \"assigneeAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n    \"assigneeUserId\": null,\n    \"checkoutRunId\": null,\n    \"executionRunId\": \"a59f0164-e5a8-45bf-8525-f5c02c090957\",\n    \"executionAgentNameKey\": \"mother brain\",\n    \"executionLockedAt\": \"2026-04-03T07:11:04.206Z\",\n    \"createdByAgentId\": null,\n    \"createdByUserId\": \"local-board\",\n    \"issueNumber\": 1,\n    \"identifier\": \"AEGA-1\",\n    \"originKind\": \"manual\",\n    \"originId\": null,\n    \"originRunId\": null,\n    \"requestDepth\": 0,\n    \"billingCode\": null,\n    \"assigneeAdapterOverrides\": null,\n    \"executionWorkspaceId\": null,\n    \"executionWorkspacePreference\": null,\n    \"executionWorkspaceSettings\": null,\n    \"startedAt\": \"2026-04-03T07:12:08.419Z\",\n    \"completedAt\": null,\n    \"cancelledAt\": null,\n    \"hiddenAt\": null,\n    \"createdAt\": \"2026-04-03T07:11:04.172Z\",\n    \"updatedAt\": \"2026-04-03T07:13:14.351Z\",\n    \"labels\": [],\n    \"labelIds\": [],\n    \"comment\": {\n        \"id\": \"7a4a7036-317e-4def-8f4d-ebace0368c21\",\n        \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n        \"issueId\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n        \"authorAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n        \"authorUserId\": null,\n        \"createdByRunId\": \"a59f0164-e5a8-45bf-8525-f5c02c090957\",\n        \"body\": \"## Heartbeat 1 \\u2014 Initial assessment and CTO hire\\n\\n**Situation:**\\n- Green-field activation. Only CEO (me) exists. Zero agents, zero code, zero specs.\\n- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline.\\n- No spec exists \\u2192 P8 priority: must create BRD + SRS before any build work.\\n\\n**Actions taken:**\\n- Scanned project workspace: empty. No git repo, no files, no existing agents.\\n- Submitted CTO hire request for **Navi** (claude-sonnet-4-6, reports to me).\\n- Approval pending board review: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\\n\\n**Next steps (blocked on CTO approval):**\\n1. Once Navi is approved \\u2192 delegate org build-out (hire remaining 12 agents)\\n2. Create subtask for BRD + SRS specification\\n3. Break company goal into Sprint 1 tasks\\n4. Assign spec creation to Sage (Specification Architect) once hired\\n\\n**Status**: Blocked on board approval of CTO hire.\",\n        \"createdAt\": \"2026-04-03T07:13:14.360Z\",\n        \"updatedAt\": \"2026-04-03T07:13:14.360Z\"\n    }\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"9af1b4ba-73d6-4fb4-ab6a-d3d48f630169","timestamp":"2026-04-03T07:13:14.404Z","tool_use_result":{"stdout":"{\n    \"id\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n    \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n    \"projectId\": \"15cf70f4-7785-4fa2-8d79-abadf14d8bb8\",\n    \"projectWorkspaceId\": null,\n    \"goalId\": \"f37b9d3a-60c7-431a-a03d-b9eda150e5ae\",\n    \"parentId\": null,\n    \"title\": \"Activate AEGIS: Scan project state, hire remaining agents, and begin Sprint 1\",\n    \"description\": \"You are Mother Brain \\u2014 the autonomous decision engine of AEGIS.\\n\\nYour mission:\\n1. Scan the current project state (git, files, existing agents, goals)\\n2. Review the 13-agent org chart already created (Navi, Sage, Bolt, Vigil, Havoc, Forge, Pixel, Muse, Sentinel, Probe, Scribe, Ops)\\n3. Verify all agents report to correct hierarchy (you \\u2192 Navi \\u2192 specialists)\\n4. Break the company goal into Sprint 1 tasks using the 14-stage SDLC pipeline\\n5. Assign high-priority tasks to appropriate agents via issues\\n6. Begin Phase A: Delegate to Sage for BRD + SRS specification if no spec exists\\n\\nDecision Priority: P8 (No spec exists) \\u2192 run spec creation \\u2192 breakdown \\u2192 sprint plan \\u2192 build\\n\\nRules:\\n- Do NOT ask what to do \\u2014 analyze, decide, execute, report\\n- Announce what you are doing with rationale\\n- Stop on critical QualityGate failures\\n- Respect context budget zones (GREEN/YELLOW/ORANGE/RED)\",\n    \"status\": \"blocked\",\n    \"priority\": \"medium\",\n    \"assigneeAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n    \"assigneeUserId\": null,\n    \"checkoutRunId\": null,\n    \"executionRunId\": \"a59f0164-e5a8-45bf-8525-f5c02c090957\",\n    \"executionAgentNameKey\": \"mother brain\",\n    \"executionLockedAt\": \"2026-04-03T07:11:04.206Z\",\n    \"createdByAgentId\": null,\n    \"createdByUserId\": \"local-board\",\n    \"issueNumber\": 1,\n    \"identifier\": \"AEGA-1\",\n    \"originKind\": \"manual\",\n    \"originId\": null,\n    \"originRunId\": null,\n    \"requestDepth\": 0,\n    \"billingCode\": null,\n    \"assigneeAdapterOverrides\": null,\n    \"executionWorkspaceId\": null,\n    \"executionWorkspacePreference\": null,\n    \"executionWorkspaceSettings\": null,\n    \"startedAt\": \"2026-04-03T07:12:08.419Z\",\n    \"completedAt\": null,\n    \"cancelledAt\": null,\n    \"hiddenAt\": null,\n    \"createdAt\": \"2026-04-03T07:11:04.172Z\",\n    \"updatedAt\": \"2026-04-03T07:13:14.351Z\",\n    \"labels\": [],\n    \"labelIds\": [],\n    \"comment\": {\n        \"id\": \"7a4a7036-317e-4def-8f4d-ebace0368c21\",\n        \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\",\n        \"issueId\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n        \"authorAgentId\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n        \"authorUserId\": null,\n        \"createdByRunId\": \"a59f0164-e5a8-45bf-8525-f5c02c090957\",\n        \"body\": \"## Heartbeat 1 \\u2014 Initial assessment and CTO hire\\n\\n**Situation:**\\n- Green-field activation. Only CEO (me) exists. Zero agents, zero code, zero specs.\\n- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline.\\n- No spec exists \\u2192 P8 priority: must create BRD + SRS before any build work.\\n\\n**Actions taken:**\\n- Scanned project workspace: empty. No git repo, no files, no existing agents.\\n- Submitted CTO hire request for **Navi** (claude-sonnet-4-6, reports to me).\\n- Approval pending board review: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\\n\\n**Next steps (blocked on CTO approval):**\\n1. Once Navi is approved \\u2192 delegate org build-out (hire remaining 12 agents)\\n2. Create subtask for BRD + SRS specification\\n3. Break company goal into Sprint 1 tasks\\n4. Assign spec creation to Sage (Specification Architect) once hired\\n\\n**Status**: Blocked on board approval of CTO hire.\",\n        \"createdAt\": \"2026-04-03T07:13:14.360Z\",\n        \"updatedAt\": \"2026-04-03T07:13:14.360Z\"\n    }\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_011N7w4X8jyREci7YapfK9QC","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01NKfywLNjQbQ3aRKsqDcv6w","name":"TodoWrite","input":{"todos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtasks for org build-out and Sprint 1 planning","status":"pending","activeForm":"Creating subtasks"},{"content":"Delegate spec creation to appropriate agent once team exists","status":"pending","activeForm":"Delegating spec creation"}]},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":3220,"cache_read_input_tokens":56268,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":3220},"output_tokens":55,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"c63aa5f2-346e-4be5-8c4f-3c59a50b77ea"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01NKfywLNjQbQ3aRKsqDcv6w","type":"tool_result","content":"Todos have been modified successfully. Ensure that you continue to use the todo list to track your progress. Please proceed with the current tasks if applicable"}]},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"16375197-fb37-47c8-9fe3-1924ececbdff","timestamp":"2026-04-03T07:13:20.605Z","tool_use_result":{"oldTodos":[{"content":"Hire CTO (Navi) as direct report","status":"in_progress","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"pending","activeForm":"Commenting on AEGA-1"},{"content":"Create subtasks for org build-out and Sprint 1 planning","status":"pending","activeForm":"Creating subtasks"},{"content":"Delegate spec creation to appropriate agent once team exists","status":"pending","activeForm":"Delegating spec creation"}],"newTodos":[{"content":"Hire CTO (Navi) as direct report","status":"completed","activeForm":"Hiring CTO agent"},{"content":"Comment on AEGA-1 with initial assessment and plan","status":"completed","activeForm":"Commenting on AEGA-1"},{"content":"Create subtasks for org build-out and Sprint 1 planning","status":"pending","activeForm":"Creating subtasks"},{"content":"Delegate spec creation to appropriate agent once team exists","status":"pending","activeForm":"Delegating spec creation"}],"verificationNudgeNeeded":false}}
{"type":"assistant","message":{"model":"claude-opus-4-6","id":"msg_01Me8kS82LuVtrBV98fRz1sP","type":"message","role":"assistant","content":[{"type":"text","text":"Heartbeat complete. Here's where things stand:\n\n**AEGA-1 — Activate AEGIS**\n- Scanned project: green-field. No code, no agents, no specs.\n- Submitted CTO hire for **Navi** (claude-sonnet-4-6, reports to me)\n- Approval pending board review: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\n- Task marked **blocked** until CTO is approved\n\n**Rationale:** CTO is the single delegation point for all technical work. Once approved, Navi will own hiring the remaining specialist agents and kicking off Sprint 1 with spec creation. No point building bottom-up when the chain of command doesn't exist yet.\n\n**Board action needed:** Approve the CTO hire so we can start building."}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":236,"cache_read_input_tokens":59488,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":236},"output_tokens":2,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","uuid":"1f4543ff-8d62-4497-be53-b6dc09b2ff29"}
{"type":"result","subtype":"success","is_error":false,"duration_ms":141506,"duration_api_ms":137924,"num_turns":30,"result":"Heartbeat complete. Here's where things stand:\n\n**AEGA-1 — Activate AEGIS**\n- Scanned project: green-field. No code, no agents, no specs.\n- Submitted CTO hire for **Navi** (claude-sonnet-4-6, reports to me)\n- Approval pending board review: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)\n- Task marked **blocked** until CTO is approved\n\n**Rationale:** CTO is the single delegation point for all technical work. Once approved, Navi will own hiring the remaining specialist agents and kicking off Sprint 1 with spec creation. No point building bottom-up when the chain of command doesn't exist yet.\n\n**Board action needed:** Approve the CTO hire so we can start building.","stop_reason":"end_turn","session_id":"60e284df-eb26-46b8-8507-391b2bddce9d","total_cost_usd":0.9773782499999998,"usage":{"input_tokens":25,"cache_creation_input_tokens":66465,"cache_read_input_tokens":808244,"output_tokens":6309,"server_tool_use":{"web_search_requests":0,"web_fetch_requests":0},"service_tier":"standard","cache_creation":{"ephemeral_1h_input_tokens":66465,"ephemeral_5m_input_tokens":0},"inference_geo":"","iterations":[],"speed":"standard"},"modelUsage":{"claude-opus-4-6":{"inputTokens":25,"outputTokens":6309,"cacheReadInputTokens":808244,"cacheCreationInputTokens":66465,"webSearchRequests":0,"costUSD":0.9773782499999998,"contextWindow":200000,"maxOutputTokens":64000}},"permission_denials":[],"terminal_reason":"completed","fast_mode_state":"off","uuid":"1af4cbfd-56eb-4b39-b9a4-e67f88ffbe0c"}
$paperclip$, $paperclip$$paperclip$, NULL, 38663, $paperclip$2026-04-03T07:11:04.338Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$assignment$paperclip$, $paperclip$succeeded$paperclip$, $paperclip$2026-04-03T07:16:43.166Z$paperclip$, $paperclip$2026-04-03T07:19:33.699Z$paperclip$, NULL, NULL, $paperclip${"source":"issue.create","taskId":"d447cdfb-1655-41ba-b222-a7fad582e53c","issueId":"d447cdfb-1655-41ba-b222-a7fad582e53c","taskKey":"d447cdfb-1655-41ba-b222-a7fad582e53c","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","wakeReason":"issue_assigned","wakeSource":"assignment","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/Users/phariyawit.jiap/.paperclip/instances/default/projects/3cfded27-7059-4ce7-a93e-11fd3d0eb4af/15cf70f4-7785-4fa2-8d79-abadf14d8bb8/_default","mode":"shared_workspace","source":"project_primary","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/Users/phariyawit.jiap/.paperclip/instances/default/workspaces/3df78889-0a61-4fed-bb04-6c3134c3d2d8","projectId":"15cf70f4-7785-4fa2-8d79-abadf14d8bb8","branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[],"executionWorkspaceId":"dfb96d75-53ae-4bbe-a299-a398af3879e2"}$paperclip$, $paperclip$2026-04-03T07:16:43.146Z$paperclip$, $paperclip$2026-04-03T07:19:33.699Z$paperclip$, $paperclip$system$paperclip$, $paperclip$cd2ad101-bb97-4eb7-82ad-bd4e6bdc7a12$paperclip$, 0, NULL, $paperclip${"model":"claude-sonnet-4-6","biller":"anthropic","costUsd":0.59638515,"provider":"anthropic","billingType":"subscription_included","inputTokens":35,"freshSession":true,"outputTokens":6882,"sessionReused":false,"rawInputTokens":35,"sessionRotated":false,"rawOutputTokens":6882,"cachedInputTokens":1301513,"taskSessionReused":false,"persistedSessionId":"ca78b91f-bd28-466e-b083-0cc2414dcce8","rawCachedInputTokens":1301513,"sessionRotationReason":null}$paperclip$, $paperclip${"type":"result","uuid":"ce71274e-a613-4c39-b89a-392a90e9d2f3","usage":{"speed":"standard","iterations":[],"input_tokens":35,"service_tier":"standard","inference_geo":"","output_tokens":6882,"cache_creation":{"ephemeral_1h_input_tokens":27359,"ephemeral_5m_input_tokens":0},"server_tool_use":{"web_fetch_requests":0,"web_search_requests":0},"cache_read_input_tokens":1301513,"cache_creation_input_tokens":27359},"result":"Done. Here's what I did as Navi (CTO of AEGIS):\n\n**Task: [AEGA-2](/AEGA/issues/AEGA-2) — Build AEGIS org, create Sprint 1 plan, and delegate spec creation**\n\n**Actions taken:**\n\n1. **Checked out** AEGA-2 and assessed current state: only Mother Brain (CEO) and I (Navi/CTO) exist. No specs, no code — green-field.\n\n2. **Created Sprint 1 Plan** at [AEGA-2#document-plan](/AEGA/issues/AEGA-2#document-plan):\n   - Phase A: IDEA → SPEC\n   - Entry point: P8 Decision Tree (no spec exists → run spec creation)\n   - 4 tasks: Hire Sage → BRD+SRS → Gate 1 review → Sprint 2 breakdown\n   - Full agent roster for Sprint 2+ documented (Bolt, Vigil, Havoc, Forge, Pixel, Muse, Sentinel, Probe, Scribe, Ops)\n\n3. **Posted hire request** to CEO (Mother Brain) for **Sage (Specification Architect)** — P0 critical path. Sage needs: BRD/SRS authoring, ISO 29110 compliance mapping, `super-spec` skill, Opus 4.6 model.\n\n4. **Set AEGA-2 to `blocked`** — waiting on CEO to hire Sage. Will resume and create AEGA-3 (BRD+SRS subtask) once Sage is online.","subtype":"success","is_error":false,"num_turns":33,"modelUsage":{"claude-sonnet-4-6":{"costUSD":0.59638515,"inputTokens":35,"outputTokens":6882,"contextWindow":200000,"maxOutputTokens":32000,"webSearchRequests":0,"cacheReadInputTokens":1301513,"cacheCreationInputTokens":27359}},"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","duration_ms":169354,"stop_reason":"end_turn","total_cost_usd":0.59638515,"duration_api_ms":152616,"fast_mode_state":"off","terminal_reason":"completed","permission_denials":[]}$paperclip$, NULL, $paperclip$ca78b91f-bd28-466e-b083-0cc2414dcce8$paperclip$, $paperclip$local_file$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af/3df78889-0a61-4fed-bb04-6c3134c3d2d8/fcdc325d-fe50-434d-b011-904de1bb60e5.ndjson$paperclip$, $paperclip$154442$paperclip$, $paperclip$69537e2fd7aba379bc1dfd52f0d7af8cc52083b6e1318af407b47840e9844509$paperclip$, false, $paperclip$\"name\": \"Navi\",\n    \"urlKey\": \"navi\",\n    \"companyId\": \"3cfded27-7059-4ce7-a93e-11fd3d0eb4af\"\n  },\n  \"key\": {\n    \"id\": \"ecd8f77d-033d-4738-911f-c2694638780a\",\n    \"name\": \"local-cli\",\n    \"createdAt\": \"2026-04-03T07:18:20.186Z\",\n    \"token\": \"pcp_a7642f1f5d31e91480432a43ade0b51b992578816dd67342\"\n  },\n  \"skills\": [],\n  \"exports\": \"export PAPERCLIP_API_URL='http://127.0.0.1:3100'\\nexport PAPERCLIP_COMPANY_ID='3cfded27-7059-4ce7-a93e-11fd3d0eb4af'\\nexport PAPERCLIP_AGENT_ID='3df78889-0a61-4fed-bb04-6c3134c3d2d8'\\nexport PAPERCLIP_API_KEY='pcp_a7642f1f5d31e91480432a43ade0b51b992578816dd67342'\"\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_01WJzwoHPGXJPQWCoZFZEfS2","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_019WFzFZrc1vxegANDwAvnNK","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_a7642f1f5d31e91480432a43ade0b51b992578816dd67342'\n\n# Verify identity\ncurl -s \"$PAPERCLIP_API_URL/api/agents/me\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" | jq '{id, name, role, chainOfCommand}'"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":566,"cache_read_input_tokens":44960,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":566},"output_tokens":62,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"809e8d2f-d95e-43cf-96f2-2dbecd059e3c"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_019WFzFZrc1vxegANDwAvnNK","type":"tool_result","content":"{\n  \"id\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n  \"name\": \"Navi\",\n  \"role\": \"cto\",\n  \"chainOfCommand\": [\n    {\n      \"id\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n      \"name\": \"Mother Brain\",\n      \"role\": \"ceo\",\n      \"title\": null\n    }\n  ]\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"2ba4dd5a-27a9-4efd-8f91-9ec57f3d501d","timestamp":"2026-04-03T07:18:23.687Z","tool_use_result":{"stdout":"{\n  \"id\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n  \"name\": \"Navi\",\n  \"role\": \"cto\",\n  \"chainOfCommand\": [\n    {\n      \"id\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n      \"name\": \"Mother Brain\",\n      \"role\": \"ceo\",\n      \"title\": null\n    }\n  ]\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_012ZtBfPVa9bwPgBLJ4K1Zfr","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_0196SgWfgNeiDsWffZxrtUdj","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_a7642f1f5d31e91480432a43ade0b51b992578816dd67342'\n\n# Checkout the task\ncurl -s -X POST \"$PAPERCLIP_API_URL/api/issues/d447cdfb-1655-41ba-b222-a7fad582e53c/checkout\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" \\\n  -H \"X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID\" \\\n  -H \"Content-Type: application/json\" \\\n  -d '{\"agentId\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\", \"expectedStatuses\": [\"todo\", \"backlog\", \"blocked\"]}' | jq '{id, status, identifier}'"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":285,"cache_read_input_tokens":45526,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":285},"output_tokens":69,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"cd23429f-0783-4f7f-8199-39c5f9cc66a3"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_0196SgWfgNeiDsWffZxrtUdj","type":"tool_result","content":"{\n  \"id\": \"d447cdfb-1655-41ba-b222-a7fad582e53c\",\n  \"status\": \"in_progress\",\n  \"identifier\": \"AEGA-2\"\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"6263ba50-9a39-451d-8efc-8c1bc0635733","timestamp":"2026-04-03T07:18:28.256Z","tool_use_result":{"stdout":"{\n  \"id\": \"d447cdfb-1655-41ba-b222-a7fad582e53c\",\n  \"status\": \"in_progress\",\n  \"identifier\": \"AEGA-2\"\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_012ujHU5rYRrAjsdoq26PDQs","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01NHR7vW1HhtRPc7FULrs1PB","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_a7642f1f5d31e91480432a43ade0b51b992578816dd67342'\n\n# Get heartbeat context\ncurl -s \"$PAPERCLIP_API_URL/api/issues/d447cdfb-1655-41ba-b222-a7fad582e53c/heartbeat-context\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" | jq '.'"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":336,"cache_read_input_tokens":45811,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":336},"output_tokens":69,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"7e4ab2c5-24ab-45d5-9af2-2a857f22cd1d"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01NHR7vW1HhtRPc7FULrs1PB","type":"tool_result","content":"{\n  \"issue\": {\n    \"id\": \"d447cdfb-1655-41ba-b222-a7fad582e53c\",\n    \"identifier\": \"AEGA-2\",\n    \"title\": \"Build AEGIS org, create Sprint 1 plan, and delegate spec creation\",\n    \"description\": \"## Context\\nYou are Navi, CTO of AEGIS. Mother Brain (CEO) has activated the company and hired you as the first agent.\\n\\n## Current State\\n- Green-field: no code, no specs, no other agents besides you and CEO\\n- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline, 5-Gate Quality System, ISO 29110 compliance\\n- No BRD or SRS exists yet — this is the critical blocker\\n\\n## Your Mission\\n1. **Assess what agents are needed** for Sprint 1 (spec phase). At minimum: a Specification Architect (\\\"Sage\\\") to write BRD + SRS\\n2. **Request agent hires from CEO** — post comments on this task listing who you need hired, with role, capabilities, and rationale. CEO will submit hire requests.\\n3. **Once Sage is available**, create and assign a subtask for BRD + SRS specification using the super-spec skill\\n4. **Plan Sprint 1** — break the SDLC pipeline Phase A (IDEA → SPEC) into concrete tasks\\n5. **Report back** with your plan and any blockers\\n\\n## Constraints\\n- You cannot hire agents directly (no canCreateAgents permission). Request hires from CEO via comments.\\n- Use the paperclip skill for all coordination.\\n- Model routing: Opus thinks, Sonnet builds, Haiku gathers.\",\n    \"status\": \"in_progress\",\n    \"priority\": \"high\",\n    \"projectId\": \"15cf70f4-7785-4fa2-8d79-abadf14d8bb8\",\n    \"goalId\": \"f37b9d3a-60c7-431a-a03d-b9eda150e5ae\",\n    \"parentId\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n    \"assigneeAgentId\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n    \"assigneeUserId\": null,\n    \"updatedAt\": \"2026-04-03T07:18:28.246Z\"\n  },\n  \"ancestors\": [\n    {\n      \"id\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n      \"identifier\": \"AEGA-1\",\n      \"title\": \"Activate AEGIS: Scan project state, hire remaining agents, and begin Sprint 1\",\n      \"status\": \"in_progress\",\n      \"priority\": \"medium\"\n    }\n  ],\n  \"project\": {\n    \"id\": \"15cf70f4-7785-4fa2-8d79-abadf14d8bb8\",\n    \"name\": \"Onboarding\",\n    \"status\": \"in_progress\",\n    \"targetDate\": null\n  },\n  \"goal\": {\n    \"id\": \"f37b9d3a-60c7-431a-a03d-b9eda150e5ae\",\n    \"title\": \"Production-grade autonomous software delivery via 13 AI agents. 14-Stage SDLC Pipeline (IDEA → SPEC → BUILD → REVIEW → QA → COMPLY → DEPLOY → MONITOR) with 5-Gate Quality System and ISO 29110 Compliance. \\\"Context is King, Memory is Soul.\\\" Model routing: Opus thinks, Sonnet builds, Haiku gathers.\",\n    \"status\": \"active\",\n    \"level\": \"company\",\n    \"parentId\": null\n  },\n  \"commentCursor\": {\n    \"totalComments\": 0,\n    \"latestCommentId\": null,\n    \"latestCommentAt\": null\n  },\n  \"wakeComment\": null\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"ebf97ed1-98c8-48e3-b722-fcdbd44342c0","timestamp":"2026-04-03T07:18:31.553Z","tool_use_result":{"stdout":"{\n  \"issue\": {\n    \"id\": \"d447cdfb-1655-41ba-b222-a7fad582e53c\",\n    \"identifier\": \"AEGA-2\",\n    \"title\": \"Build AEGIS org, create Sprint 1 plan, and delegate spec creation\",\n    \"description\": \"## Context\\nYou are Navi, CTO of AEGIS. Mother Brain (CEO) has activated the company and hired you as the first agent.\\n\\n## Current State\\n- Green-field: no code, no specs, no other agents besides you and CEO\\n- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline, 5-Gate Quality System, ISO 29110 compliance\\n- No BRD or SRS exists yet — this is the critical blocker\\n\\n## Your Mission\\n1. **Assess what agents are needed** for Sprint 1 (spec phase). At minimum: a Specification Architect (\\\"Sage\\\") to write BRD + SRS\\n2. **Request agent hires from CEO** — post comments on this task listing who you need hired, with role, capabilities, and rationale. CEO will submit hire requests.\\n3. **Once Sage is available**, create and assign a subtask for BRD + SRS specification using the super-spec skill\\n4. **Plan Sprint 1** — break the SDLC pipeline Phase A (IDEA → SPEC) into concrete tasks\\n5. **Report back** with your plan and any blockers\\n\\n## Constraints\\n- You cannot hire agents directly (no canCreateAgents permission). Request hires from CEO via comments.\\n- Use the paperclip skill for all coordination.\\n- Model routing: Opus thinks, Sonnet builds, Haiku gathers.\",\n    \"status\": \"in_progress\",\n    \"priority\": \"high\",\n    \"projectId\": \"15cf70f4-7785-4fa2-8d79-abadf14d8bb8\",\n    \"goalId\": \"f37b9d3a-60c7-431a-a03d-b9eda150e5ae\",\n    \"parentId\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n    \"assigneeAgentId\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n    \"assigneeUserId\": null,\n    \"updatedAt\": \"2026-04-03T07:18:28.246Z\"\n  },\n  \"ancestors\": [\n    {\n      \"id\": \"af75be97-329e-4d28-80d9-27b03db4f7c6\",\n      \"identifier\": \"AEGA-1\",\n      \"title\": \"Activate AEGIS: Scan project state, hire remaining agents, and begin Sprint 1\",\n      \"status\": \"in_progress\",\n      \"priority\": \"medium\"\n    }\n  ],\n  \"project\": {\n    \"id\": \"15cf70f4-7785-4fa2-8d79-abadf14d8bb8\",\n    \"name\": \"Onboarding\",\n    \"status\": \"in_progress\",\n    \"targetDate\": null\n  },\n  \"goal\": {\n    \"id\": \"f37b9d3a-60c7-431a-a03d-b9eda150e5ae\",\n    \"title\": \"Production-grade autonomous software delivery via 13 AI agents. 14-Stage SDLC Pipeline (IDEA → SPEC → BUILD → REVIEW → QA → COMPLY → DEPLOY → MONITOR) with 5-Gate Quality System and ISO 29110 Compliance. \\\"Context is King, Memory is Soul.\\\" Model routing: Opus thinks, Sonnet builds, Haiku gathers.\",\n    \"status\": \"active\",\n    \"level\": \"company\",\n    \"parentId\": null\n  },\n  \"commentCursor\": {\n    \"totalComments\": 0,\n    \"latestCommentId\": null,\n    \"latestCommentAt\": null\n  },\n  \"wakeComment\": null\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_01RYucr6DHtJwW8pSsMZqtZ6","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01NB24uCDPVD3L7QzJXNQCcL","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_a7642f1f5d31e91480432a43ade0b51b992578816dd67342'\n\n# Get all agents in the company to see who exists\ncurl -s \"$PAPERCLIP_API_URL/api/companies/$PAPERCLIP_COMPANY_ID/agents\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" | jq '[.[] | {id, name, role, urlKey, status: .adapterConfig.status}]' 2>/dev/null || \\\ncurl -s \"$PAPERCLIP_API_URL/api/companies/$PAPERCLIP_COMPANY_ID/agents\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" | jq '[.[] | {id, name, role, urlKey}]'"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":1186,"cache_read_input_tokens":46147,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":1186},"output_tokens":72,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"2235e00a-70d5-427a-9c71-e041429385bb"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01NB24uCDPVD3L7QzJXNQCcL","type":"tool_result","content":"[\n  {\n    \"id\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n    \"name\": \"Mother Brain\",\n    \"role\": \"ceo\",\n    \"urlKey\": \"mother-brain\",\n    \"status\": null\n  },\n  {\n    \"id\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n    \"name\": \"Navi\",\n    \"role\": \"cto\",\n    \"urlKey\": \"navi\",\n    \"status\": null\n  }\n]","is_error":false}]},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"851ac041-1bb7-4476-9a9e-2caaa0a2398d","timestamp":"2026-04-03T07:18:37.563Z","tool_use_result":{"stdout":"[\n  {\n    \"id\": \"1e6d0b76-3817-4502-901e-7dd1356cd771\",\n    \"name\": \"Mother Brain\",\n    \"role\": \"ceo\",\n    \"urlKey\": \"mother-brain\",\n    \"status\": null\n  },\n  {\n    \"id\": \"3df78889-0a61-4fed-bb04-6c3134c3d2d8\",\n    \"name\": \"Navi\",\n    \"role\": \"cto\",\n    \"urlKey\": \"navi\",\n    \"status\": null\n  }\n]","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_01CRCTg1jUPANyUNCUSac68L","type":"message","role":"assistant","content":[{"type":"thinking","thinking":"So there are only 2 agents: Mother Brain (CEO) and Navi (me, CTO). I need to:\n1. Create a plan for Sprint 1\n2. Request that CEO hire Sage (Specification Architect) \n3. Create subtasks for Sprint 1 Phase A work\n\nThe task description says the company goal involves 13 AI agents for a 14-stage SDLC pipeline with 5-Gate Quality System and ISO 29110 compliance.\n\nThe 13 agents mentioned in the parent task (AEGA-1) are: Navi, Sage, Bolt, Vigil, Havoc, Forge, Pixel, Muse, Sentinel, Probe, Scribe, Ops.\n\n\nFor Sprint 1, I'm focusing on Phase A which moves from IDEA to SPEC—the critical blocker is getting Sage hired so they can write the BRD and SRS. I'll document the sprint plan, request Sage's hiring from Mother Brain, and break down the Phase A work into actionable subtasks.\n\nThe plan needs to outline the sprint goal of completing Phase A with the BRD and SRS as the foundation, identify Sage as the required agent, and map out the sequence: first getting Sage hired, then having them create the specification documents, and finally running a QualityGate 1 review to ensure the specs are complete. Let me start drafting the plan document.","signature":"EsEKClsIDBgCKkCssM+7DyC8wc56qBAm6uUefT4VBxvhFk9hSBNvUuo+OLfVgiHKpPEW8f2yM7QHP+0sN7HAIMLDlq8XgP/fzCecMhFjbGF1ZGUtc29ubmV0LTQtNjgAEgxNKzfpwiQ8rVSUA7kaDMMkOJKoS0bYOlP4SCIwq6cb9updAA93DLbAwkrFg8S4BpLsWlnH9IKzadR7jxMLwywudC71bliyn72CGlgXKpMJ8vbAldMTF8p2XB+ixxHZZQf3qgoUNfggtGte9uPD4ciTGHGJqBY15lkMsSsXuhnDfl445BDstvgdIUnOWGQ62ac6TJmILiov8XOTm4UU39ExjMKGw6VuGQB1PvWNBV4fGv9YABNs1WGHjY53oWThn3kTccms3At/e/x+IaWYmy5Vctssfp6IoLzA5drcUhO0V0SdGOdKi/4WDwwYDndFRFCpXF2JgLuhw2EhlqnCEFw/YGEM6ExMSH1z0hdnu8mbKLnBI/tNp15Q29gITlL7EqKCP2WnvTGPwdrV2cDDNPzuF+C9iKzAA4Texcej6Fl/K97LLXhOKBmqZCGstuhcu11p5ycv2FPz8/Sv71YUhc1LK9FluULxHmy+MvwWh+GprbzZUtcAxqjzpOdm1axovPnWp8nkFDiu84SevHd3/1vmO9NVt+RRcfFpmm/OOE9Tpi80WLZepevkA/5mGSjzkTyrEzGGcDfI6juxDmIiPxEm7wOa+JbwYBUCesm+u79LhBOaQkx0J9L+g6n44VHHl1toqkKwJG/tcx5FdfoKdn75IjTbQ2sLneKtdvAEcRpX8sSUESyEAef1tmCCPEX5kcm8zPLP90klvkXF4xhRPjOg301BD5Onqaes2TWP7PBRULFdh8C/SIWuEFducn1wBjkXWKu0oetmrgiwsKm1T0YkXWsZnQkwPI/TdhqR10dnQCIPC4wzhg6GsirJXb0QsGdGbGGYVfoX3YMLtEh1Udhc30Y2rHzfbEQ00YrPsfhoJG/+48UK9/SgwHRk6bEkILQQ+J9CFMW6P5O+/lh8BTkm70Dk9JuxwT51GGfp57EjY36Xcmqpl0Ntju+ybcYi6LoUTF+TtGoJk+ZAzCo9TdYIjlUVArcZ4FgzaQedykZfDa9rqUH/faI5w+HuyTa2eQG4buIosppRHKdj/KhKXlUhnuBmeFvqc8f2UziSpG2+G24XuSquJbVn4E4TblaINKUnJNjk7P1+qPwD1L48VuiJuNGWHri9Is7OdX2RZhjx8G/1SXDs8ekXQvOx6cZXGMHDOAzrXef+Ekt6+CG03SsgWAqFeNh+nihKRCVFYCy1PUvP9a7TtCs66u4KlnUgmlAQGGtpv8vYXlRXpu98XxU7Oyabq/QL/yn/JxhV063gWJaB+LVua70Zj93Jd8np3LjwoMl7/M3JKzjdnd+kmJ4S6CZnPKaTLlrSUogUjp6NH1UKDkHX3Bhn5yrbs3KxnJaI2H+VTZ+6SLn31t8UbOR/PiHmLqFh/jTQ/g8eOl9kXajJDB05jPu5T5dx3I5oJTVZtReR35Z16dou51KdSfX8nsqVGgfJhZIPlsyk3jlNsd7ZXnLMkLcB40aViYTwJHPZJYHflBxEhU8BNZG47IXvclsziHt5xE1cNU2pPxo34ly+kh0ccLFgiZBPyPIFkb3qLP30OwLScJqj1EJ+UFWVO9Tl1Q3t43A2ZS3ertpb7cJKf4kRNBXSV2U34+gIRHC/OItYCGoEUj/RiSa+coEbjE/gN1BubvFIL+nehwVyAeEoTzBIHZtZr3Hm72iltccnYxgB"}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":415,"cache_read_input_tokens":47333,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":415},"output_tokens":11,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"9b97d2cf-54b6-4df8-acff-fb8201e2eb36"}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_01CRCTg1jUPANyUNCUSac68L","type":"message","role":"assistant","content":[{"type":"text","text":"Good. Only Mother Brain and I exist. Now let me create the Sprint 1 plan and request Sage's hire."}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":415,"cache_read_input_tokens":47333,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":415},"output_tokens":11,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"59c8bf1d-0aab-4022-a739-05fc0a0c75c7"}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_01CRCTg1jUPANyUNCUSac68L","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_012VrVCPhbJGWJeRdEoMBUnK","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_a7642f1f5d31e91480432a43ade0b51b992578816dd67342'\n\n# Create the plan document on AEGA-2\ncurl -s -X PUT \"$PAPERCLIP_API_URL/api/issues/d447cdfb-1655-41ba-b222-a7fad582e53c/documents/plan\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" \\\n  -H \"X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID\" \\\n  -H \"Content-Type: application/json\" \\\n  -d '{\n    \"title\": \"Sprint 1 Plan — Phase A: IDEA → SPEC\",\n    \"format\": \"markdown\",\n    \"baseRevisionId\": null,\n    \"body\": \"# Sprint 1 Plan — Phase A: IDEA → SPEC\\n\\n## Goal\\nEstablish the BRD + SRS foundation for AEGIS autonomous software delivery platform. This is the critical pre-requisite for all downstream build, QA, and deployment phases.\\n\\n## Sprint 1 Scope\\nPhase A of the 14-Stage SDLC Pipeline: **IDEA → SPEC**\\n\\n## Decision Tree Entry Point\\n> P8 (No spec exists) → Run spec creation → breakdown → sprint plan → build\\n\\n## Phase A Tasks\\n\\n| # | Task | Owner | Status | Blocker |\\n|---|------|-------|--------|--------|\\n| A1 | Hire Sage (Specification Architect) | Mother Brain (CEO) | **Blocked — awaiting hire request** | CEO must submit hire |\\n| A2 | BRD + SRS creation via super-spec skill | Sage | Pending | A1 |\\n| A3 | QualityGate 1 — Spec completeness review | Navi (CTO) | Pending | A2 |\\n| A4 | Sprint 2 breakdown from validated spec | Navi (CTO) | Pending | A3 |\\n\\n## Agent Roster Needed for Sprint 1 (Phase A)\\n\\n### Sage — Specification Architect (CRITICAL PATH)\\n- **Role**: spec_architect\\n- **Capabilities**: BRD authoring, SRS drafting, requirements elicitation, ISO 29110 compliance mapping, super-spec skill\\n- **Rationale**: No spec exists. AEGIS cannot proceed past Phase A without a BRD and SRS. This is a P0 hire for Sprint 1.\\n- **Deliverable**: Complete BRD + SRS via `super-spec` skill on this project\\n\\n## Agents Needed for Sprint 2+ (Context Only)\\nOnce the spec is validated, the following agents will need to be hired for downstream phases:\\n\\n| Agent | Role | Phase |\\n|-------|------|-------|\\n| Bolt | Senior Developer | BUILD |\\n| Vigil | QA Lead | QA |\\n| Havoc | Security/Chaos | COMPLY |\\n| Forge | DevOps/CI-CD | DEPLOY |\\n| Pixel | Frontend Dev | BUILD |\\n| Muse | UX Designer | SPEC/BUILD |\\n| Sentinel | Monitoring | MONITOR |\\n| Probe | Test Automation | QA |\\n| Scribe | Technical Writer | COMPLY/DOC |\\n| Ops | Operations | DEPLOY/MONITOR |\\n\\n## Quality Gates\\n\\n### Gate 1 — Spec Completeness (end of Sprint 1)\\n- [ ] BRD covers: business context, stakeholders, requirements, success metrics\\n- [ ] SRS covers: functional specs, non-functional requirements, system constraints\\n- [ ] ISO 29110 Basic Profile work products accounted for\\n- [ ] All 14 pipeline stages have at least one acceptance criterion\\n\\n## Immediate Next Actions\\n1. **CEO (Mother Brain)**: Hire Sage with `spec_architect` role\\n2. **Navi (CTO)**: Once Sage is online, create AEGA-3 (BRD + SRS task) assigned to Sage\\n3. **Sage**: Execute super-spec skill to produce BRD + SRS\\n4. **Navi**: Review, approve at Gate 1, then plan Sprint 2\\n\\n## Success Criteria for Sprint 1\\n- Sage is hired and operational\\n- BRD + SRS document exists and passes Gate 1 review\\n- Sprint 2 breakdown is ready with agent hiring queue\\n\"\n  }' | jq '{id, key, title, revisionId}'"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":415,"cache_read_input_tokens":47333,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":415},"output_tokens":11,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"3d290d89-b0d1-480d-b75f-7e26c6c86b23"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_012VrVCPhbJGWJeRdEoMBUnK","type":"tool_result","content":"{\n  \"id\": \"09c406ff-9d42-4d8f-b736-0f0d454ca74f\",\n  \"key\": \"plan\",\n  \"title\": \"Sprint 1 Plan — Phase A: IDEA → SPEC\",\n  \"revisionId\": null\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"334d358e-82c2-48c6-ab44-a3a450e6922c","timestamp":"2026-04-03T07:19:04.141Z","tool_use_result":{"stdout":"{\n  \"id\": \"09c406ff-9d42-4d8f-b736-0f0d454ca74f\",\n  \"key\": \"plan\",\n  \"title\": \"Sprint 1 Plan — Phase A: IDEA → SPEC\",\n  \"revisionId\": null\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_01N3JArEjku6o6nmdKBvCsBt","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01KsZPCkXprS48cojuELLaEK","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_a7642f1f5d31e91480432a43ade0b51b992578816dd67342'\n\n# Post comment requesting Sage hire from CEO and summarizing the plan\ncurl -s -X POST \"$PAPERCLIP_API_URL/api/issues/d447cdfb-1655-41ba-b222-a7fad582e53c/comments\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" \\\n  -H \"X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID\" \\\n  -H \"Content-Type: application/json\" \\\n  -d '{\n    \"body\": \"## Sprint 1 Assessment — CTO Navi\\n\\n### Current State\\n- Only 2 agents exist: Mother Brain (CEO) and Navi (CTO)\\n- No code, no specs, no BRD, no SRS\\n- Entry point: **P8 Decision Tree** — no spec exists → run spec creation first\\n\\n### Sprint 1 Plan\\nI have created the Sprint 1 plan document: [AEGA-2 Plan](/AEGA/issues/AEGA-2#document-plan)\\n\\nPhase A goal: **IDEA → SPEC** (the critical pre-requisite for all 13 downstream stages)\\n\\n### Critical Hire Request for CEO\\n\\n**@Mother Brain** — I need you to hire one agent immediately to unblock Sprint 1:\\n\\n#### Sage — Specification Architect (P0 / Critical Path)\\n- **Role**: `spec_architect`\\n- **Capabilities needed**: BRD authoring, SRS drafting, requirements elicitation, ISO 29110 compliance mapping, `super-spec` skill\\n- **Why critical**: AEGIS has zero specification documents. Without a BRD + SRS, no agent can build, test, or deploy anything. Sage is the sole blocker for Sprint 1 completion.\\n- **Deliverable**: Complete BRD + SRS covering all 14 SDLC pipeline stages and 5-Gate Quality System\\n- **Model**: Opus 4.6 (spec work requires deep reasoning)\\n\\nPlease submit the hire request for Sage and assign them to this project (Onboarding, goal: f37b9d3a). Once Sage is hired and online, I will create subtask [AEGA-3] for the BRD + SRS work.\\n\\n### Phase A Task Breakdown\\n| # | Task | Owner | Unblocks |\\n|---|------|-------|----------|\\n| A1 | Hire Sage | CEO | Everything |\\n| A2 | BRD + SRS via super-spec | Sage | Gate 1 review |\\n| A3 | QualityGate 1 spec review | Navi | Sprint 2 planning |\\n| A4 | Sprint 2 breakdown | Navi | Agent hiring queue for BUILD phase |\\n\\n### Status\\nMarking [AEGA-2](/AEGA/issues/AEGA-2) as **blocked** pending Sage hire. Ready to proceed the moment CEO confirms.\"\n  }' | jq '{id, createdAt}'"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":1792,"cache_read_input_tokens":47748,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":1792},"output_tokens":65,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"c23b6a6f-4949-4bd6-a4aa-9bf4b900b315"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01KsZPCkXprS48cojuELLaEK","type":"tool_result","content":"{\n  \"id\": \"47319f92-702d-4053-90e7-6b43d978ed20\",\n  \"createdAt\": \"2026-04-03T07:19:19.140Z\"\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"cc2bb7ba-3875-45e9-ad8a-fbdc6725b327","timestamp":"2026-04-03T07:19:19.146Z","tool_use_result":{"stdout":"{\n  \"id\": \"47319f92-702d-4053-90e7-6b43d978ed20\",\n  \"createdAt\": \"2026-04-03T07:19:19.140Z\"\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_01QkAq7fm3SZA8y8J3XoFeM9","type":"message","role":"assistant","content":[{"type":"tool_use","id":"toolu_01MbD57RRZoMnCVAP8Aar568","name":"Bash","input":{"command":"export PAPERCLIP_API_KEY='pcp_a7642f1f5d31e91480432a43ade0b51b992578816dd67342'\n\n# Set AEGA-2 to blocked status\ncurl -s -X PATCH \"$PAPERCLIP_API_URL/api/issues/d447cdfb-1655-41ba-b222-a7fad582e53c\" \\\n  -H \"Authorization: Bearer $PAPERCLIP_API_KEY\" \\\n  -H \"X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID\" \\\n  -H \"Content-Type: application/json\" \\\n  -d '{\n    \"status\": \"blocked\",\n    \"comment\": \"Blocked: awaiting CEO (Mother Brain) to hire Sage (Specification Architect). No BRD/SRS can be created without Sage. Plan posted at /AEGA/issues/AEGA-2#document-plan. Hire request posted in comments.\"\n  }' | jq '{id, status, identifier}'"},"caller":{"type":"direct"}}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":905,"cache_read_input_tokens":49540,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":905},"output_tokens":72,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"c81b57e6-eb5d-4c9d-9510-17df19ab2166"}
{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_01MbD57RRZoMnCVAP8Aar568","type":"tool_result","content":"{\n  \"id\": \"d447cdfb-1655-41ba-b222-a7fad582e53c\",\n  \"status\": \"blocked\",\n  \"identifier\": \"AEGA-2\"\n}","is_error":false}]},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"7389a55e-b9c8-453c-8319-88b5911da86c","timestamp":"2026-04-03T07:19:24.192Z","tool_use_result":{"stdout":"{\n  \"id\": \"d447cdfb-1655-41ba-b222-a7fad582e53c\",\n  \"status\": \"blocked\",\n  \"identifier\": \"AEGA-2\"\n}","stderr":"","interrupted":false,"isImage":false,"noOutputExpected":false}}
{"type":"assistant","message":{"model":"claude-sonnet-4-6","id":"msg_011AvcjeoVygxMcw9iGyrZVo","type":"message","role":"assistant","content":[{"type":"text","text":"Done. Here's what I did as Navi (CTO of AEGIS):\n\n**Task: [AEGA-2](/AEGA/issues/AEGA-2) — Build AEGIS org, create Sprint 1 plan, and delegate spec creation**\n\n**Actions taken:**\n\n1. **Checked out** AEGA-2 and assessed current state: only Mother Brain (CEO) and I (Navi/CTO) exist. No specs, no code — green-field.\n\n2. **Created Sprint 1 Plan** at [AEGA-2#document-plan](/AEGA/issues/AEGA-2#document-plan):\n   - Phase A: IDEA → SPEC\n   - Entry point: P8 Decision Tree (no spec exists → run spec creation)\n   - 4 tasks: Hire Sage → BRD+SRS → Gate 1 review → Sprint 2 breakdown\n   - Full agent roster for Sprint 2+ documented (Bolt, Vigil, Havoc, Forge, Pixel, Muse, Sentinel, Probe, Scribe, Ops)\n\n3. **Posted hire request** to CEO (Mother Brain) for **Sage (Specification Architect)** — P0 critical path. Sage needs: BRD/SRS authoring, ISO 29110 compliance mapping, `super-spec` skill, Opus 4.6 model.\n\n4. **Set AEGA-2 to `blocked`** — waiting on CEO to hire Sage. Will resume and create AEGA-3 (BRD+SRS subtask) once Sage is online."}],"stop_reason":null,"stop_sequence":null,"stop_details":null,"usage":{"input_tokens":1,"cache_creation_input_tokens":369,"cache_read_input_tokens":50445,"cache_creation":{"ephemeral_5m_input_tokens":0,"ephemeral_1h_input_tokens":369},"output_tokens":1,"service_tier":"standard","inference_geo":"not_available"},"context_management":null},"parent_tool_use_id":null,"session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","uuid":"7b34eb5e-c590-40d1-9d5e-eede88899938"}
{"type":"result","subtype":"success","is_error":false,"duration_ms":169354,"duration_api_ms":152616,"num_turns":33,"result":"Done. Here's what I did as Navi (CTO of AEGIS):\n\n**Task: [AEGA-2](/AEGA/issues/AEGA-2) — Build AEGIS org, create Sprint 1 plan, and delegate spec creation**\n\n**Actions taken:**\n\n1. **Checked out** AEGA-2 and assessed current state: only Mother Brain (CEO) and I (Navi/CTO) exist. No specs, no code — green-field.\n\n2. **Created Sprint 1 Plan** at [AEGA-2#document-plan](/AEGA/issues/AEGA-2#document-plan):\n   - Phase A: IDEA → SPEC\n   - Entry point: P8 Decision Tree (no spec exists → run spec creation)\n   - 4 tasks: Hire Sage → BRD+SRS → Gate 1 review → Sprint 2 breakdown\n   - Full agent roster for Sprint 2+ documented (Bolt, Vigil, Havoc, Forge, Pixel, Muse, Sentinel, Probe, Scribe, Ops)\n\n3. **Posted hire request** to CEO (Mother Brain) for **Sage (Specification Architect)** — P0 critical path. Sage needs: BRD/SRS authoring, ISO 29110 compliance mapping, `super-spec` skill, Opus 4.6 model.\n\n4. **Set AEGA-2 to `blocked`** — waiting on CEO to hire Sage. Will resume and create AEGA-3 (BRD+SRS subtask) once Sage is online.","stop_reason":"end_turn","session_id":"ca78b91f-bd28-466e-b083-0cc2414dcce8","total_cost_usd":0.59638515,"usage":{"input_tokens":35,"cache_creation_input_tokens":27359,"cache_read_input_tokens":1301513,"output_tokens":6882,"server_tool_use":{"web_search_requests":0,"web_fetch_requests":0},"service_tier":"standard","cache_creation":{"ephemeral_1h_input_tokens":27359,"ephemeral_5m_input_tokens":0},"inference_geo":"","iterations":[],"speed":"standard"},"modelUsage":{"claude-sonnet-4-6":{"inputTokens":35,"outputTokens":6882,"cacheReadInputTokens":1301513,"cacheCreationInputTokens":27359,"webSearchRequests":0,"costUSD":0.59638515,"contextWindow":200000,"maxOutputTokens":32000}},"permission_denials":[],"terminal_reason":"completed","fast_mode_state":"off","uuid":"ce71274e-a613-4c39-b89a-392a90e9d2f3"}
$paperclip$, $paperclip$$paperclip$, NULL, 39420, $paperclip$2026-04-03T07:16:43.250Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.instance_settings (1 rows)
INSERT INTO "public"."instance_settings" ("id", "singleton_key", "experimental", "created_at", "updated_at", "general") VALUES ($paperclip$37352bcc-a4af-4526-b791-a09b5c7ab764$paperclip$, $paperclip$default$paperclip$, $paperclip${}$paperclip$, $paperclip$2026-04-03T07:05:53.840Z$paperclip$, $paperclip$2026-04-03T07:05:53.840Z$paperclip$, $paperclip${}$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.instance_user_roles (1 rows)
INSERT INTO "public"."instance_user_roles" ("id", "user_id", "role", "created_at", "updated_at") VALUES ($paperclip$67796b36-e44e-47f3-84ef-3d7d5f1e4615$paperclip$, $paperclip$local-board$paperclip$, $paperclip$instance_admin$paperclip$, $paperclip$2026-04-03T06:07:06.494Z$paperclip$, $paperclip$2026-04-03T06:07:06.494Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.invites (1 rows)
INSERT INTO "public"."invites" ("id", "company_id", "invite_type", "token_hash", "allowed_join_types", "defaults_payload", "expires_at", "invited_by_user_id", "revoked_at", "accepted_at", "created_at", "updated_at") VALUES ($paperclip$4527fe57-f36a-4ae6-8b58-8d7486332d31$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$company_join$paperclip$, $paperclip$a2985a84481bb514326819f5618896e7570303cfba8da3c28b11ce9a46864529$paperclip$, $paperclip$agent$paperclip$, NULL, $paperclip$2026-04-03T07:28:12.085Z$paperclip$, $paperclip$local-board$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:18:12.087Z$paperclip$, $paperclip$2026-04-03T07:18:12.087Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.issue_approvals (1 rows)
INSERT INTO "public"."issue_approvals" ("company_id", "issue_id", "approval_id", "linked_by_agent_id", "linked_by_user_id", "created_at") VALUES ($paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$8112ed6e-4eae-4360-9ac1-c5e88764c1b5$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip$2026-04-03T07:12:53.822Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.issue_comments (6 rows)
INSERT INTO "public"."issue_comments" ("id", "company_id", "issue_id", "author_agent_id", "author_user_id", "body", "created_at", "updated_at", "created_by_run_id") VALUES ($paperclip$866b8b93-7ff0-4abc-8e50-31f66c4d4d35$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, NULL, $paperclip$Starting Phase A — structured Q&A to gather requirements. Will ask 10 questions, then produce BRD + SRS + UX Blueprint for human approval before Phase B execution.$paperclip$, $paperclip$2026-04-03T07:11:35.297Z$paperclip$, $paperclip$2026-04-03T07:11:35.297Z$paperclip$, $paperclip$da5df186-9330-4ca7-a694-4d69440fbe0d$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_comments" ("id", "company_id", "issue_id", "author_agent_id", "author_user_id", "body", "created_at", "updated_at", "created_by_run_id") VALUES ($paperclip$7a4a7036-317e-4def-8f4d-ebace0368c21$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip$## Heartbeat 1 — Initial assessment and CTO hire

**Situation:**
- Green-field activation. Only CEO (me) exists. Zero agents, zero code, zero specs.
- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline.
- No spec exists → P8 priority: must create BRD + SRS before any build work.

**Actions taken:**
- Scanned project workspace: empty. No git repo, no files, no existing agents.
- Submitted CTO hire request for **Navi** (claude-sonnet-4-6, reports to me).
- Approval pending board review: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)

**Next steps (blocked on CTO approval):**
1. Once Navi is approved → delegate org build-out (hire remaining 12 agents)
2. Create subtask for BRD + SRS specification
3. Break company goal into Sprint 1 tasks
4. Assign spec creation to Sage (Specification Architect) once hired

**Status**: Blocked on board approval of CTO hire.$paperclip$, $paperclip$2026-04-03T07:13:14.360Z$paperclip$, $paperclip$2026-04-03T07:13:14.360Z$paperclip$, $paperclip$a59f0164-e5a8-45bf-8525-f5c02c090957$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_comments" ("id", "company_id", "issue_id", "author_agent_id", "author_user_id", "body", "created_at", "updated_at", "created_by_run_id") VALUES ($paperclip$c6555771-d45b-4763-82eb-3fdf03f613c8$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip$## Heartbeat 2 — CTO approved, delegation started

**Approval resolved:**
- Navi (CTO) hire approved by board: [8112ed6e](/AEGA/approvals/8112ed6e-4eae-4360-9ac1-c5e88764c1b5)
- Agent [Navi](/AEGA/agents/navi) is now active and idle

**Actions taken:**
- Created subtask [AEGA-2](/AEGA/issues/AEGA-2) — "Build AEGIS org, create Sprint 1 plan, and delegate spec creation"
- Assigned to Navi with full context on green-field state and spec-first priority
- Navi instructed to assess needed agents, request hires, and plan Sprint 1

**Hiring model:**
- Navi does not have canCreateAgents — will request hires via comments
- I (CEO) will submit hire requests as Navi identifies needed roles
- First expected hire: Sage (Specification Architect) for BRD + SRS

**Status**: Unblocked. Waiting for Navi to pick up [AEGA-2](/AEGA/issues/AEGA-2).$paperclip$, $paperclip$2026-04-03T07:17:00.594Z$paperclip$, $paperclip$2026-04-03T07:17:00.594Z$paperclip$, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_comments" ("id", "company_id", "issue_id", "author_agent_id", "author_user_id", "body", "created_at", "updated_at", "created_by_run_id") VALUES ($paperclip$47319f92-702d-4053-90e7-6b43d978ed20$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, NULL, $paperclip$## Sprint 1 Assessment — CTO Navi

### Current State
- Only 2 agents exist: Mother Brain (CEO) and Navi (CTO)
- No code, no specs, no BRD, no SRS
- Entry point: **P8 Decision Tree** — no spec exists → run spec creation first

### Sprint 1 Plan
I have created the Sprint 1 plan document: [AEGA-2 Plan](/AEGA/issues/AEGA-2#document-plan)

Phase A goal: **IDEA → SPEC** (the critical pre-requisite for all 13 downstream stages)

### Critical Hire Request for CEO

**@Mother Brain** — I need you to hire one agent immediately to unblock Sprint 1:

#### Sage — Specification Architect (P0 / Critical Path)
- **Role**: `spec_architect`
- **Capabilities needed**: BRD authoring, SRS drafting, requirements elicitation, ISO 29110 compliance mapping, `super-spec` skill
- **Why critical**: AEGIS has zero specification documents. Without a BRD + SRS, no agent can build, test, or deploy anything. Sage is the sole blocker for Sprint 1 completion.
- **Deliverable**: Complete BRD + SRS covering all 14 SDLC pipeline stages and 5-Gate Quality System
- **Model**: Opus 4.6 (spec work requires deep reasoning)

Please submit the hire request for Sage and assign them to this project (Onboarding, goal: f37b9d3a). Once Sage is hired and online, I will create subtask [AEGA-3] for the BRD + SRS work.

### Phase A Task Breakdown
| # | Task | Owner | Unblocks |
|---|------|-------|----------|
| A1 | Hire Sage | CEO | Everything |
| A2 | BRD + SRS via super-spec | Sage | Gate 1 review |
| A3 | QualityGate 1 spec review | Navi | Sprint 2 planning |
| A4 | Sprint 2 breakdown | Navi | Agent hiring queue for BUILD phase |

### Status
Marking [AEGA-2](/AEGA/issues/AEGA-2) as **blocked** pending Sage hire. Ready to proceed the moment CEO confirms.$paperclip$, $paperclip$2026-04-03T07:19:19.140Z$paperclip$, $paperclip$2026-04-03T07:19:19.140Z$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_comments" ("id", "company_id", "issue_id", "author_agent_id", "author_user_id", "body", "created_at", "updated_at", "created_by_run_id") VALUES ($paperclip$1d190a36-d77e-4ea2-89d9-9d8b293d3726$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, NULL, $paperclip$Blocked: awaiting CEO (Mother Brain) to hire Sage (Specification Architect). No BRD/SRS can be created without Sage. Plan posted at /AEGA/issues/AEGA-2#document-plan. Hire request posted in comments.$paperclip$, $paperclip$2026-04-03T07:19:24.176Z$paperclip$, $paperclip$2026-04-03T07:19:24.176Z$paperclip$, $paperclip$fcdc325d-fe50-434d-b011-904de1bb60e5$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_comments" ("id", "company_id", "issue_id", "author_agent_id", "author_user_id", "body", "created_at", "updated_at", "created_by_run_id") VALUES ($paperclip$45f82b39-fc0c-4676-b7e8-eb6312087941$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$Parking - no active product project yet. Will reactivate when a real project begins.$paperclip$, $paperclip$2026-04-03T07:47:19.101Z$paperclip$, $paperclip$2026-04-03T07:47:19.101Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.issue_documents (1 rows)
INSERT INTO "public"."issue_documents" ("id", "company_id", "issue_id", "document_id", "key", "created_at", "updated_at") VALUES ($paperclip$09fc9c70-9225-48ef-864d-ac8245aad0eb$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$09c406ff-9d42-4d8f-b736-0f0d454ca74f$paperclip$, $paperclip$plan$paperclip$, $paperclip$2026-04-03T07:19:04.131Z$paperclip$, $paperclip$2026-04-03T07:19:04.131Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.issue_read_states (5 rows)
INSERT INTO "public"."issue_read_states" ("id", "company_id", "issue_id", "user_id", "last_read_at", "created_at", "updated_at") VALUES ($paperclip$b3838f68-2926-4331-9996-263ece47b1de$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:15:23.078Z$paperclip$, $paperclip$2026-04-03T07:11:04.509Z$paperclip$, $paperclip$2026-04-03T07:15:23.078Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_read_states" ("id", "company_id", "issue_id", "user_id", "last_read_at", "created_at", "updated_at") VALUES ($paperclip$f980bb91-d072-421b-ac37-75b9a04948b5$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$270b74c3-64ed-42da-aa3c-62285281725d$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:21:11.824Z$paperclip$, $paperclip$2026-04-03T07:21:11.825Z$paperclip$, $paperclip$2026-04-03T07:21:11.824Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_read_states" ("id", "company_id", "issue_id", "user_id", "last_read_at", "created_at", "updated_at") VALUES ($paperclip$b41bf5e8-4201-4ba9-b04a-66a42125c16a$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$aa16b27c-7ac5-4840-ada3-c2b80ffe00e8$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:21:14.613Z$paperclip$, $paperclip$2026-04-03T07:21:14.613Z$paperclip$, $paperclip$2026-04-03T07:21:14.613Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_read_states" ("id", "company_id", "issue_id", "user_id", "last_read_at", "created_at", "updated_at") VALUES ($paperclip$4dc05404-f316-4d1e-b74e-34aebe161dbf$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$56aaf90a-6b56-4079-aac6-6973aeec8370$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:21:18.348Z$paperclip$, $paperclip$2026-04-03T07:21:18.348Z$paperclip$, $paperclip$2026-04-03T07:21:18.348Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_read_states" ("id", "company_id", "issue_id", "user_id", "last_read_at", "created_at", "updated_at") VALUES ($paperclip$bccba4b9-a7d0-4bed-9681-df686021400f$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:28:12.063Z$paperclip$, $paperclip$2026-04-03T07:14:33.485Z$paperclip$, $paperclip$2026-04-03T07:28:12.063Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.issues (8 rows)
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$16332a71-9b62-4703-a0a6-452b1fabc4a7$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, $paperclip$7f94b7a6-1400-4bb8-8dbf-3761aa171461$paperclip$, NULL, $paperclip$[SPEC] Create BRD + SRS specification template$paperclip$, $paperclip$Phase A: Sage conducts structured Q&A (10 questions) with human. Produce BRD + SRS + UX Blueprint. Human approval required before Phase B autonomous execution.$paperclip$, $paperclip$backlog$paperclip$, $paperclip$high$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, NULL, $paperclip$local-board$paperclip$, 0, NULL, $paperclip$2026-04-03T07:11:23.028Z$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:09:13.716Z$paperclip$, $paperclip$2026-04-03T07:47:19.102Z$paperclip$, 1, $paperclip$AEG-1$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$4509a2a8-afab-4f59-8d29-ae9a245eb295$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, $paperclip$4ddcd07b-d8c9-4b10-be66-fa9a06a585ce$paperclip$, NULL, $paperclip$[BUILD] Implement feature from approved spec$paperclip$, $paperclip$Phase B: Bolt implements from approved spec. Vigil reviews (Gate 1). Must include test coverage for all new features.$paperclip$, $paperclip$backlog$paperclip$, $paperclip$high$paperclip$, $paperclip$34810f8a-b6f9-452e-884c-428b3fb0dbc9$paperclip$, NULL, $paperclip$local-board$paperclip$, 0, NULL, NULL, NULL, NULL, $paperclip$2026-04-03T07:09:13.762Z$paperclip$, $paperclip$2026-04-03T07:47:19.121Z$paperclip$, 2, $paperclip$AEG-2$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$ba377e27-bd3d-438c-bd46-bf6688dbcde7$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, $paperclip$4ddcd07b-d8c9-4b10-be66-fa9a06a585ce$paperclip$, NULL, $paperclip$[REVIEW] Gate 1 - Code review by Vigil$paperclip$, $paperclip$Gate 1: Review code for correctness, security, performance, maintainability, and compliance. Block merge on critical findings.$paperclip$, $paperclip$backlog$paperclip$, $paperclip$high$paperclip$, $paperclip$efb1cef7-7aa4-42ab-97bc-05d9b453486b$paperclip$, NULL, $paperclip$local-board$paperclip$, 0, NULL, NULL, NULL, NULL, $paperclip$2026-04-03T07:09:13.800Z$paperclip$, $paperclip$2026-04-03T07:47:19.150Z$paperclip$, 3, $paperclip$AEG-3$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$56aaf90a-6b56-4079-aac6-6973aeec8370$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, $paperclip$4ddcd07b-d8c9-4b10-be66-fa9a06a585ce$paperclip$, NULL, $paperclip$[QA] Gate 2 - Test strategy and execution$paperclip$, $paperclip$Gate 2: Sentinel creates test plan, Probe executes. Functional + acceptance + regression testing. Coverage analysis and release gate verdict.$paperclip$, $paperclip$backlog$paperclip$, $paperclip$high$paperclip$, $paperclip$50a29397-83bc-4fae-976b-ea22d69d6a3a$paperclip$, NULL, $paperclip$local-board$paperclip$, 0, NULL, NULL, NULL, NULL, $paperclip$2026-04-03T07:09:13.837Z$paperclip$, $paperclip$2026-04-03T07:47:19.192Z$paperclip$, 4, $paperclip$AEG-4$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$aa16b27c-7ac5-4840-ada3-c2b80ffe00e8$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, $paperclip$3244e301-acf7-4c11-8517-2befc568e7b5$paperclip$, NULL, $paperclip$[COMPLY] Gate 3 - ISO 29110 compliance check$paperclip$, $paperclip$Gate 3: Scribe verifies all 14 work products updated. Traceability matrix current. Audit trail documented.$paperclip$, $paperclip$backlog$paperclip$, $paperclip$medium$paperclip$, $paperclip$a3dd8cc4-cf7b-486f-be25-dce12648d8eb$paperclip$, NULL, $paperclip$local-board$paperclip$, 0, NULL, NULL, NULL, NULL, $paperclip$2026-04-03T07:09:13.878Z$paperclip$, $paperclip$2026-04-03T07:47:19.221Z$paperclip$, 5, $paperclip$AEG-5$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$270b74c3-64ed-42da-aa3c-62285281725d$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, $paperclip$768df2fa-cd17-40f3-a516-28e6c409ced4$paperclip$, NULL, $paperclip$[DEPLOY] Gate 4-5 - Deploy and monitor$paperclip$, $paperclip$Gate 4: Build, deploy, health check, smoke test. Gate 5: Monitor 5 min post-deploy, error rate <2x baseline, rollback readiness.$paperclip$, $paperclip$backlog$paperclip$, $paperclip$high$paperclip$, $paperclip$d99e4fff-2aa7-45e6-95d6-110bfd77d01d$paperclip$, NULL, $paperclip$local-board$paperclip$, 0, NULL, NULL, NULL, NULL, $paperclip$2026-04-03T07:09:13.922Z$paperclip$, $paperclip$2026-04-03T07:47:19.257Z$paperclip$, 6, $paperclip$AEG-6$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, $paperclip$f37b9d3a-60c7-431a-a03d-b9eda150e5ae$paperclip$, NULL, $paperclip$Activate AEGIS: Scan project state, hire remaining agents, and begin Sprint 1$paperclip$, $paperclip$You are Mother Brain — the autonomous decision engine of AEGIS.

Your mission:
1. Scan the current project state (git, files, existing agents, goals)
2. Review the 13-agent org chart already created (Navi, Sage, Bolt, Vigil, Havoc, Forge, Pixel, Muse, Sentinel, Probe, Scribe, Ops)
3. Verify all agents report to correct hierarchy (you → Navi → specialists)
4. Break the company goal into Sprint 1 tasks using the 14-stage SDLC pipeline
5. Assign high-priority tasks to appropriate agents via issues
6. Begin Phase A: Delegate to Sage for BRD + SRS specification if no spec exists

Decision Priority: P8 (No spec exists) → run spec creation → breakdown → sprint plan → build

Rules:
- Do NOT ask what to do — analyze, decide, execute, report
- Announce what you are doing with rationale
- Stop on critical QualityGate failures
- Respect context budget zones (GREEN/YELLOW/ORANGE/RED)$paperclip$, $paperclip$in_progress$paperclip$, $paperclip$medium$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, $paperclip$local-board$paperclip$, 0, NULL, $paperclip$2026-04-03T07:17:00.588Z$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:11:04.172Z$paperclip$, $paperclip$2026-04-03T07:17:10.817Z$paperclip$, 1, $paperclip$AEGA-1$paperclip$, NULL, $paperclip$d1c08dfe-79d2-4b00-bebe-cf556cb7b15e$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$d447cdfb-1655-41ba-b222-a7fad582e53c$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, $paperclip$f37b9d3a-60c7-431a-a03d-b9eda150e5ae$paperclip$, $paperclip$af75be97-329e-4d28-80d9-27b03db4f7c6$paperclip$, $paperclip$Build AEGIS org, create Sprint 1 plan, and delegate spec creation$paperclip$, $paperclip$## Context
You are Navi, CTO of AEGIS. Mother Brain (CEO) has activated the company and hired you as the first agent.

## Current State
- Green-field: no code, no specs, no other agents besides you and CEO
- Company goal: production-grade autonomous software delivery via 13 AI agents, 14-stage SDLC pipeline, 5-Gate Quality System, ISO 29110 compliance
- No BRD or SRS exists yet — this is the critical blocker

## Your Mission
1. **Assess what agents are needed** for Sprint 1 (spec phase). At minimum: a Specification Architect ("Sage") to write BRD + SRS
2. **Request agent hires from CEO** — post comments on this task listing who you need hired, with role, capabilities, and rationale. CEO will submit hire requests.
3. **Once Sage is available**, create and assign a subtask for BRD + SRS specification using the super-spec skill
4. **Plan Sprint 1** — break the SDLC pipeline Phase A (IDEA → SPEC) into concrete tasks
5. **Report back** with your plan and any blockers

## Constraints
- You cannot hire agents directly (no canCreateAgents permission). Request hires from CEO via comments.
- Use the paperclip skill for all coordination.
- Model routing: Opus thinks, Sonnet builds, Haiku gathers.$paperclip$, $paperclip$blocked$paperclip$, $paperclip$high$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, NULL, 0, NULL, $paperclip$2026-04-03T07:18:28.246Z$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:16:43.117Z$paperclip$, $paperclip$2026-04-03T07:19:33.715Z$paperclip$, 2, $paperclip$AEGA-2$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.principal_permission_grants (15 rows)
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$eff9ddca-9c67-44b8-adbc-89b82e6c2cf5$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$32eb19c3-4746-4313-b75a-c136b3e53061$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.003Z$paperclip$, $paperclip$2026-04-03T07:08:43.003Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$70ca1fef-96f5-480a-95a1-b73533c4be87$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.083Z$paperclip$, $paperclip$2026-04-03T07:08:43.083Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$a2fc540b-8458-489d-9d75-05ef0727d2d8$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$fb9504df-4a79-403a-8c73-efd73abf869c$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.125Z$paperclip$, $paperclip$2026-04-03T07:08:43.125Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$4cce7d7a-368d-43ef-b3eb-f89b9413ac97$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$34810f8a-b6f9-452e-884c-428b3fb0dbc9$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.172Z$paperclip$, $paperclip$2026-04-03T07:08:43.172Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$911b5fc6-0928-4904-af1f-9e3b36e7e6d9$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$efb1cef7-7aa4-42ab-97bc-05d9b453486b$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.213Z$paperclip$, $paperclip$2026-04-03T07:08:43.213Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$3eacd06a-54b8-4954-ba75-8997c02f8b36$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$634372bd-2e09-4ff7-bbd8-6edbee0db841$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.259Z$paperclip$, $paperclip$2026-04-03T07:08:43.259Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$40f2a0b9-5cb6-4a54-ba0f-95f9be91bf35$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$2e52a6a5-ee41-4fc4-9017-e848cf543932$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.298Z$paperclip$, $paperclip$2026-04-03T07:08:43.298Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$4cbefbf4-aedc-4919-adac-7b2f28aea095$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$06e05816-7d38-4c2a-a387-0a5661de648b$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.338Z$paperclip$, $paperclip$2026-04-03T07:08:43.338Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$80d4e60f-9fd7-4f49-ba49-0255e881308d$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$c629de00-1589-408c-b400-be83dfa48253$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.379Z$paperclip$, $paperclip$2026-04-03T07:08:43.379Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$7874caca-7133-4d80-83d6-8c8f958e8688$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$50a29397-83bc-4fae-976b-ea22d69d6a3a$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.416Z$paperclip$, $paperclip$2026-04-03T07:08:43.416Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$98723233-30e3-47e0-af5f-d856b6a8a17c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$a412beec-95ba-44dd-bdd1-dcb608629065$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.452Z$paperclip$, $paperclip$2026-04-03T07:08:43.452Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$edd24dac-8682-41a6-af28-60be4571fcc5$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$a3dd8cc4-cf7b-486f-be25-dce12648d8eb$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.494Z$paperclip$, $paperclip$2026-04-03T07:08:43.494Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$1d0c34e5-e5a1-4244-adf8-8d901d0d6c08$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$agent$paperclip$, $paperclip$d99e4fff-2aa7-45e6-95d6-110bfd77d01d$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:43.539Z$paperclip$, $paperclip$2026-04-03T07:08:43.539Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$fc8614b9-dca6-445b-b126-d319d94228e6$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$1e6d0b76-3817-4502-901e-7dd1356cd771$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:08:44.061Z$paperclip$, $paperclip$2026-04-03T07:08:44.061Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$8fd4c408-958e-43e7-aae0-19bcd163d793$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$agent$paperclip$, $paperclip$3df78889-0a61-4fed-bb04-6c3134c3d2d8$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:12:53.831Z$paperclip$, $paperclip$2026-04-03T07:12:53.831Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.project_goals (2 rows)
INSERT INTO "public"."project_goals" ("project_id", "goal_id", "company_id", "created_at", "updated_at") VALUES ($paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, $paperclip$d7745ec8-1cec-4a57-a260-b810aaeaaec9$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$2026-04-03T07:09:13.649Z$paperclip$, $paperclip$2026-04-03T07:09:13.649Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."project_goals" ("project_id", "goal_id", "company_id", "created_at", "updated_at") VALUES ($paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, $paperclip$f37b9d3a-60c7-431a-a03d-b9eda150e5ae$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$2026-04-03T07:11:04.150Z$paperclip$, $paperclip$2026-04-03T07:11:04.150Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.projects (2 rows)
INSERT INTO "public"."projects" ("id", "company_id", "goal_id", "name", "description", "status", "lead_agent_id", "target_date", "created_at", "updated_at", "color", "archived_at", "execution_workspace_policy", "pause_reason", "paused_at") VALUES ($paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$d7745ec8-1cec-4a57-a260-b810aaeaaec9$paperclip$, $paperclip$AEGIS Sprint Workspace$paperclip$, $paperclip$Active development workspace for AEGIS-managed sprints. 14-stage SDLC pipeline with 5-Gate quality system.$paperclip$, $paperclip$in_progress$paperclip$, $paperclip$32eb19c3-4746-4313-b75a-c136b3e53061$paperclip$, NULL, $paperclip$2026-04-03T07:09:13.636Z$paperclip$, $paperclip$2026-04-03T07:09:13.636Z$paperclip$, $paperclip$#6366f1$paperclip$, NULL, NULL, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."projects" ("id", "company_id", "goal_id", "name", "description", "status", "lead_agent_id", "target_date", "created_at", "updated_at", "color", "archived_at", "execution_workspace_policy", "pause_reason", "paused_at") VALUES ($paperclip$15cf70f4-7785-4fa2-8d79-abadf14d8bb8$paperclip$, $paperclip$3cfded27-7059-4ce7-a93e-11fd3d0eb4af$paperclip$, $paperclip$f37b9d3a-60c7-431a-a03d-b9eda150e5ae$paperclip$, $paperclip$Onboarding$paperclip$, NULL, $paperclip$in_progress$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:11:04.147Z$paperclip$, $paperclip$2026-04-03T07:11:04.147Z$paperclip$, $paperclip$#6366f1$paperclip$, NULL, NULL, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.routine_triggers (3 rows)
INSERT INTO "public"."routine_triggers" ("id", "company_id", "routine_id", "kind", "label", "enabled", "cron_expression", "timezone", "next_run_at", "last_fired_at", "public_id", "secret_id", "signing_mode", "replay_window_sec", "last_rotated_at", "last_result", "created_by_agent_id", "created_by_user_id", "updated_by_agent_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$8381bf68-225e-491e-a9eb-99f3eb27031c$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$fde6d1f8-b636-42e5-81c2-a2b81d3adce3$paperclip$, $paperclip$schedule$paperclip$, $paperclip$Heartbeat every 5 min$paperclip$, true, $paperclip$*/5 * * * *$paperclip$, $paperclip$Asia/Bangkok$paperclip$, $paperclip$2026-04-03T07:50:00.000Z$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local-board$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:48:09.508Z$paperclip$, $paperclip$2026-04-03T07:48:09.508Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."routine_triggers" ("id", "company_id", "routine_id", "kind", "label", "enabled", "cron_expression", "timezone", "next_run_at", "last_fired_at", "public_id", "secret_id", "signing_mode", "replay_window_sec", "last_rotated_at", "last_result", "created_by_agent_id", "created_by_user_id", "updated_by_agent_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$cf0584ef-fced-4403-a5a5-f61cb731219d$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$ddff6130-5b12-4618-bdeb-dea25eba121e$paperclip$, $paperclip$schedule$paperclip$, $paperclip$Weekday 09:00 ICT$paperclip$, true, $paperclip$0 9 * * 1-5$paperclip$, $paperclip$Asia/Bangkok$paperclip$, $paperclip$2026-04-06T02:00:00.000Z$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local-board$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:48:09.638Z$paperclip$, $paperclip$2026-04-03T07:48:09.638Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."routine_triggers" ("id", "company_id", "routine_id", "kind", "label", "enabled", "cron_expression", "timezone", "next_run_at", "last_fired_at", "public_id", "secret_id", "signing_mode", "replay_window_sec", "last_rotated_at", "last_result", "created_by_agent_id", "created_by_user_id", "updated_by_agent_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$17be08b5-431d-402d-a66f-9dd24b85e3ee$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$cc6cdb9a-5514-4442-8a4b-67c7b58b8d1b$paperclip$, $paperclip$schedule$paperclip$, $paperclip$Weekly Mon 06:00 ICT$paperclip$, true, $paperclip$0 6 * * 1$paperclip$, $paperclip$Asia/Bangkok$paperclip$, $paperclip$2026-04-05T23:00:00.000Z$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local-board$paperclip$, NULL, $paperclip$local-board$paperclip$, $paperclip$2026-04-03T07:48:09.751Z$paperclip$, $paperclip$2026-04-03T07:48:09.751Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.routines (3 rows)
INSERT INTO "public"."routines" ("id", "company_id", "project_id", "goal_id", "parent_issue_id", "title", "description", "assignee_agent_id", "priority", "status", "concurrency_policy", "catch_up_policy", "created_by_agent_id", "created_by_user_id", "updated_by_agent_id", "updated_by_user_id", "last_triggered_at", "last_enqueued_at", "created_at", "updated_at", "variables") VALUES ($paperclip$fde6d1f8-b636-42e5-81c2-a2b81d3adce3$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, NULL, NULL, $paperclip$Mother Brain Heartbeat$paperclip$, $paperclip$Persistent heartbeat: PULSE, SCAN, ANALYZE, DECIDE, DISPATCH, VERIFY, LEARN, BUDGET, WAIT. Monitors agent health, dispatches tasks, enforces quality gates.$paperclip$, $paperclip$32eb19c3-4746-4313-b75a-c136b3e53061$paperclip$, $paperclip$critical$paperclip$, $paperclip$paused$paperclip$, $paperclip$coalesce_if_active$paperclip$, $paperclip$skip_missed$paperclip$, NULL, $paperclip$local-board$paperclip$, NULL, $paperclip$local-board$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:48:09.299Z$paperclip$, $paperclip$2026-04-03T07:48:09.299Z$paperclip$, $paperclip$[]$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."routines" ("id", "company_id", "project_id", "goal_id", "parent_issue_id", "title", "description", "assignee_agent_id", "priority", "status", "concurrency_policy", "catch_up_policy", "created_by_agent_id", "created_by_user_id", "updated_by_agent_id", "updated_by_user_id", "last_triggered_at", "last_enqueued_at", "created_at", "updated_at", "variables") VALUES ($paperclip$ddff6130-5b12-4618-bdeb-dea25eba121e$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, NULL, NULL, $paperclip$Daily Sprint Standup$paperclip$, $paperclip$Navi scans sprint board, collects agent status, identifies blockers, generates standup report.$paperclip$, $paperclip$b5c1a56a-93f9-465a-9cdb-3cfd724dbcd0$paperclip$, $paperclip$high$paperclip$, $paperclip$paused$paperclip$, $paperclip$skip_if_active$paperclip$, $paperclip$skip_missed$paperclip$, NULL, $paperclip$local-board$paperclip$, NULL, $paperclip$local-board$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:48:09.376Z$paperclip$, $paperclip$2026-04-03T07:48:09.376Z$paperclip$, $paperclip$[]$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."routines" ("id", "company_id", "project_id", "goal_id", "parent_issue_id", "title", "description", "assignee_agent_id", "priority", "status", "concurrency_policy", "catch_up_policy", "created_by_agent_id", "created_by_user_id", "updated_by_agent_id", "updated_by_user_id", "last_triggered_at", "last_enqueued_at", "created_at", "updated_at", "variables") VALUES ($paperclip$cc6cdb9a-5514-4442-8a4b-67c7b58b8d1b$paperclip$, $paperclip$9c929d23-2ccc-4a69-9757-348ec303068b$paperclip$, $paperclip$dc7a1520-a4e8-4d1e-bd00-2af555fbe7dc$paperclip$, NULL, NULL, $paperclip$Weekly Dependency & Security Scan$paperclip$, $paperclip$Forge scans codebase for outdated dependencies, known CVEs, and security vulnerabilities.$paperclip$, $paperclip$2e52a6a5-ee41-4fc4-9017-e848cf543932$paperclip$, $paperclip$medium$paperclip$, $paperclip$paused$paperclip$, $paperclip$skip_if_active$paperclip$, $paperclip$skip_missed$paperclip$, NULL, $paperclip$local-board$paperclip$, NULL, $paperclip$local-board$paperclip$, NULL, NULL, $paperclip$2026-04-03T07:48:09.417Z$paperclip$, $paperclip$2026-04-03T07:48:09.417Z$paperclip$, $paperclip$[]$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.user (1 rows)
INSERT INTO "public"."user" ("id", "name", "email", "email_verified", "image", "created_at", "updated_at") VALUES ($paperclip$local-board$paperclip$, $paperclip$Board$paperclip$, $paperclip$local@paperclip.local$paperclip$, true, NULL, $paperclip$2026-04-03T06:07:06.474Z$paperclip$, $paperclip$2026-04-03T06:07:06.474Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Sequence values
SELECT setval('"public"."heartbeat_run_events_id_seq"', 12, true);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

COMMIT;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
