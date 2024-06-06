// ignore_for_file: prefer_conditional_assignment

import 'package:mysql1/mysql1.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  MySqlConnection? _connection;

  Future<MySqlConnection> get connection async {
    if (_connection == null) {
      _connection = await _openConnection();
    }
    return _connection!;
  }

  Future<MySqlConnection> _openConnection() async {
    var settings = ConnectionSettings(
      host: 'sql3.freesqldatabase.com',
      port: 3306,
      user: 'sql3706460',
      password: 'g7tpRKWyQX',
      db: 'sql3706460',
    );
    return await MySqlConnection.connect(settings);
  }

  Future<void> closeConnection() async {
    await _connection?.close();
  }


  Future<Results> getSeanceById(String seanceId) async {
    var conn = await connection;
    var results = await conn.query('''
      SELECT * FROM Seances s
      JOIN Modules m ON s.moduleID = m.moduleID
      JOIN Profs p ON m.responsibleProf = p.profID
      WHERE s.seanceID = ?
    ''', [seanceId]);
    return results;
  }


  Future<bool> authenticatedProf({String? email, String? password}) async {
    if (email == null || email.isEmpty || password == null || password.isEmpty) {
      return false;
    }
    var conn = await connection;
    var results = await conn.query(
      'SELECT profID FROM Profs WHERE email = ? AND password = ?',
      [email, password],
    );
    return results.isNotEmpty;
  }


  Future<Results> getStudentByCardID({String? studentID}) async {
    var conn = await connection;
    var results = await conn.query(
      'SELECT * FROM Students WHERE studentID = ? ',
      [studentID,],
    );
    return results ; 
  }


  Future<Results> getStudent({String? email, String? rfid}) async {
    var conn = await connection;
    var whereClause = '';
    var values = [];

    if (email != null) {
      whereClause = 'email = ?';
      values.add(email);
    }

    if (rfid != null) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'rfid = ?';
      values.add(rfid);
    }

    var query = 'SELECT * FROM Students WHERE $whereClause';
    var results = await conn.query(query, values);
    return results;
  }

  Future<bool> markStudentPresence(String seanceID, String studentID, String surveillantID) async {
    var conn = await connection;
    bool succ = false ;
    await conn.query(
      'INSERT INTO Presence (seanceID, studentID, surveillantID) VALUES (?, ?, ?)',
      [seanceID, studentID, surveillantID]
    );
    succ = true ; 
    return succ ;
  }

  Future<bool> checkStudentPresence(String seanceID, String studentID) async {
  var conn = await connection;
  var results = await conn.query(
    'SELECT * FROM Presence WHERE seanceID = ? AND studentID = ?',
    [seanceID, studentID],
  );
  return results.isNotEmpty;
  }

}
