import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBConnector extends ChangeNotifier {
  Database database;
  List<Map> teams;

  Future<void> connect() async {
    var databasesPath = await getDatabasesPath();
    String loc = join(databasesPath, 'demo.db');
    // await deleteDatabase(loc);
    // open the database
    database = await openDatabase(loc, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Teams (id STRING PRIMARY KEY, name TEXT, fgColor TEXT, bgColor TEXT)');
    });
    //presetAdd();
    getTeams();
  }

  List<Map> get list {
    return teams;
  }

  int get teamCount {
    return teams.length;
  }

  void presetAdd() async {
    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Teams(id, name, fgColor, bgColor) VALUES("stee000000ffffff", "Steelers", "000000", "ffffff")');
      await txn.rawInsert(
          'INSERT INTO Teams(id, name, fgColor, bgColor) VALUES("marl009688f36c26", "Marlins", "009688", "f36c26")');
    });
  }

  void addPreset(String team, String fg, String bg) async {
    String newid = team.toLowerCase().substring(0, 4) + fg + bg;
    Map<String, String> newTeam = {
      "id": newid,
      "name": team,
      "fgColor": fg,
      "bgColor": bg
    };
    await database.insert('Teams', newTeam,
        conflictAlgorithm: ConflictAlgorithm.replace);
    teams = [...teams, newTeam];
    //print(teams);
    notifyListeners();
  }

  void updatePreset(String oldid, String newfg, String newbg) async {
    String newid = oldid.substring(0, 4) + newfg + newbg;
    await database.rawUpdate(
        'UPDATE Teams SET id = ?, fgColor = ?, bgColor = ? WHERE id = ?',
        [newid, newfg, newbg, oldid]);
    teams = await database.rawQuery('SELECT * FROM Teams');
    notifyListeners();
  }

  Future getTeams() async {
    teams = await database.rawQuery('SELECT * FROM Teams');
  }

  bool hasPreset(String id) {
    for (int i = 0; i < teams.length; i++)
      if (teams[i]['id'] == id) return true;
    return false;
  }

  bool hasTeam(String team) {
    for (int i = 0; i < teams.length; i++)
      if (teams[i]['name'] == team) return true;
    return false;
  }

  void removePreset(String delID) async {
    await database.rawDelete('DELETE FROM Teams WHERE id = ?', [delID]);
    teams = await database.rawQuery('SELECT * FROM Teams');
    notifyListeners();
  }

  /*
  Future getCount() async{
    count =  Sqflite
        .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Teams'));
  }
*/

}
