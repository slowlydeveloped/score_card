import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = 'score.db';
  String team1Table = "team1";
  String team2Table = "team2";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $team1Table (id INTEGER PRIMARY KEY, player_name TEXT NOT NULL, runs INT, wickets INT)");
      await db.execute(
          "CREATE TABLE $team2Table (id INTEGER PRIMARY KEY, player_name TEXT NOT NULL, runs INT, wickets INT)");
    });
  }

  Future<void> insertPlayers(List<String> players, String tableName) async {
    final Database db = await initDB();
    for (String player in players) {
      await db
          .insert(tableName, {'player_name': player, 'runs': 0, 'wickets': 0});
    }
  }
  Future<List<String>> getFirstNPlayers(String tableName) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      columns: ['player_name'],
      // limit: n,
    );
    return List.generate(maps.length, (i) {
      return maps[i]['player_name'];
    });
  }

  Future<String> getFirstPlayer(String tableName) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      columns: ['player_name'],
      limit: 1,
    );
    return maps.isNotEmpty ? maps[0]['player_name'] : '';
  }
}
