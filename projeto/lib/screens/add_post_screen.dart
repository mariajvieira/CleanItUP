import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';  // Used for File type
import 'package:geolocator/geolocator.dart';

import '../SQLite/sqlite.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> images = [];
  double? latitude;
  double? longitude;

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

  Future<void> _addCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location services are disabled."))
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Location permissions are denied."))
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permissions are permanently denied."))
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
  }


  Future<bool> submitPost(String text, List<File> images, double? lat, double? lon) async {
    if (images.isEmpty) return false; // Make sure there's at least one image

    UsersDatabaseHelper db = UsersDatabaseHelper();
    int userId = 1; // Assuming you have a way to get the user's ID
    String imagePath = images.first.path; // Using only the first image for simplicity

    int postId = await db.addPost(userId, text, lat, lon, imagePath: imagePath);
    return postId > 0; // Check if the post was added successfully
  }

  void submitPostHandler() async {
    if (_postTextController.text.isEmpty || images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please add some text and images."))
      );
      return;
    }

    bool success = await submitPost(_postTextController.text, images, latitude, longitude);
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
          ElevatedButton(
              onPressed: _addCurrentLocation,
              child: Text('Add Location')
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
