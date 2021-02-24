import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;


class DBUtil {
  static Future<sql.Database> database ()async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'characters.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE IF NOT EXIST characters (url TEXT PRIMARY KEY, name TEXT, height TEXT, mass TEXT, hair_color TEXT, skin_color TEXT, eye_color TEXT, birthYear TEXT, gender TEXT, Homeworld TEXT, planetName TEXT, specieName TEXT, isFav BOOLEAN)');
      },
      version: 1,
    );
  }
  
  static Future<void> insert (String table, Map<String, dynamic> dados) async {
    final db = await DBUtil.database();
    await db.execute('CREATE TABLE IF NOT EXISTS fav_requests (url TEXT PRIMARY KEY, name TEXT)');
    await db.insert(table, dados, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future <List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBUtil.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getFavorites(String table) async {
    final db = await DBUtil.database();
    print('getFavorites');
    return db.rawQuery("SELECT * FROM $table WHERE isFav = 1");    
  }

  static Future<int> delete(String table, String where, List args) async {
    final db = await DBUtil.database();
    print('delete');
    return db.delete(table, where: '$where = ?', whereArgs: args);    
  }

  static Future dropTable(String table) async{
    final db = await DBUtil.database();
    await db.execute("DROP TABLE IF EXISTS $table");
  }

  static Future deleteAllFromTable(String table) async{
    final db = await DBUtil.database();
    await db.execute("DELETE FROM $table");
  }

  static Future favoriteUpdate(String table, String url, bool isFav) async {
    print('favoriteUpdate');
    int newFav = isFav ? 1 : 0;
    final db = await DBUtil.database();
    await db.execute("UPDATE $table SET isFav =  ? WHERE url = ?", [newFav, url]);
  }

  static Future<bool> isFavDB(String table, String url) async {
    print('isFavDB');
    final db = await DBUtil.database();
    List<Map<String, dynamic>> map = await db.rawQuery("SELECT isFav FROM $table WHERE url = ? ", [url]);
    if (map.isNotEmpty) // Treatment in case of empty result
    if (map[0]['isFav'] == 1)
      return true;
    return false;
  }

  static Future<List<Map<String, dynamic>>> executeSQL(String sql) async{
    final db = await DBUtil.database();
    return db.rawQuery(sql);
  }
}