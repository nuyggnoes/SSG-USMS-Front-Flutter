import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:usms_app/models/word_model.dart';

class WordJson {
  static const String baseUrl =
      "http://10.0.2.2:3003/test/words"; //http://10.0.2.2:3003/test/user

  static Future<List<WordModel>> getWords() async {
    List<WordModel> wordInstances = [];
    final url = Uri.parse(baseUrl);
    print(url.toString());
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> words = jsonDecode(response.body);

      for (var word in words) {
        wordInstances.add(WordModel.fromJson(word));
        print(word);
      }
      return wordInstances;
    } else {
      print("Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
      throw Exception("Failed to load words");
    }
  }

  static Future<List<WordModel>> getWordsByDay(day) async {
    List<WordModel> wordsByDay = [];
    final url = Uri.parse('$baseUrl/$day');
    print(url.toString());
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> words = jsonDecode(response.body);

      for (var word in words) {
        wordsByDay.add(WordModel.fromJson(word));
        print(word);
      }
      return wordsByDay;
    } else {
      print("Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
      throw Exception("Failed to load words");
    }
  }
}
