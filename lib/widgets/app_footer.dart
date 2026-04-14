import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nosotros',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Container(width: 40, height: 3, color: Colors.white),
              const SizedBox(height: 14),
              const Text(
                'El Maule Informa es un medio de comunicación independiente, pluralista e inclusivo que busca el desarrollo de la Región del Maule de la cual forma parte y se identifica plenamente.',
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'Síguenos',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _SocialButton(icon: Icons.facebook, onTap: () => launchUrl(Uri.parse('https://www.facebook.com/elmauleinforma'))),
                  const SizedBox(width: 10),
                  _SocialButton(icon: Icons.alternate_email, onTap: () => launchUrl(Uri.parse('https://twitter.com/elmauleinforma'))),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Categorías',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Container(width: 40, height: 3, color: Colors.white),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  'Agricultura', 'Deportes', 'Opinión',
                  'Cartas Al Director', 'Destacados', 'Policía Y Tribunales',
                  'Coronavirus', 'Economía', 'Política',
                  'Crónicas Maulinas', 'Educación', 'Salud',
                  'Cultura', 'Eventos', 'Tecnología',
                  'Nacional', 'Noticias Regionales', 'Vida & Estilo',
                ].map((cat) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(cat, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                )).toList(),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          color: const Color(0xFF1E5C12),
          child: const Text(
            'El Maule Informa © 2024 - Diseño y Desarrollo Web Maperz.cl',
            style: TextStyle(color: Colors.white70, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
