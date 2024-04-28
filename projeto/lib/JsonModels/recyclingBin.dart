class RecyclingBin {
  int? bin_id;
  double bin_latitude;
  double bin_longitude;
  int clean;
  int full;

  RecyclingBin({
    this.bin_id,
    required this.bin_latitude,
    required this.bin_longitude,
    required this.clean,
    required this.full,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': bin_id,
      'latitude': bin_latitude,
      'longitude': bin_longitude,
      'clean': clean,
      'full': full,
    };
  }

  factory RecyclingBin.fromMap(Map<String, dynamic> map) {
    return RecyclingBin(
      bin_id: map['id'],
      bin_latitude: map['latitude'],
      bin_longitude: map['longitude'],
      clean: map['clean'],
      full: map['full'],
    );
  }
}
