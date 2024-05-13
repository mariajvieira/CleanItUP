import 'package:projeto/SQLite/sqlite.dart';
import 'package:projeto/JsonModels/recyclingBin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void add_Bins(dbHelper) {
    List<RecyclingBin> bins =[];
    //bins in feup
    bins.add(RecyclingBin(bin_id:1, bin_latitude: 41.1774101, bin_longitude: -8.5957178, clean: 0, full: 0,));
    bins.add(RecyclingBin(bin_id:2, bin_latitude: 41.1777103, bin_longitude: -8.5964536, clean: 0, full: 0,));
    bins.add(RecyclingBin(bin_id:3, bin_latitude: 41.1777615, bin_longitude: -8.5968776, clean: 0, full: 0,));
    bins.add(RecyclingBin(bin_id:4, bin_latitude: 41.1775628, bin_longitude: -8.5957688, clean: 0, full: 0,));


    for(int i=0;i<bins.length;i++){
      dbHelper.initDB();
      dbHelper.insertRecyclingBin(bins[i]);    }
}
