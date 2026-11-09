/// Links in Supabase emails that open the app. Each one must be listed under
/// Authentication → URL Configuration → Redirect URLs in the Supabase
/// dashboard (`khetmti://**` covers all of them), or Supabase sends the user
/// to the Site URL instead.
abstract final class DeepLinks {
  static const scheme = 'khetmti';
  static const resetPassword = '$scheme://reset-password';
  static const emailChanged = '$scheme://email-changed';
}
