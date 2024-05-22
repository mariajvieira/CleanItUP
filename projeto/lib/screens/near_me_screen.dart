import 'package:flutter/material.dart';
import '../JsonModels/users.dart';


class NearMeScreen extends StatefulWidget {
  final Users user;
  const NearMeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _NearMeScreenState createState() => _NearMeScreenState();
}

class _NearMeScreenState extends State<NearMeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

}
