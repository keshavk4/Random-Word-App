import 'package:flutter/material.dart';
import 'package:random_word/services/datafile.dart';
import 'package:random_word/services/mappingfile.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  bool _isLoading = false;
  List<WordClass> _wordList = [];

  @override
  void initState() {
    super.initState();
    _listData();
  }

  // This method will fetch data from the database and update the variable _wordList
  Future<void> _listData() async {
    List<WordClass> _tempWordList = await NoteDatabase.selectDataFromDatabase();
    setState(() {
      _isLoading = true;
      _wordList = _tempWordList;
      _isLoading = false;
    });
  }

  // APP UI
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
                color: Colors.black,
              ),
            )
          : Scrollbar(
              thickness: 5,
              hoverThickness: 5,
              showTrackOnHover: true,
              child: ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: _wordList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Word: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _wordList[index].word,
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
                              _wordList[index].definition,
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
                              _wordList[index].pronunciation,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  color: Colors.black,
                  height: 40,
                ),
              ),
            ),
    );
  }
}
