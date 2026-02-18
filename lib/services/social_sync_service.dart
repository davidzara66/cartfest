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

  Future<List<ChatMessage>> fetchDirectMessages(String currentUserId) async {
    try {
      final rows = await _client
          .from('direct_messages')
          .select('id,from_user_id,to_user_id,text,created_at')
          .or('from_user_id.eq.$currentUserId,to_user_id.eq.$currentUserId')
          .order('created_at');
      return (rows as List)
          .map((r) => ChatMessage(
                id: r['id'] as String,
                fromUserId: r['from_user_id'] as String,
                toUserId: r['to_user_id'] as String,
                text: (r['text'] ?? '') as String,
                timestamp: DateTime.tryParse((r['created_at'] ?? '') as String) ?? DateTime.now(),
              ))
          .toList();
    } catch (_) {
      return [];
    }
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

  Future<List<EventChatMessage>> fetchEventChat(String eventId) async {
    try {
      final rows = await _client
          .from('event_chat')
          .select('id,author,text,created_at')
          .eq('event_id', eventId)
          .order('created_at');
      return (rows as List)
          .map((r) => EventChatMessage(
                id: r['id'] as String,
                author: (r['author'] ?? '') as String,
                text: (r['text'] ?? '') as String,
                timestamp: DateTime.tryParse((r['created_at'] ?? '') as String) ?? DateTime.now(),
              ))
          .toList();
    } catch (_) {
      return [];
    }
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

  Future<void> upsertFeedPost(FeedPost post) async {
    try {
      await _client.from('feed_posts').upsert({
        'id': post.id,
        'author_id': post.authorId,
        'vehicle_id': post.vehicleId,
        'caption': post.caption,
        'likes': post.likes,
        'comments': post.comments,
        'created_at': post.createdAt.toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> saveStory(StoryItem story) async {
    try {
      await _client.from('story_items').upsert({
        'id': story.id,
        'user_id': story.userId,
        'image_url': story.imageUrl,
        'created_at': story.createdAt.toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> togglePostLike({
    required String userId,
    required String postId,
    required bool liked,
  }) async {
    try {
      if (liked) {
        await _client.from('post_likes').upsert({'user_id': userId, 'post_id': postId});
      } else {
        await _client.from('post_likes').delete().eq('user_id', userId).eq('post_id', postId);
      }
    } catch (_) {}
  }

  Future<void> togglePostSaved({
    required String userId,
    required String postId,
    required bool saved,
  }) async {
    try {
      if (saved) {
        await _client.from('saved_posts').upsert({'user_id': userId, 'post_id': postId});
      } else {
        await _client.from('saved_posts').delete().eq('user_id', userId).eq('post_id', postId);
      }
    } catch (_) {}
  }

  Future<void> addPostComment({
    required String postId,
    required String userId,
    required String text,
  }) async {
    try {
      await _client.from('post_comments').insert({
        'id': DateTime.now().microsecondsSinceEpoch.toString(),
        'post_id': postId,
        'user_id': userId,
        'text': text,
      });
    } catch (_) {}
  }

  Future<List<FeedPost>> fetchFeedPosts() async {
    try {
      final rows = await _client
          .from('feed_posts')
          .select('id,author_id,vehicle_id,caption,likes,comments,created_at')
          .order('created_at', ascending: false);
      return (rows as List)
          .map((r) => FeedPost(
                id: r['id'] as String,
                authorId: r['author_id'] as String,
                vehicleId: r['vehicle_id'] as String,
                caption: (r['caption'] ?? '') as String,
                likes: (r['likes'] ?? 0) as int,
                comments: (r['comments'] ?? 0) as int,
                createdAt: DateTime.tryParse((r['created_at'] ?? '') as String) ?? DateTime.now(),
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<Set<String>> fetchPostLikes(String userId) async {
    try {
      final rows = await _client.from('post_likes').select('post_id').eq('user_id', userId);
      return (rows as List).map((e) => e['post_id'] as String).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<Set<String>> fetchSavedPosts(String userId) async {
    try {
      final rows = await _client.from('saved_posts').select('post_id').eq('user_id', userId);
      return (rows as List).map((e) => e['post_id'] as String).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<Map<String, List<String>>> fetchCommentsMap() async {
    try {
      final rows = await _client.from('post_comments').select('post_id,text').order('created_at');
      final map = <String, List<String>>{};
      for (final item in (rows as List)) {
        final id = item['post_id'] as String;
        final txt = (item['text'] ?? '') as String;
        map.putIfAbsent(id, () => []).add(txt);
      }
      return map;
    } catch (_) {
      return {};
    }
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
