import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:high_performance_feed/models/post_models.dart';
import 'package:url_launcher/url_launcher.dart';



class DetailScreen extends StatefulWidget {
  final PostModel post;
  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}


class _DetailScreenState extends State<DetailScreen> {
  bool showMobileImage = false;
  
  @override
  void initState() {
    super.initState();
    
    Future.delayed( const Duration(milliseconds: 300), (){
      if(mounted) {
        setState(() {
          showMobileImage = true;
        });
      }
    });
  }

  Future<void> openHighResImage() async {
    final url = widget.post.mediaRawUrl;
    print(url);

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid URL")),
      );
      return;
    }

    final uri = Uri.parse(url);

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open high-res image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      appBar: AppBar(
        title: Text("Post Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
                tag: post.id,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                        imageUrl: post.mediaThumbUrl,
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.cover,
                      memCacheWidth: 700,
                    ),
                    AnimatedOpacity(
                        opacity: showMobileImage ? 1 : 0,
                        duration: Duration(milliseconds: 500),
                      child: CachedNetworkImage(
                          imageUrl: post.mediaMobileUrl,
                        width: double.infinity,
                        height: 350,
                        fit: BoxFit.cover,
                        memCacheWidth: 1080,
                        placeholder: (context, url) => SizedBox(),
                        errorWidget: (context, url, error) => 
                        Icon(Icons.broken_image),
                      ),
                    )
                  ],
                )
            ),
            Padding(
                padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Post ID: ${post.id}",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Likes: ${post.likeCount}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                     onPressed: openHighResImage,
                      child: Text("Download High-Res"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
