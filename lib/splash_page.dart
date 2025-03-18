import 'package:crs_ahmadi/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

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

  void _navigateToNextPage() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.leftToRightWithFade,
        child: RegistrationPage(),
      ),
    );
  }

  void _goToHomePage() {
    // Implement navigation to the home page or any other action
    // For now, we can just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Going to Home Page!')));
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
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image.network(
                                      'https://astanahmadi.com/wp-content/uploads/2024/01/%D8%AD%D8%B1%D9%85-%D9%85%D8%B7%D9%87%D8%B1-%D8%AD%D8%B6%D8%B1%D8%AA-%D8%B4%D8%A7%D9%87%DA%86%D8%B1%D8%A7%D8%BA-%D8%B9%D9%84%DB%8C%D9%87-%D8%A7%D9%84%D8%B3%D9%84%D8%A7%D9%85.jpg',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/001.jpg") ,
                                    ),
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
                                                        TextScaler.linear(
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
                                  Image.network(
                                    'https://eform.shahecheragh.ir/collect/attach/preview/4062.jpg',
                                    width: double.infinity,
                                    height: 150,
                                  ),
                                  SizedBox(height: 20),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                          'سامانه ثبت شکایات، انتقادات و پیشنهادات آستان مقدس حضرت احمد بن موسی الکاظم شاهچراغ ',
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
                                              TextScaler.linear(
                                                0.7,
                                              ),
                                            ),
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
                    onPressed: _navigateToNextPage,
                    icon: Icon(Icons.arrow_back_ios_new),
                    label: Text('صفحه بعد'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _goToHomePage,
                    icon: Icon(Icons.home),
                    label: Text('صفحه اصلی سایت'),
                    style: ElevatedButton.styleFrom(
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
