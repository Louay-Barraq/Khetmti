import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/providers/supabase_providers.dart';
import 'package:khetmti/features/auth/models/app_user.dart';

final rankingsProvider = FutureProvider<List<AppUser>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return [];

  final userRow = await supabase
      .from('users')
      .select('friends')
      .eq('doc_id', userId)
      .single();
  final friendIds = List<String>.from(userRow['friends'] ?? []);

  final ids = [userId, ...friendIds];
  final profiles = await supabase.from('users').select().inFilter('doc_id', ids);

  final users = profiles.map<AppUser>(AppUser.fromSupabase).toList();
  users.sort((a, b) => b.totalXP.compareTo(a.totalXP));
  return users;
});
