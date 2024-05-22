/*import 'package:projeto/SQLite/sqlite.dart';
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

  test('Test to insert Recycling Bins', () async {
    RecyclingBin bin = RecyclingBin(
      bin_id:1,
      bin_latitude: 123.456,
      bin_longitude: 789.012,
      clean: 1,
      full: 0,
    );

    await dbHelper.initDB();
    await dbHelper.insertRecyclingBin(bin);

    List<RecyclingBin> bins = await dbHelper.getAllRecyclingBins();

    expect(bins.isNotEmpty, true);
    expect(bins.first.bin_id, 1);
    expect(bins.first.bin_latitude, 123.456);
    expect(bins.first.bin_longitude, 789.012);
    expect(bins.first.clean, 1);
    expect(bins.first.full, 0);
  });

  tearDown(() async {
    final db = await dbHelper.initDB();
    await db.delete('recycling_bins');
  });
}

 */
