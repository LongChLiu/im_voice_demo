import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';



class VoiceModel{

  late String id;
  late String path;

  //构造方法
  VoiceModel({required this.id, required this.path});

  //用于将JSON字典转换成类对象的工厂类方法
  factory VoiceModel.fromJson(Map<String, dynamic> parsedJson) {
    return VoiceModel(
      id: parsedJson['id'],
      path: parsedJson['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
    };
  }

}



class DB{

  query_database(id) {
    Future<VoiceModel?> voice = query_by_id(id);
    voice.then((t) {
      print("单用户条语音路径成功");
      if(t != null){
        print('the voice is : ' + t.path.toString());
      }else{
        print('没有查询到，the voice is null');
      }
    });
  }

  //插入数据
  Future<void> insertVoice(VoiceModel std) async {
    final Database db = await database;
    await db.insert(
      'voices',
      std.toJson(),
      //插入冲突策略，新的替换旧的
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<VoiceModel?> query_by_id(String id) async {
    final Database db = await database;

    List<Map> maps = await db.query('voices',
        columns: ['id', 'path'], where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      print("根据id查到了数据");
      return VoiceModel.fromJson(maps.first as Map<String, dynamic>);
    }

    print("根据id没有查到数据");
    return null;
  }

  //初始化数据库方法
  static initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "/voice_database.db";
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE voices(id TEXT PRIMARY KEY, path TEXT)
            ''');
        });
  }

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      print(_database);
      return _database!;
    }

    _database = await initDB();
    print("创建新数据库");
    return _database!;
  }

  Future<List<VoiceModel>> getVoices() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('voices');
    return List.generate(maps.length, (i) => VoiceModel.fromJson(maps[i]));
  }

}