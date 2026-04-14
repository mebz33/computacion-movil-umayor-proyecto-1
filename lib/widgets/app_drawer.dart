import 'package:flutter/material.dart';
import '../theme.dart';
import '../screens/home_screen.dart';
import '../screens/category_screen.dart';
import '../screens/about_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/opinion_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/logo.png', height: 45),
                const SizedBox(height: 8),
                const Text(
                  'Noticias de la Región del Maule',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(icon: Icons.home, title: 'Portada', onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                }),
                _DrawerItem(icon: Icons.location_on, title: 'Noticias Regionales', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Noticias Regionales', slug: 'noticias-regionales'),
                  ));
                }),
                _DrawerItem(icon: Icons.public, title: 'Nacional', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Nacional', slug: 'nacional'),
                  ));
                }),
                _DrawerItem(icon: Icons.sports_soccer, title: 'Deportes', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Deportes', slug: 'deportes'),
                  ));
                }),
                _DrawerItem(icon: Icons.gavel, title: 'Policía y Tribunales', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Policía y Tribunales', slug: 'policia-y-tribunales'),
                  ));
                }),
                _DrawerItem(icon: Icons.how_to_vote, title: 'Política', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Política', slug: 'politica'),
                  ));
                }),
                _DrawerItem(icon: Icons.trending_up, title: 'Economía', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Economía', slug: 'economia'),
                  ));
                }),
                _DrawerItem(icon: Icons.edit_note, title: 'Opinión', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OpinionScreen()));
                }),
                const Divider(),
                _DrawerItem(icon: Icons.agriculture, title: 'Agricultura', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Agricultura', slug: 'agricultura'),
                  ));
                }),
                _DrawerItem(icon: Icons.computer, title: 'Tecnología', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Tecnología', slug: 'tecnologia'),
                  ));
                }),
                _DrawerItem(icon: Icons.palette, title: 'Cultura', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Cultura', slug: 'cultura'),
                  ));
                }),
                _DrawerItem(icon: Icons.school, title: 'Educación', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CategoryScreen(title: 'Educación', slug: 'educacion'),
                  ));
                }),
                const Divider(),
                _DrawerItem(icon: Icons.people, title: 'Quiénes Somos', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                }),
                _DrawerItem(icon: Icons.mail, title: 'Contacto', onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactScreen()));
                }),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              '© 2024 El Maule Informa',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      dense: true,
      onTap: onTap,
    );
  }
}
