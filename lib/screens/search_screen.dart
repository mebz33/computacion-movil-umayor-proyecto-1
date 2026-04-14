import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/wp_service.dart';
import '../theme.dart';
import '../widgets/article_card.dart';

// Funcionalidad adicional 3: Buscador global de noticias.
// Justificación: Permite al usuario buscar artículos en tiempo real consumiendo
// la API REST de WordPress, replicando la funcionalidad de búsqueda del sitio web.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Article>? _results;
  bool _loading = false;

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    setState(() => _loading = true);
    final results = await WpService.search(query);
    if (mounted) setState(() { _results = results; _loading = false; });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
          decoration: const InputDecoration(
            hintText: 'Buscar noticias...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _search),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(height: 4, decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _results == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text('Busca noticias en El Maule Informa', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : _results!.isEmpty
                  ? Center(child: Text('No se encontraron resultados', style: TextStyle(color: Colors.grey[500])))
                  : ListView.builder(
                      itemCount: _results!.length,
                      itemBuilder: (_, i) => ArticleCardSmall(article: _results![i]),
                    ),
    );
  }
}
