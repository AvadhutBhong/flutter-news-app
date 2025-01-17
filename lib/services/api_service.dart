import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';

class ApiService {
  final String _baseUrl = "https://newsapi.org/v2";
  final String? _apiKey = dotenv.env['API_KEY'];
  final http.Client _client = http.Client();

  Future<List<Article>> getArticles({required String category}) async {
    if (_apiKey == null) {
      throw Exception('API Key is missing');
    }

    final url = Uri.parse('$_baseUrl/everything?q=$category&apiKey=$_apiKey');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> body = json['articles'];
        return body.map((item) => Article.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  Future<List<Article>> getTopHeadlines({String country = 'us'}) async {
    if (_apiKey == null) {
      throw Exception('API Key is missing');
    }

    final url = Uri.parse(
        '$_baseUrl/top-headlines?pageSize=5&country=$country&apiKey=$_apiKey');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> body = json['articles'];
        return body.map((item) => Article.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load top headlines: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching top headlines: $e');
    }
  }
}
