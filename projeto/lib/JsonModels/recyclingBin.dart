import 'package:cloud_firestore/cloud_firestore.dart';

class RecyclingBin {
  String id;
  double latitude;
  double longitude;
  String type;
  String state;

  RecyclingBin({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.state,
  });

  factory RecyclingBin.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RecyclingBin(
      id: doc.id,
      latitude: data['latitude'],
      longitude: data['longitude'],
      type: data['type'],
      state: data['state'],
    );
  }

  static Future<void> addRecyclingBinToDatabase(
      double latitude, double longitude, String type, String state) async {
    try {
      await FirebaseFirestore.instance.collection('RecyclingBins').add({
        'latitude': latitude,
        'longitude': longitude,
        'type': type,
        'state': state,
      });
    } catch (e) {
      print("Failed to add recycling bin: $e");
    }
  }

  static Future<List<RecyclingBin>> getRecyclingBinsFromDatabase() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('RecyclingBins').get();
      return snapshot.docs.map((doc) => RecyclingBin.fromFirestore(doc)).toList();
    } catch (e) {
      print("Failed to fetch recycling bins: $e");
      return [];
    }
  }
}
