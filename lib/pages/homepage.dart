import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:random_word/services/datafile.dart';
import 'package:random_word/pages/listpage.dart';
import 'package:random_word/services/mappingfile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _word = "";
  String _definition = "";
  String _pronunciation = "";
  DateTime _lastDateTime = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    NoteDatabase.openDataBaseFunction();
    _loadPreferences();

    // It will check for the date every 5 seconds if current date is greater than previous than it will update the values
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (DateTime.now().year > _lastDateTime.year ||
          DateTime.now().month > _lastDateTime.month ||
          DateTime.now().day > _lastDateTime.day) {
        setState(() {
          _lastDateTime = DateTime.now();
        });
        _updateData();
      }
    });
  }

  // This method check for the  existing preference if any otherwise it will call _updateData() method
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _word = prefs.getString('word') ?? "";
      _definition = prefs.getString('definition') ?? "";
      _pronunciation = prefs.getString("pronunciation") ?? "";
      if (_word != "") {
        _lastDateTime = DateTime.parse(prefs.getString("date") ?? "");
        }
    });
    if (_word == "") _updateData();
  }

  // To save new preference
  Future<void> _setPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("word", _word);
      prefs.setString("definition", _definition);
      prefs.setString("pronunciation", _pronunciation);
      prefs.setString("date", _lastDateTime.toString());
    });
  }

  // This method will call loadDataFromAPI() to load data from the api and update the values of variable
  void _updateData() {
      setState(() {
        _isLoading = true;
      });
      loadDataFromAPI().then((value) {
        setState(() {
          _word = value[0];
          _definition = value[1];
          _pronunciation = value[2];
        });
        _insertData();
        _setPreferences();
        setState(() {
          _isLoading = false;
        });
      }).catchError((onError) {
        Fluttertoast.showToast(
        msg: "Can't Connect to The Server",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16,
      );
      });
  }

  // To insert variables data into the database 
  Future<void> _insertData() async {
    WordClass wordClass = WordClass(
        word: _word, definition: _definition, pronunciation: _pronunciation);
    NoteDatabase.insertDataIntoDatabase(wordClass);
  }

  // App UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Today's Word: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _word,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Definition: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _definition,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Pronunciation: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _pronunciation,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WordListPage(title: "History"))),
        child: const Icon(Icons.list),
        tooltip: "History",
      ),
    );
  }
}
