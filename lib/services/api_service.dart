import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';

class ApiService {
  final String baseUrl = "https://newsapi.org/v2";
  final apiKey = dotenv.env['API_KEY'];
  final client = http.Client();

  Future<List<Article>> getArticles() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['articles'];
        List<Article> articles =
            body.map((dynamic item) => Article.fromJson(item)).toList();
        return articles;
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
