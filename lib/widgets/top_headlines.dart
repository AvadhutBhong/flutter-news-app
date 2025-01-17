import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/screens/news_details_screen.dart';
import 'package:news_app/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class TopHeadlinesCarousel extends StatelessWidget {
  final ApiService client;

  const TopHeadlinesCarousel({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: client.getTopHeadlines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show shimmer while loading
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            height: 200,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[400],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Display error message
          return Center(
            child: Text(
              'Unable to load headlines. Please try again later.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final articles = snapshot.data!;
          return CarouselSlider.builder(
            itemCount: articles.length,
            options: CarouselOptions(
              height: 250,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.85,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayCurve: Curves.easeInOut,
            ),
            itemBuilder: (context, index, realIndex) {
              final article = articles[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailsScreen(article: article),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(article.urlToImage ?? 'https://via.placeholder.com/400'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Gradient overlay for better readability
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.black87, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      // Article title
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Text(
                          article.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          // Display a message if no data is available
          return Center(
            child: Text(
              'No headlines available at the moment.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }
}
