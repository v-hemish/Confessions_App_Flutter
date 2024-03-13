import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:anonymoose_confessions_app/components/wall_post.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int _currentIndex = 1; // Start with the center icon selected


  TextEditingController searchController = TextEditingController(); // Controller for search bar
  late Stream<QuerySnapshot> _postsStream; // Stream to hold the posts data

  @override
  void initState() {
    super.initState();
    // Initialize the stream with all posts ordered by timestamp
    _postsStream = FirebaseFirestore.instance.collection("User Posts").orderBy("TimeStamp", descending: true).snapshots();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void showConfessionDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController confessionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add a confession?..',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "What's the title?",
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: confessionController,
                  maxLines: null, // Allow the box to expand
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Enter your confession....",
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Submit', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              onPressed: () {

                if (titleController.text.isNotEmpty && confessionController.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection("User Posts").add({
                    'Title': titleController.text,
                    'Message': confessionController.text,
                    'UserEmail': currentUser.email,
                    'TimeStamp': Timestamp.now(),
                    'likes': [],
                    'dislikes': [],
                  }).then((value) => Navigator.of(context).pop());
                }
              },
            ),
          ],
        );
      },
    );
  }

  void confirmDeletePost(String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scared?..'),
          content: const Text('Are you sure you want to delete this confession?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary), // Set text color to primary color
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary), // Set text color to primary color
              ),
              onPressed: () {
                FirebaseFirestore.instance.collection("User Posts").doc(postId).delete().then((_) => Navigator.of(context).pop());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'THE WHISPER WALL',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.inversePrimary),
              onPressed: () {

              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                // Search bar
                controller: searchController,

                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search by title or description',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _postsStream, // Use the updated stream
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        bool canDelete = currentUser.email == post['UserEmail'];
                        return WallPost(
                          title: post['Title'],
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          onDelete: canDelete ? () => confirmDeletePost(post.id) : null,
                          canDelete: canDelete,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: <Widget>[
          Icon(Icons.logout, size: 30, color: Theme.of(context).colorScheme.primary),
          Icon(Icons.add, size: 30, color: Theme.of(context).colorScheme.primary),
          Icon(Icons.settings, size: 30, color: Theme.of(context).colorScheme.primary),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              logout();
            } else if (_currentIndex == 1) {
              showConfessionDialog();
            } // Optionally, add handling for the settings icon if needed
          });
        },
      ),
    );
  }
}
