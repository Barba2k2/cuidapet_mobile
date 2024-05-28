import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'migration.dart';

class MigrationV1 extends Migration {
  @override
  void create(Batch batch) {
    try {
      log('Creating migration v1');
      batch.execute(
        '''
        CREATE TABLE address (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          address TEXT NOT NULL, 
          lat REAL, 
          lng REAL, 
          additional TEXT
        )
      ''',
      );
    } catch (e, s) {
      log('Error on create migration v1', error: e, stackTrace: s);
    }
  }

  @override
  void update(Batch batch) {}
}
