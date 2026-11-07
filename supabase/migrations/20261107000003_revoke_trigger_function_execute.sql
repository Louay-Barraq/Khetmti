-- Trigger functions run as triggers only; nobody should call them through the API.
-- Flagged by the Supabase security advisor after migration 20261107000002.
revoke execute on function public.handle_new_user(), public.rls_auto_enable()
  from public, anon, authenticated;
