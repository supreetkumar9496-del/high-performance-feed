import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:high_performance_feed/features/feed/data/feed_service.dart';

final feedServiceProvider = Provider<FeedService>((ref){
  return FeedService();
});