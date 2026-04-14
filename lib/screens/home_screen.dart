import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/article.dart';
import '../services/wp_service.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_footer.dart';

import 'article_detail_screen.dart';
import 'category_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> _featured = [];
  List<Article> _regionales = [];
  List<Article> _nacional = [];
  List<Article> _deportes = [];
  List<Article> _politica = [];
  List<Article> _economia = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      WpService.getPosts(perPage: 5),
      WpService.getPosts(perPage: 6, categorySlug: 'noticias-regionales'),
      WpService.getPosts(perPage: 6, categorySlug: 'nacional'),
      WpService.getPosts(perPage: 6, categorySlug: 'deportes'),
      WpService.getPosts(perPage: 6, categorySlug: 'politica'),
      WpService.getPosts(perPage: 6, categorySlug: 'economia'),
    ]);
    if (mounted) {
      setState(() {
        _featured = results[0];
        _regionales = results[1];
        _nacional = results[2];
        _deportes = results[3];
        _politica = results[4];
        _economia = results[5];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 35),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(height: 4, decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
        ),
      ),
      drawer: const AppDrawer(),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadData,
              child: ListView(
                children: [
                  // Hero slider
                  if (_featured.isNotEmpty) _buildHeroSlider(),
                  // Subscribe banner
                  _buildSubscribeBanner(),
                  // Sections matching website
                  _buildNewsSection('Noticias Regionales', _regionales, 'noticias-regionales'),
                  _buildNewsSection('Nacional', _nacional, 'nacional'),
                  _buildNewsSection('Política', _politica, 'politica'),
                  _buildNewsSection('Economía', _economia, 'economia'),
                  _buildNewsSection('Deportes', _deportes, 'deportes'),
                  const SizedBox(height: 8),
                  const AppFooter(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeroSlider() {
    final hero = _featured.first;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: hero))),
      child: Container(
        margin: const EdgeInsets.all(12),
        height: 220,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: hero.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, s) => Container(color: Colors.grey[300]),
                errorWidget: (_, u, e) => Container(color: Colors.grey[300], child: const Icon(Icons.newspaper, size: 60, color: Colors.grey)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                    stops: const [0.25, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 16, right: 16, bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hero.category.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3)),
                        child: Text(hero.category.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                    const SizedBox(height: 8),
                    Text(hero.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, height: 1.25), maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 13, color: Colors.white60),
                        const SizedBox(width: 4),
                        Text(hero.author, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time, size: 13, color: Colors.white60),
                        const SizedBox(width: 4),
                        Text(DateFormat('dd/MM/yyyy').format(hero.date), style: const TextStyle(color: Colors.white60, fontSize: 11)),
                      ],
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

  Widget _buildSubscribeBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.mail_outline, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Suscríbete a nuestra lista de correo', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('Recibe gratis las últimas noticias del Maule', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
            child: Text('Suscribirse', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  /// Builds a section matching the website layout:
  /// Green header bar + 1 large featured card + 2-column grid of smaller cards
  Widget _buildNewsSection(String title, List<Article> articles, String slug) {
    if (articles.isEmpty) return const SizedBox.shrink();

    final featured = articles.first;
    final rest = articles.skip(1).take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with green accent bar (matching website)
        _SectionTitle(
          title: title,
          onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(title: title, slug: slug))),
        ),
        // Featured large card
        _FeaturedArticleCard(article: featured),
        // Grid of 2 columns
        if (rest.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.72,
              ),
              itemCount: rest.length,
              itemBuilder: (context, index) => _SmallGridCard(article: rest[index]),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Green section title bar matching the website
class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const _SectionTitle({required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 20, 12, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: const Row(
                children: [
                  Text('Ver todo', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white70),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Large featured article card matching the website's main article per section
class _FeaturedArticleCard extends StatelessWidget {
  final Article article;

  const _FeaturedArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article))),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: article.imageUrl,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, s) => Container(height: 190, color: Colors.grey[200], child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
                errorWidget: (_, u, e) => Container(height: 190, color: Colors.grey[200], child: const Icon(Icons.image, size: 48, color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3)),
                      child: Text(article.category.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  const SizedBox(height: 8),
                  Text(article.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(article.excerpt, style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Flexible(child: Text(article.author, style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 10),
                      Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(DateFormat('dd/MM/yyyy').format(article.date), style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ],
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

/// Small grid card for 2-column layout
class _SmallGridCard extends StatelessWidget {
  final Article article;

  const _SmallGridCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, s) => Container(color: Colors.grey[200]),
                  errorWidget: (_, u, e) => Container(color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.3),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd/MM/yyyy').format(article.date),
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
