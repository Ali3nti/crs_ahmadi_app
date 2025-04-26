import 'dart:html' as html;

import 'package:crs_ahmadi/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({super.key, required this.isOK});

  final bool isOK;

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (widget.isOK)
                ? const Icon(Icons.check_circle, color: Colors.green, size: 80)
                : const Icon(Icons.cancel, color: Colors.red, size: 80),
            const SizedBox(height: 3),
            (widget.isOK)
                ? Text("پیام شما ثبت شد.", style: const TextStyle(fontSize: 26))
                : Text(
                  "مشکلی پیش آمده. لطفا بعدا امتحان کنید.",
                  style: const TextStyle(fontSize: 26),
                ),
            const SizedBox(height: 3),
          ],
        ),
      ),
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text('بازگشت به سایت حرم'),
          onPressed: () async {
            final Uri url = Uri.parse('https://shahecheragh.ir');
            if (!await launchUrl(
              url,
              mode: LaunchMode.inAppWebView,
              webOnlyWindowName: '_self',
            )) {
              throw Exception('Could not launch $url');
            }
          },
        ),
        TextButton(
          child: Text(
            'بازگشت به سامانه شکایات، انتقادات و پیشنهادات',
            style: const TextStyle(color: Colors.redAccent),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SplashPage()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
