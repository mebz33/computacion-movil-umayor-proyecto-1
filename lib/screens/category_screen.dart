import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/wp_service.dart';
import '../theme.dart';
import '../widgets/article_card.dart';

class CategoryScreen extends StatefulWidget {
  final String title;
  final String slug;

  const CategoryScreen({super.key, required this.title, required this.slug});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Article> _articles = [];
  int _page = 1;
  bool _loading = true;
  bool _hasMore = true;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (!_hasMore || (_loading && _page > 1)) return;
    setState(() => _loading = true);
    final articles = await WpService.getPosts(page: _page, perPage: 10, categorySlug: widget.slug);
    if (mounted) {
      setState(() {
        _articles.addAll(articles);
        _hasMore = articles.length == 10;
        _page++;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(height: 4, decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
        ),
      ),
      body: _articles.isEmpty && _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView.builder(
              controller: _scrollController,
              itemCount: _articles.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _articles.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                  );
                }
                return index == 0
                    ? ArticleCard(article: _articles[index])
                    : ArticleCardSmall(article: _articles[index]);
              },
            ),
    );
  }
}
