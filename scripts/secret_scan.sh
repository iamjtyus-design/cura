#!/usr/bin/env sh
set -eu

scan_paths="Cura Package.swift .github docs config scripts supabase website"

if grep -RInE "(SUPABASE_SERVICE_ROLE_KEY|GOOGLE_GEMINI_API_KEY|SPEECH_TO_TEXT_API_KEY|STRUCTURED_GENERATION_API_KEY|REVENUECAT_WEBHOOK_SECRET|ANALYTICS_WRITE_KEY)[[:space:]]*=[^[:space:]]+" $scan_paths; then
  echo "Potential server secret value found."
  exit 1
fi

if grep -RInE "(sk-[A-Za-z0-9_-]{20,}|AIza[A-Za-z0-9_-]{20,}|eyJ[A-Za-z0-9_-]{20,})" $scan_paths; then
  echo "Potential credential pattern found."
  exit 1
fi

echo "No server secret values detected."
