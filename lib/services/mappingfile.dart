import 'dart:convert';

List<WordClass> wordClassFromJson(String str) =>
    List<WordClass>.from(json.decode(str).map((x) => WordClass.fromJson(x)));

String wordClassToJson(List<WordClass> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class WordClass {
  WordClass({
    required this.word,
    required this.definition,
    required this.pronunciation,
  });

  String word;
  String definition;
  String pronunciation;

  factory WordClass.fromJson(Map<String, dynamic> json) => WordClass(
        word: json["word"],
        definition: json["definition"],
        pronunciation: json["pronunciation"],
      );

  Map<String, dynamic> toMap() => {
        "word": word,
        "definition": definition,
        "pronunciation": pronunciation,
      };
}
