import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_models.dart';

class SocialSyncService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> upsertProfile(UserProfile profile) async {
    try {
      await _client.from('profiles').upsert({
        'id': profile.id,
        'full_name': profile.name,
        'handle': profile.handle,
        'avatar_url': profile.avatarUrl,
        'bio': profile.bio,
        'country': profile.country,
        'classification': profile.classification,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> saveDirectMessage(ChatMessage msg) async {
    try {
      await _client.from('direct_messages').insert({
        'id': msg.id,
        'from_user_id': msg.fromUserId,
        'to_user_id': msg.toUserId,
        'text': msg.text,
        'created_at': msg.timestamp.toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> saveEventChat(String eventId, EventChatMessage msg) async {
    try {
      await _client.from('event_chat').insert({
        'id': msg.id,
        'event_id': eventId,
        'author': msg.author,
        'text': msg.text,
        'created_at': msg.timestamp.toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> saveEventRegistration(EventRegistration r) async {
    try {
      await _client.from('event_registrations').insert({
        'id': r.id,
        'event_id': r.eventId,
        'user_id': r.userId,
        'vehicle_name': r.vehicleName,
        'vehicle_brand': r.vehicleBrand,
        'vehicle_photo_url': r.vehiclePhotoUrl,
        'category': r.category,
        'origin': r.origin,
        'classification': r.classification,
        'sections': r.sections,
        'modifications': r.modifications,
      });
    } catch (_) {}
  }

  Future<void> toggleFollow({
    required String followerId,
    required String followedId,
    required bool following,
  }) async {
    try {
      if (following) {
        await _client.from('follows').upsert({
          'follower_id': followerId,
          'followed_id': followedId,
        });
      } else {
        await _client
            .from('follows')
            .delete()
            .eq('follower_id', followerId)
            .eq('followed_id', followedId);
      }
    } catch (_) {}
  }
}
