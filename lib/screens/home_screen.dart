import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/services/api_service.dart';
import 'package:news_app/widgets/article_list.dart';
import 'package:news_app/widgets/category_selector.dart';
import 'package:news_app/widgets/custom_bottom_navigation_bar.dart';
import 'package:news_app/widgets/top_headlines.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  String _selectedCategory = 'general';
  int _currentTabIndex = 0;

  final List<String> _categories = [
    'general',
    'entertainment',
    'health',
    'sports',
    'business',
    'technology',
  ];

  final List<IconData> _bottomNavIcons = [
    Icons.home_outlined,
    Icons.search_outlined,
    Icons.bookmark_outline_rounded,
    Icons.settings_outlined,
  ];

  final List<String> _bottomNavLabels = [
    'Home',
    'Search',
    'Saved',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopHeadlinesCarousel(client: _apiService),
            CategorySelector(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategoryTap: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ArticleList(
                apiService: _apiService,
                selectedCategory: _selectedCategory,
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentTabIndex,
          icons: _bottomNavIcons,
          labels: _bottomNavLabels,
          onTabSelected: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      leading: const Icon(Icons.menu_rounded, color: Colors.white),
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      title: Text(
        "GlobalEye",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
