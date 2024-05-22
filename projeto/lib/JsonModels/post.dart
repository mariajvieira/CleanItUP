import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String title;
  String description;
  List<String> likes;
  List<Map<String, String>> comments;
  DateTime date;
  String imageUrl;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.likes,
    required this.comments,
    required this.date,
    required this.imageUrl,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      likes: List<String>.from(data['likes']),
      comments: List<Map<String, String>>.from(data['comments']),
      date: (data['date'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
    );
  }

  static Future<void> addPostToDatabase(
      String title, String description, String userId, String imageUrl) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection('Posts').add({
        'title': title,
        'description': description,
        'userId': userId,
        'likes': [],
        'comments': [],
        'date': Timestamp.fromDate(DateTime.now()),
        'imageUrl': imageUrl,
      });

      // Atualizar contagem de posts
      var userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        var snapshot = await transaction.get(userDoc);
        if (snapshot.exists) {
          var newPostCount = (snapshot.data()?['postCount'] ?? 0) + 1;
          transaction.update(userDoc, {'postCount': newPostCount});
        }
      });

      print('New post added with ID: ${docRef.id}');
    } catch (e) {
      print("Failed to add post: $e");
    }
  }

  static Future<List<Post>> getPostsFromDatabase() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Posts').get();
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    } catch (e) {
      print("Failed to fetch posts: $e");
      return [];
    }
  }

  static Future<void> likePost(String postId, String userId) async {
    try {
      DocumentReference postRef =
      FirebaseFirestore.instance.collection('Posts').doc(postId);
      await postRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print("Failed to like post: $e");
    }
  }

  static Future<void> addComment(String postId, String userId, String comment) async {
    try {
      DocumentReference postRef =
      FirebaseFirestore.instance.collection('Posts').doc(postId);
      await postRef.update({
        'comments': FieldValue.arrayUnion([
          {'userId': userId, 'comment': comment}
        ]),
      });
    } catch (e) {
      print("Failed to add comment: $e");
    }
  }
}
