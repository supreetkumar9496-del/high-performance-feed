import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:high_performance_feed/features/detail/screens/detail_screen.dart';
import 'package:high_performance_feed/features/feed/providers/feed_service_provider.dart';

import '../../../models/post_models.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  List<PostModel> posts = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 0;

  final String userId = "user_123";

  @override
  void initState() {
    super.initState();
    fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        fetchPosts();
      }
    });
  }

  Future<void> fetchPosts() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    final newPosts = await ref
        .read(feedServiceProvider)
        .fetchPosts(currentPage * 10, currentPage * 10 + 9);

    setState(() {
      if (newPosts.isEmpty) {
        hasMore = false;
      } else {
        posts.addAll(newPosts);
        currentPage++;
      }
      isLoading = false;
    });
  }

  Future<void> refreshPosts() async {
    setState(() {
      posts.clear();
      currentPage = 0;
      hasMore = true;
    });

    await fetchPosts();
  }

  Future<void> onLikeTap(int index) async {
    final oldPost = posts[index];
    final newLikedState = !oldPost.isLiked;
    final newLikeCount =
    newLikedState ? oldPost.likeCount + 1 : oldPost.likeCount - 1;

    setState(() {
      posts[index] = oldPost.copyWith(
        isLiked: newLikedState,
        likeCount: newLikeCount,
      );
    });

    try {
      await ref.read(feedServiceProvider).toggleLike(
        postId: oldPost.id,
        userId: userId,
      );
    } catch (e) {
      setState(() {
        posts[index] = oldPost;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update like. Reverted"),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty && isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Feed")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (posts.isEmpty && !isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Feed")),
        body: const Center(child: Text("No posts found")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      body: RefreshIndicator(
        onRefresh: refreshPosts,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          itemCount: posts.length + 1,
          itemBuilder: (context, index) {
            if (index == posts.length) {
              if (hasMore) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      "No more posts",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
            }

            final post = posts[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),



              child: RepaintBoundary(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 28,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(post: post),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: post.mediaThumbUrl,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            memCacheWidth: 700,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Post ${index + 1}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),


                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => onLikeTap(index),
                                  icon: Icon(
                                    post.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: post.isLiked
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                                Text("${post.likeCount}"),
                              ],
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                        child: Text(
                          "Post ID: ${post.id.substring(0, 8)}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


/* import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:high_performance_feed/features/feed/providers/feed_service_provider.dart';
import 'package:high_performance_feed/models/post_models.dart';


class FeedScreen extends ConsumerWidget{
  const FeedScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      body: FutureBuilder<List<PostModel>>(
          future: ref.read(feedServiceProvider).fetchPosts(0, 9),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }

            if(snapshot.hasError){
              return Center(child: Text("Error: ${snapshot.error}"),);
            }

            final posts = snapshot.data ?? [];

            if(posts.isEmpty){
              return const Center(child: Text("No posts found"));
            }

            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: posts.length,
                itemBuilder: (context, index){
                final post = posts[index];

                return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                  child: RepaintBoundary(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 28,
                            offset: Offset(0, 12)
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),

                            ),
                            child: CachedNetworkImage(
                                imageUrl: post.mediaThumbUrl,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              memCacheWidth: 700,
                              placeholder: (context, url) => Container(
                                height: 220,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),

                              errorWidget: (context, url, error) => Container(
                                height: 220,
                                alignment: Alignment.center,
                                child: Icon(Icons.broken_image, size: 40),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Post ${index + 1}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.favorite_border),
                                    SizedBox(width: 6,),
                                    Text("${post.likeCount}"),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
                            child: Text(
                              "Post ID: ${post.id.substring(0,8)}",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
                }
            );
          }
      ),
    );
  }
}

 */