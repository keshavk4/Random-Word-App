import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:random_word/services/mappingfile.dart';

import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

// To load data from the API
Future<List> loadDataFromAPI() async {
  Uri uri = Uri.parse("https://random-word-api-xi.vercel.app/word");
  var response = await http.get(uri);
  dynamic data = jsonDecode(response.body);
  return [data["word"], data["definition"], data["pronunciation"]];
}

class NoteDatabase {
  static dynamic database;

  // Method to open database
  static Future<Database> openDataBaseFunction() async {
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
      join(await getDatabasesPath(), "wordatabase.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE words(Word TEXT, Definition TEXT, Pronunciation TEXT)",
        );
      },
      version: 1,
    );
    return database;
  }

  // Method to insert data into database
  static Future<void> insertDataIntoDatabase(WordClass wordClass) async {
    final db = await database;
    await db.insert(
      "words",
      wordClass.toMap(),
    );
  }

  // Method to fetch data from the database
  static Future<List<WordClass>> selectDataFromDatabase() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("words");

    return List.generate(maps.length, (i) {
      return WordClass(
        word: maps[i]["Word"],
        definition: maps[i]["Definition"],
        pronunciation: maps[i]["Pronunciation"],
      );
    });
  }
}
