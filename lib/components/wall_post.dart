import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class WallPost extends StatefulWidget {
  final String title;
  final String message;
  final String user;
  final String postId;
  final VoidCallback? onDelete;
  final bool canDelete;

  const WallPost({
    Key? key,
    required this.title,
    required this.message,
    required this.user,
    required this.postId,
    this.onDelete,
    this.canDelete = false,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  List<dynamic> likes = [];
  List<dynamic> dislikes = [];
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String timeAgo = '';

  @override
  void initState() {
    super.initState();
    fetchPostData();
  }

  void fetchPostData() async {
    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .get();
    Timestamp createdAt = postSnapshot['TimeStamp'];
    setState(() {
      likes = postSnapshot['likes'] ?? [];
      dislikes = postSnapshot['dislikes'] ?? [];
      timeAgo = createdAt != null
          ? timeago.format(createdAt.toDate(), locale: 'en_short')
          : ''; // Converting the timestamp to DateTime and formatting it
    });
  }

  void handleLike() async {
    if (!likes.contains(currentUserId)) {
      await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .update({
        'likes': FieldValue.arrayUnion([currentUserId]),
        'dislikes': FieldValue.arrayRemove([currentUserId]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .update({
        'likes': FieldValue.arrayRemove([currentUserId]),
      });
    }
    fetchPostData();
  }

  void handleDislike() async {
    if (!dislikes.contains(currentUserId)) {
      await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .update({
        'dislikes': FieldValue.arrayUnion([currentUserId]),
        'likes': FieldValue.arrayRemove([currentUserId]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .update({
        'dislikes': FieldValue.arrayRemove([currentUserId]),
      });
    }
    fetchPostData();
  }

  @override
  Widget build(BuildContext context) {
    bool didLike = likes.contains(currentUserId);
    bool didDislike = dislikes.contains(currentUserId);

    return Container(
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Set the font size of the title to 14
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Posted $timeAgo ago',
                      style: const TextStyle(
                        fontSize: 10, // Set the font size of the posted time ago text to 8
                        color: Colors.grey, // Set the color of the text to grey
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.canDelete)
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: widget.onDelete,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.message, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                        didLike ? Icons.thumb_up : Icons.thumb_up_outlined),
                    onPressed: handleLike,
                    color: didLike ? Colors.blue : null,
                  ),
                  Text('${likes.length}'),
                  IconButton(
                    icon: Icon(didDislike
                        ? Icons.thumb_down
                        : Icons.thumb_down_outlined),
                    onPressed: handleDislike,
                    color: didDislike ? Colors.red : null,
                  ),
                  Text('${dislikes.length}'),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => Share.share(
                    'Check out this post: "${widget.title}" - ${widget.message}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
