import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../widgets/app_footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiénes Somos'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(height: 4, decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Breadcrumb
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text('Home  ›  Quiénes Somos', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Quiénes Somos', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 20),
            // Laptop image (matching website)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: 'https://elmauleinforma.cl/wp-content/uploads/2020/09/laptop-mockup.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(height: 200, color: Colors.grey[200]),
                  errorWidget: (_, __, ___) => Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.laptop_mac, size: 64, color: AppColors.primary.withValues(alpha: 0.5)),
                        const SizedBox(height: 8),
                        Text('elmauleinforma.cl', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: const [
                        TextSpan(text: 'El Maule Informa ', style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: 'es un medio de comunicación independiente, pluralista e inclusivo que busca el desarrollo de la Región del Maule de la cual forma parte y se identifica plenamente.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Nuestra misión consiste en ser una fuente de información seria y profesional que contribuya al fortalecimiento de la comunidad maulina.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  // Director info
                  Text('Director: José Manuel Alvarez Espinoza', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
                  const SizedBox(height: 10),
                  Text('Contacto: +56995343762', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse('mailto:jmalvarez@elmauleinforma.cl')),
                    child: Text('jmalvarez@elmauleinforma.cl', style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse('mailto:prensa@elmauleinforma.cl')),
                    child: Text('prensa@elmauleinforma.cl', style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            // Subscribe section matching website
            _SubscribeSection(),
            const SizedBox(height: 24),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _SubscribeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Green header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Suscríbete a nuestra lista de correo', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text('Recibe gratis las últimas noticias del Maule directamente en tu correo', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          // Form fields
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Correo electrónico',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ciudad',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Suscribirse'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
