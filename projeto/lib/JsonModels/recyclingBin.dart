class RecyclingBin {
  int bin_id;
  double bin_latitude;
  double bin_longitude;
  int clean;
  int full;

  RecyclingBin({
    required this.bin_id,
    required this.bin_latitude,
    required this.bin_longitude,
    required this.clean,
    required this.full,
  });

  Map<String, dynamic> toMap() {
    return {
      'bin_id': bin_id,
      'bin_latitude': bin_latitude,
      'bin_longitude': bin_longitude,
      'clean': clean,
      'full': full,
    };
  }

  factory RecyclingBin.fromMap(Map<String, dynamic> map) {
    return RecyclingBin(
      bin_id: map['bin_id'],
      bin_latitude: map['bin_latitude'],
      bin_longitude: map['bin_longitude'],
      clean: map['clean'],
      full: map['full'],
    );
  }
}
