import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/api_service.dart';
import 'package:news_app/widgets/news_item_widget.dart';
import 'package:shimmer/shimmer.dart';

class ArticleList extends StatelessWidget {
  final ApiService apiService;
  final String selectedCategory;

  const ArticleList({
    super.key,
    required this.apiService,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: apiService.getArticles(category: selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return NewsItemWidget(article: article);
            },
          );
        } else {
          return Center(
            child: Text(
              'No articles found.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          );
        }
      },
    );
  }
}
