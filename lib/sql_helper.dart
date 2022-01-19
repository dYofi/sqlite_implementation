import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE kelas (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nama_kelas TEXT,
      tahun_ajaran TEXT,
      jumlah_siswa INTEGER,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'asgur_sqlite.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new kelas
  static Future<int> createClass(
      String nama_kelas, String tahun_ajaran, int jumlah_siswa) async {
    final db = await SQLHelper.db();

    final data = {
      'nama_kelas': nama_kelas,
      'tahun_ajaran': tahun_ajaran,
      'jumlah_siswa': jumlah_siswa
    };
    final id = await db.insert('kelas', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all kelas
  static Future<List<Map<String, dynamic>>> getClasses() async {
    final db = await SQLHelper.db();
    return db.query('kelas', orderBy: 'id');
  }

  // Update a kelas by id
  static Future<int> updateClass(
      int id, String nama_kelas, String tahun_ajaran, int jumlah_siswa) async {
    final db = await SQLHelper.db();

    final data = {
      'nama_kelas': nama_kelas,
      'tahun_ajaran': tahun_ajaran,
      'jumlah_siswa': jumlah_siswa,
      'created_at': DateTime.now().toString()
    };
    final result =
        await db.update('kelas', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteClass(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('kelas', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('Terjadi kesalahan saat menghapus kelas: $err');
    }
  }
}
