import 'package:sqflite_common/sqlite_api.dart';

import 'migration.dart';

class MigrationV1 extends Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
        CREATE TABLE address (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          address TEXT NOT NULL, 
          lag TEXT, 
          lng TEXT, 
          additional TEXT,
        )
      ''',
    );
  }

  @override
  void update(Batch batch) {}
}
