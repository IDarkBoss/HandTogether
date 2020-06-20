import 'package:handtogether/database/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  final String tableName = "HandUpDown";
  final String columnId = "id";
  final String columnType = "type";
  final String columnTime = "time";
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sqflite.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //创建数据库表
  void _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName($columnId integer primary key,$columnType text not null,$columnTime text not null)");
    print("Table is created");
  }

  //插入
  Future<int> saveItem(type, time) async {
    HandUpDown handUpDown = HandUpDown();
    handUpDown.type = type;
    handUpDown.time = time;

    var dbClient = await db;
    int res = await dbClient.insert("$tableName", handUpDown.toMap());
    print(res.toString());
    return res;
  }

  //查询
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName");
    return result.toList();
  }

  //查询总数
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

//按照id查询
  Future<HandUpDown> getItem(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return HandUpDown.fromMap(result.first);
  }

  //清空数据
  Future<int> clear() async {
    var dbClient = await db;
    return await dbClient.delete(tableName);
  }

  //根据id删除
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  //修改
  Future<int> updateItem(HandUpDown handUpDown) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", handUpDown.toMap(),
        where: "$columnId = ?", whereArgs: [handUpDown.id]);
  }

  //关闭
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
