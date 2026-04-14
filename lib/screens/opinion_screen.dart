import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/article.dart';
import '../services/wp_service.dart';
import '../theme.dart';
import '../widgets/app_footer.dart';
import 'article_detail_screen.dart';

class OpinionScreen extends StatefulWidget {
  const OpinionScreen({super.key});

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
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
    final articles = await WpService.getPosts(page: _page, perPage: 12, categorySlug: 'opinion');
    if (mounted) {
      setState(() {
        _articles.addAll(articles);
        _hasMore = articles.length == 12;
        _page++;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opinión'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(height: 4, decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
        ),
      ),
      body: _articles.isEmpty && _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              controller: _scrollController,
              children: [
                // Breadcrumb
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    'Home  ›  Category  ›  Opinión',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ),
                // Page title
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Text('Opinión', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w800)),
                ),
                // Hero: 2 featured articles side by side
                if (_articles.length >= 2) _buildHeroRow(),
                // Article list
                ..._buildArticleList(),
                // Loader or footer
                if (_hasMore)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                  )
                else
                  const AppFooter(),
              ],
            ),
    );
  }

  Widget _buildHeroRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Row(
        children: [
          Expanded(child: _HeroCard(article: _articles[0])),
          const SizedBox(width: 6),
          Expanded(child: _HeroCard(article: _articles[1])),
        ],
      ),
    );
  }

  List<Widget> _buildArticleList() {
    final startIndex = _articles.length >= 2 ? 2 : 0;
    final listArticles = _articles.sublist(startIndex);
    return listArticles.map((article) => _OpinionListItem(article: article)).toList();
  }
}

/// Hero card matching the website's top featured opinion articles
class _HeroCard extends StatelessWidget {
  final Article article;

  const _HeroCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: article.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[300]),
                errorWidget: (_, __, ___) => Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 32, color: Colors.grey)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                    stops: const [0.2, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 10, right: 10, bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3)),
                      child: const Text('OPINIÓN', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.title,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, height: 1.3),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Article list item matching the website's opinion listing layout:
/// Horizontal card with image left, text right, excerpt below
class _OpinionListItem extends StatelessWidget {
  final Article article;

  const _OpinionListItem({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article))),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: article.imageUrl,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(width: 120, height: 90, color: Colors.grey[200]),
                errorWidget: (_, __, ___) => Container(width: 120, height: 90, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
              ),
            ),
            const SizedBox(width: 12),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          article.author.toUpperCase(),
                          style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 3),
                      Text(DateFormat('dd/MM/yyyy').format(article.date), style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.excerpt,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
