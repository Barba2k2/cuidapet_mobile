import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'sqlite_migration_factory.dart';

class SqliteConnectionFactory {
  static const _version = 1;
  static const _databaseName = 'CUIDAPET_LOCAL_DB';
  static SqliteConnectionFactory? _instance;

  Database? _db;
  final _lock = Lock();

  SqliteConnectionFactory._();

  factory SqliteConnectionFactory() {
    _instance ??= SqliteConnectionFactory._();
    return _instance!;
  }

  Future<Database> openConnection() async {
    try {
      if (_db == null) {
        await _lock.synchronized(
          () async {
            if (_db == null) {
              final databasePath = await getDatabasesPath();
              final pathDatabase = join(databasePath, _databaseName);

              _db = await openDatabase(
                pathDatabase,
                version: _version,
                onConfigure: _onConfigure,
                onCreate: _onCreate,
                onUpgrade: _onUpgrade,
              );

              log('Database created at $pathDatabase');
            }
          },
        );
      }

      return _db!;
    } catch (e, s) {
      log('Error on openConnection', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  void _onCreate(Database db, int version) {
    try {
      final batch = db.batch();

      final migrations = SqliteMigrationFactory().getCreateMigration();

      for (var migration in migrations) {
        migration.create(batch);
      }

      batch.commit();
      log('Database created with success!');
    } catch (e, s) {
      log('Error on create database', error: e, stackTrace: s);
    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    final batch = db.batch();

    final migrations = SqliteMigrationFactory().getUpdateMigration(oldVersion);

    for (var migration in migrations) {
      migration.update(batch);
    }

    batch.commit();
    log('Database updated with success!');
  }

  void closeConnection() {
    _db?.close();
    _db = null;
    log('Connection closed!');
  }
}
