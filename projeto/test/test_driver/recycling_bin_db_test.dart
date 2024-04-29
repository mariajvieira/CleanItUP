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

  test('Teste de inserção e recuperação de RecyclingBin', () async {
    // Cria um objeto RecyclingBin para inserir no banco de dados
    RecyclingBin bin = RecyclingBin(
      bin_id: 1,
      bin_latitude: 123.456, // Defina a latitude conforme necessário
      bin_longitude: 789.012, // Defina a longitude conforme necessário
      clean: 1, // 1 para limpo, 0 para sujo
      full: 0, // 0 para vazio, 1 para cheio
    );

    // Insere o RecyclingBin no banco de dados
    await dbHelper.initDB();
    await dbHelper.insertRecyclingBin(bin);

    // Recupera todos os RecyclingBins do banco de dados
    List<RecyclingBin> bins = await dbHelper.getAllRecyclingBins();

    // Verifica se a lista de RecyclingBins não está vazia
    expect(bins.isNotEmpty, true);

    // Verifica se o primeiro RecyclingBin na lista tem os valores esperados
    expect(bins.first.bin_latitude, 123.456);
    expect(bins.first.bin_longitude, 789.012);
    expect(bins.first.clean, 1);
    expect(bins.first.full, 0);
  });

  tearDown(() async {
    // Limpa o banco de dados após cada teste
    final db = await dbHelper.initDB();
    await db.delete('recycling_bins');
  });
}