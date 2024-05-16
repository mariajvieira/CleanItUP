import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../JsonModels/post.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> images = [];


  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Unique filename
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');

      await storageReference.putFile(image);

      String imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<bool> submitPost(String text, List<File> images) async {
    if (images.isEmpty) return false; // Make sure there's at least one image

    String imageUrl = '';
    if (images.isNotEmpty) {
      imageUrl = await _uploadImage(images.first);
    }
    await Post.addPostToDatabase(text, '', imageUrl);
    return true;
  }

  void submitPostHandler() async {
    if (_postTextController.text.isEmpty || images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please add some text and images."))
      );
      return;
    }

    bool success = await submitPost(_postTextController.text, images);
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Post submitted successfully!"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit post."))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: submitPostHandler
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _postTextController,
            decoration: InputDecoration(labelText: 'Post Text'),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Image.file(images[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImageSourceActionSheet,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      _pickImageFromGallery();
                      Navigator.pop(context);
                    }
                ),
                ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _takePicture();
                      Navigator.pop(context);
                    }
                )
              ]
          );
        }
    );
  }
}
