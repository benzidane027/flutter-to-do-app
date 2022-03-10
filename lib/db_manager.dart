import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class db_helpeer {
  static final db_helpeer instanc = db_helpeer.init();
  factory db_helpeer() => instanc;
  db_helpeer.init();

  var _db;

  Future<Database> _createDatebase() async {
    if (_db != null) return _db;
    String path = join(await getDatabasesPath() + "task.db");
    _db = await openDatabase(path, version: 1, onCreate: (Database db, int x) {
      db.execute(
          "create table user_task(id integer primary key autoincrement, object varchar(35),mydate varchar(40),content varchar(205))");
    });
    return _db;
  }

  Future<int> add_task({object = "", content = "", date = ""}) async {
    Database db = await _createDatebase();

    return db.rawInsert(
        "insert into user_task(object,content,mydate)values('$object','$content','$date')");
  }

  Future<List> get_tasks() async {
    Database db = await _createDatebase();
    return db.rawQuery("select * from user_task");
  }

  Future<List> get_task({id}) async {
    Database db = await _createDatebase();
    return db.rawQuery("select * from user_task where id=$id");
  }

  Future<int> delete_task({id}) async {
    print(id);
    Database db = await _createDatebase();
    return db.delete("user_task", where: "id = ?", whereArgs: [id]);
  }

  Future<int> modify_task({id, object, content}) async {
    print("good");
    Database db = await _createDatebase();
    return db.update("user_task", {"object": object, "content": content},
        where: "id = ? ", whereArgs: [id]);
  }
}
