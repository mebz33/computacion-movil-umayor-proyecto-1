import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../widgets/app_footer.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Funcionalidad adicional 4: Envío de formulario de contacto por email.
  // Justificación: Replica la funcionalidad del formulario de contacto del sitio web,
  // permitiendo al usuario enviar un mensaje pre-llenado a prensa@elmauleinforma.cl
  // mediante url_launcher, integrando la app con el cliente de correo del dispositivo.
  void _sendEmail() {
    final subject = Uri.encodeComponent('Contacto desde App - ${_nameController.text}');
    final body = Uri.encodeComponent(
      'Nombre: ${_nameController.text}\nEmail: ${_emailController.text}\n\n${_messageController.text}',
    );
    launchUrl(Uri.parse('mailto:prensa@elmauleinforma.cl?subject=$subject&body=$body'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacto'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(height: 4, decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contacto', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28)),
                  const SizedBox(height: 16),
                  Text(
                    'Estamos atentos a tus dudas, comentarios y propuestas.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Escríbenos y te contactaremos a la brevedad.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Prensa: ', style: Theme.of(context).textTheme.bodyLarge),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse('mailto:prensa@elmauleinforma.cl')),
                        child: Text(
                          'prensa@elmauleinforma.cl',
                          style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Divider(),
                  const SizedBox(height: 20),
                  // Form fields matching the website
                  _buildField('Nombre', _nameController, required: true),
                  const SizedBox(height: 16),
                  _buildField('Email', _emailController, type: TextInputType.emailAddress, required: true),
                  const SizedBox(height: 16),
                  _buildField('Mensaje', _messageController, maxLines: 6, required: true),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _sendEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Enviar'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1, TextInputType? type, bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
            children: required
                ? [const TextSpan(text: '  *', style: TextStyle(color: Colors.red, fontSize: 13))]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
