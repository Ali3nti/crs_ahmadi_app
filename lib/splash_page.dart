import 'package:crs_ahmadi/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> openLink() async {
    final Uri url = Uri.parse('https://shahecheragh.ir');
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webOnlyWindowName: '_self',
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            shrinkWrap: true,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return constraints.maxWidth > 600
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/001.jpg",
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'به سامانه ثبت شکایات، انتقادات و پیشنهادات آستان مقدس حضرت احمد بن موسی الکاظم شاهچراغ ',
                                                style: GoogleFonts.lalezar(
                                                  fontSize: 24,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Transform.translate(
                                                  offset: const Offset(3, -8),
                                                  child: Text(
                                                    'علیه السلام',
                                                    //superscript is usually smaller in size
                                                    // textScaleFactor: 0.7,
                                                    style: GoogleFonts.lalezar(
                                                      fontSize: 24,
                                                    ),
                                                    textScaler:
                                                        TextScaler.linear(0.7),
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'خوش آمدید',
                                                style: GoogleFonts.lalezar(
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'جهت ثبت شکایات، انتقادات یا پیشنهادات خود به صفحه بعد مراجعه نمایید',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                              : Column(
                                children: [
                                  Image.asset(
                                    "assets/images/001.jpg",
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 20),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'به سامانه ثبت شکایات، انتقادات و پیشنهادات آستان مقدس حضرت احمد بن موسی الکاظم شاهچراغ',
                                          style: GoogleFonts.lalezar(
                                            fontSize: 24,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(3, -8),
                                            child: Text(
                                              'علیه السلام',
                                              //superscript is usually smaller in size
                                              // textScaleFactor: 0.7,
                                              style: GoogleFonts.lalezar(
                                                fontSize: 24,
                                              ),
                                              textScaler: TextScaler.linear(
                                                0.7,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                          'خوش آمدید',
                                          style: GoogleFonts.lalezar(
                                            fontSize: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  Text(
                                    'جهت ثبت شکایات، انتقادات یا پیشنهادات خود به صفحه بعد مراجعه نمایید',
                                    textAlign: TextAlign.justify,

                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: (){
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRightWithFade,
                          child: RegistrationPage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios_new),
                    label: Text(
                      'ورود به فرم ثبت شکایات',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),

                    style: ElevatedButton.styleFrom(
                      elevation: 6,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      backgroundColor: Colors.lightGreen,
                      textStyle: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: openLink,
                    icon: Icon(Icons.home),
                    label: Text('صفحه اصلی سایت'),
                    style: ElevatedButton.styleFrom(
                      elevation: 6,

                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
