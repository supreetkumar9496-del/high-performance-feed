

import 'package:high_performance_feed/core/supabase_config.dart';
import 'package:high_performance_feed/models/post_models.dart';

class FeedService {
  Future<List<PostModel>> fetchPosts(int from, int to) async {
    final response = await supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false)
        .range(from, to);

    return (response as List)
        .map((e)  => PostModel.fromMap(e))
        .toList();
  }

  Future<void> toggleLike({
    required String postId,
    required String userId,
}) async {
    await supabase.rpc(
      "toggle_like",
      params: {
        'p_post_id': postId,
        'p_user_id': userId,
      }
    );
  }
}