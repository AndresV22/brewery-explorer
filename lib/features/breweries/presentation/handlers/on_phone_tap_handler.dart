import 'package:url_launcher/url_launcher.dart';

class OnPhoneTapHandler {
  const OnPhoneTapHandler();

  Future<void> call(String phone) async {
    final sanitized = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (sanitized.isEmpty) {
      return;
    }

    final uri = Uri(scheme: 'tel', path: sanitized);
    await launchUrl(uri);
  }
}
