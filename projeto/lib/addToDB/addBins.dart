import 'package:projeto/SQLite/sqlite.dart';
import 'package:projeto/JsonModels/recyclingBin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late UsersDatabaseHelper dbHelper;
  setUp(() {
    dbHelper = UsersDatabaseHelper();
  });

  test('Insert Recycling Bins', () async {
    List<RecyclingBin> bins =[];
    //bins in feup
    bins.add(RecyclingBin(bin_id:1, bin_latitude: 123.456, bin_longitude: 789.012, clean: 1, full: 0,));

    for(int i=0;i<bins.length;i++){
      //add bins to data base
    }
  });
}
