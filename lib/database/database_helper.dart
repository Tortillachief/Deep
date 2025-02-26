import 'dart:io';
import 'package:deep/game_card.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'cards.dart';

part 'database_helper.g.dart'; // This line is essential for code generation

const String dbName = 'app_database.sqlite';

@DriftDatabase(tables: [Cards])
class AppDatabase extends _$AppDatabase {
  // Constructor: Initializes the database connection
  AppDatabase() : super(_openConnection());

  // Schema version for migrations (update if you change tables)
  @override
  int get schemaVersion => 1;

  // Get all cards
  Future<List<Card>> getAllCards() => select(cards).get();
}

// Open the database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    await _copyDatabaseToDocumentsDirectory();
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, dbName));
    return NativeDatabase.createInBackground(file);
  });
}

Future<void> _copyDatabaseToDocumentsDirectory() async {
  final dbFolder =
      await getApplicationDocumentsDirectory(); // Get the app's document directory
  final dbPath = p.join(
      dbFolder.path, dbName); // Create the full path for the database file

  // Check if the database already exists in the writable directory
  final dbFile = File(dbPath);
  if (await dbFile.exists()) {
    return; // The database already exists, no need to copy it again
  }

  // Load the database from assets
  final ByteData data = await rootBundle.load('assets/$dbName');
  final List<int> bytes = data.buffer.asUint8List();

  // Write the bytes to the writable directory
  await dbFile.writeAsBytes(bytes, flush: true);
}
