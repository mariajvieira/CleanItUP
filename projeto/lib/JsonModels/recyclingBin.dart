import 'package:cloud_firestore/cloud_firestore.dart';


/*
ECOPONTOS TYPE:
-amarelo: plastico --> P
-verde: vidro  ----> G (glass)
-azul: papel/cartao ---> PC (paper, card)
-vermelho: pilhas ---> B (batteries)
-rosa: METER ECOPONTOS DE ROUPA ---> C (clothes)

STATES:
-ok: 0 false
-full: 1 true
 */


class RecyclingBin {
  String id;
  double latitude;
  double longitude;
  String type;
  bool state;
  String description;

  RecyclingBin({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.state,
    required this.description,
  });

  factory RecyclingBin.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RecyclingBin(
      id: doc.id,
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      type: data['type'] ?? '',
      state: data['state'] ?? false,
      description: data['description'] ?? '',
    );
  }

  static Future<void> addRecyclingBinToDatabase(
      double latitude, double longitude, String type, bool state, String description) async {
    try {
      await FirebaseFirestore.instance.collection('RecyclingBins').add({
        'latitude': latitude,
        'longitude': longitude,
        'type': type,
        'state': state,
        'description': description
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





