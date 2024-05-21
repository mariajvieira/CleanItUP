import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../JsonModels/users.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({Key? key}) : super(key: key);

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Users> _searchResults = [];
  bool _isSearching = false;

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      var usersCollection = FirebaseFirestore.instance.collection('users');
      var emailQuery = usersCollection
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      var emailResults = await emailQuery;

      setState(() {
        _searchResults = emailResults.docs
            .map((doc) => Users.fromFirestore(doc))
            .toList();
        _isSearching = false;
      });
    } catch (e) {
      print("Error searching users by email: $e");
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _searchUsers(_searchController.text),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchUsers('');
                  },
                ),
              ),
              onChanged: (value) => _searchUsers(value),
            ),
          ),
          Expanded(
            child: _isSearching
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                var user = _searchResults[index];
                return ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
