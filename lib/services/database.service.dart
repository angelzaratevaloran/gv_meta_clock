import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseService {

  Future<Database> db() async {

    final dbPath = await getDatabasesPath();    
    
    return openDatabase(
      p.join(dbPath, "gv_clock.db"), 
      onCreate:(db, version) {
        return db.execute('CREATE TABLE attendances(id INTEGER PRIMARY KEY, badge INTEGER, date_time TEXT, photo TEXT, sended INTEGER, state INTEGER, location TEXT)');      
      },
      version: 1,      
    );
  }


  /*
  Future<Database> db() async {
    return openDatabase(join(await getDatabasesPath(), "checador.db"),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    });
  }
  */

// final database = openDatabase(
//   // Set the path to the database. Note: Using the `join` function from the
//   // `path` package is best practice to ensure the path is correctly
//   // constructed for each platform.
//   join(await getDatabasesPath(), 'doggie_database.db'),
//   // When the database is first created, create a table to store dogs.
//   onCreate: (db, version) {
//     // Run the CREATE TABLE statement on the database.
//     return db.execute(
//       'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
//     );
//   },
//   // Set the version. This executes the onCreate function and provides a
//   // path to perform database upgrades and downgrades.
//   version: 1,
// );
}
