import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class WpService {
  static const String _baseUrl = 'https://elmauleinforma.cl/wp-json/wp/v2';

  static final Map<String, int> categoryIds = {};

  static Future<void> loadCategories() async {
    if (categoryIds.isNotEmpty) return;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/categories?per_page=50'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> cats = json.decode(response.body);
        for (final cat in cats) {
          categoryIds[cat['slug']] = cat['id'];
        }
      }
    } catch (_) {}
  }

  static Future<List<Article>> getPosts({
    int page = 1,
    int perPage = 10,
    String? categorySlug,
  }) async {
    await loadCategories();

    String url = '$_baseUrl/posts?_embed&page=$page&per_page=$perPage';
    if (categorySlug != null && categoryIds.containsKey(categorySlug)) {
      url += '&categories=${categoryIds[categorySlug]}';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Article.fromWpJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<List<Article>> search(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts?_embed&search=${Uri.encodeComponent(query)}&per_page=20'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Article.fromWpJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }
}
