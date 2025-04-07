import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDbHelper {
  final supabase = Supabase.instance.client;

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<Map<String, dynamic>> insert(
      String table, Map<String, dynamic> row) async {
    return await supabase.from(table).insert(row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    return await supabase.from(table).select();
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    try {
      final response =
          await supabase.from(table).select('*').count(CountOption.exact);
      return response.count;
    } catch (e) {
      debugPrint("Error querying row count: $e");
      return 0;
    }
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<List<Map<String, dynamic>>> update(
      String table, int id, Map<String, dynamic> row) async {
    return await supabase.from(table).update(row).eq('id', id).select();
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, int id) async {
    return await supabase.from(table).delete().eq('id', 1);
  }
}
