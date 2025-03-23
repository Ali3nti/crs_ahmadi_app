
import 'dart:convert';

import 'dart:io';

import 'package:crs_ahmadi/end_page.dart';
import 'package:crs_ahmadi/response_model.dart';
import 'package:crs_ahmadi/uploader_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
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

  void _navigateToNextPage(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.leftToRightWithFade,
        child: EndPage(),
      ),
    );
  }

  void _goToHomePage(BuildContext context) {
    // Implement navigation to the home page or any other action
    // For now, we can just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Going to Home Page!')));
  }

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  Future<void> uploadFile(selectedFileList) async {
    print(selectedFileList.length);
    if (selectedFileList.isEmpty) return;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1/api/send_msg'),
    );
    request.files.add(
      await http.MultipartFile.fromPath('file', selectedFileList.first.path),
    );

    for (File file in selectedFileList) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files', // Change this to match your API's expected field name
          file.path,
          filename: basename(file.path),
        ),
      );
    }

    var response = await request.send();
    print(response.reasonPhrase.toString());
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed');
    }
  }

  Future<DataResponse> sendMSG({
    String? name,
    String? phone,
    String? city,
    String? loe,
    int? titleId,
    int? reporterId,
    required String message,
    List<File>? files, // تغییر نوع files به لیست فایل‌ها
  }) async {
    Uri uri = Uri.parse("http://127.0.0.1/crs_ahmadi_server/public/api/send_msg");

    var request = http.MultipartRequest("POST", uri);

    // اضافه کردن فیلدهای متنی
    request.fields['name'] = name ?? 'null';
    request.fields['phone'] = phone ?? 'null';
    request.fields['city'] = city ?? 'null';
    request.fields['loe'] = loe ?? 'null';
    request.fields['titleId'] = titleId?.toString() ?? '0';
    request.fields['reporterId'] = reporterId?.toString() ?? '0';
    request.fields['message'] = message;

    // اضافه کردن فایل‌ها
    if (files != null && files.isNotEmpty) {
      for (var file in files) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          'files[]', // مطمئن شوید که این نام در سرور شما پشتیبانی می‌شود
          stream,
          length,
          filename: basename(file.path),
        );
        request.files.add(multipartFile);
      }
    }

    // ارسال درخواست
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      print("**!!!** sendMSG response: ---->  $responseData");
      return DataResponse.fromJson(jsonDecode(responseData));
    } else {
      throw Exception(
        'Failed to connect -sendMSG-: ${response.statusCode} -> ${await response.stream.bytesToString()}',
      );
    }
  }

  void Function(String?)? onChanged;
  List<String> titleList = ["شکایت", "درخواست", "انتقادات", "پیشنهادات"];
  List<String> reporterList = ["زائرین", "خدام", "پرسنل", "شهروندان"];
  String? titleSelectedValue;
  String? reporterSelectedValue;
  List<File> filesList = [];

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
                                    width: 300,
                                    height: 300,
                                    child: Image.network(
                                      'https://astanahmadi.com/wp-content/uploads/2024/01/%D8%AD%D8%B1%D9%85-%D9%85%D8%B7%D9%87%D8%B1-%D8%AD%D8%B6%D8%B1%D8%AA-%D8%B4%D8%A7%D9%87%DA%86%D8%B1%D8%A7%D8%BA-%D8%B9%D9%84%DB%8C%D9%87-%D8%A7%D9%84%D8%B3%D9%84%D8%A7%D9%85.jpg',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                                "assets/images/001.jpg",
                                              ),
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
                                                    'سامانه ثبت شکایات، انتقادات و پیشنهادات حرم مطهر شاهچراغ ',
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
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 16),
                                        Text(
                                          'مسیر های ارسال شکایات، انتقادات یا پیشنهادات',
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.lalezar(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          children: [
                                            SizedBox(height: 8),

                                            Text(
                                              'شماره تلفن تماس: 09368513575',
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'ارتباط در شبکه های اجتماعی: (بله، ایتا، روبیکا و واتساپ) 09368513575',
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'مراجعات حضوری: شیراز، حرم مطهر حضرت شاهچراغ علیه السلام، صحن اصلی، طبقه دوم، جنب اداره کل حراست آستان مقدس، واحد رسیدگی به شکایات',
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'ارتباط از طریق صندوق های دریافت شکایات در صحن های حرم مطهر',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              'سامانه ثبت شکایات، انتقادات و پیشنهادات حرم مطهر شاهچراغ ',
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
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 16),

                                  Text('شماره تماس: 09179179117'),
                                  SizedBox(height: 8),
                                  Text(
                                    'ارتباط در فضای مجازی (بله و ایتا): 09179179117',
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'آدرس: شیراز، حرم مطهر حضرت شاهچراغ علیه السلام، صحن مطهر، اداره کل حراست آستان مقدس',
                                  ),
                                ],
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return constraints.maxWidth > 600
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'نام و نام خانوادگی (اختیاری)',
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 10,
                                                    ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'لطفا نام و نام خانوادگی خود را وارد کنید';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: TextFormField(
                                              controller: phoneController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'شماره تماس (اختیاری)',
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 10,
                                                    ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'لطفا شماره تماس خود را وارد کنید';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'شهر محل سکونت (اختیاری)',
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 10,
                                                    ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'لطفا شهر محل سکونت خود را وارد کنید';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: TextFormField(
                                              controller: phoneController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'میزان تحصیلات (اختیاری)',
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 10,
                                                    ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'لطفا آخرین مدرک تحصیلی خود را وارد کنید';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: DropdownButton<String>(
                                                hint: Text(
                                                  "موضوع گزارش (اختیاری)",
                                                ),

                                                iconEnabledColor: Colors.blue,
                                                isExpanded: true,
                                                elevation: 16,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                value: titleSelectedValue,
                                                dropdownColor: Colors.white,
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),

                                                items:
                                                    titleList
                                                        .map<
                                                          DropdownMenuItem<
                                                            String
                                                          >
                                                        >(
                                                          (
                                                            String item,
                                                          ) => DropdownMenuItem<
                                                            String
                                                          >(
                                                            value: item,
                                                            child: Text(
                                                              item.toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    titleSelectedValue =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 26),
                                            Expanded(
                                              child: DropdownButton<String>(
                                                hint: Text(
                                                  "گزارش دهندگان (اختیاری)",
                                                ),
                                                iconEnabledColor: Colors.blue,
                                                isExpanded: true,
                                                elevation: 16,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                value: reporterSelectedValue,
                                                dropdownColor: Colors.white,
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),

                                                items:
                                                    reporterList
                                                        .map<
                                                          DropdownMenuItem<
                                                            String
                                                          >
                                                        >(
                                                          (
                                                            String item,
                                                          ) => DropdownMenuItem<
                                                            String
                                                          >(
                                                            value: item,
                                                            child: Text(
                                                              item.toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    reporterSelectedValue =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        height: 150,
                                        child: TextField(
                                          maxLines: 20,
                                          maxLength: 500,
                                          showCursor: true,
                                          // style: inputFieldTextStyleDispenser,
                                          controller: messageController,
                                          keyboardType: TextInputType.multiline,
                                          textInputAction:
                                              TextInputAction.newline,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),

                                            labelText: 'متن پیام',
                                            alignLabelWithHint: true,

                                            hintText:
                                                'توضیحات مورد نظر را به صورت کامل وارد نمایید',
                                            focusColor: Colors.blue,
                                            fillColor: Colors.blue,
                                            // hintStyle: inputFieldHintTextStyleDispenser,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                            // border: inputFieldDefaultBorderStyle,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 16.0,
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 200,
                                          child: UploaderContainer(
                                            onChanged: (list) {
                                              filesList = list;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      TextFormField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          labelText:
                                              'نام و نام خانوادگی (اختیاری)',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 10,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'لطفا نام و نام خانوادگی خود را وارد کنید';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      TextFormField(
                                        controller: phoneController,
                                        decoration: InputDecoration(
                                          labelText: 'شماره تماس (اختیاری)',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 10,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'لطفا شماره تماس خود را وارد کنید';
                                          }
                                          return null;
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: DropdownButton<String>(
                                                hint: Text("موضوع (اختیاری)"),

                                                iconEnabledColor: Colors.blue,
                                                isExpanded: true,
                                                elevation: 16,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                value: titleSelectedValue,
                                                dropdownColor: Colors.white,
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),

                                                items:
                                                    titleList
                                                        .map<
                                                          DropdownMenuItem<
                                                            String
                                                          >
                                                        >(
                                                          (
                                                            String item,
                                                          ) => DropdownMenuItem<
                                                            String
                                                          >(
                                                            value: item,
                                                            child: Text(
                                                              item.toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    titleSelectedValue =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 26),
                                            Expanded(
                                              child: DropdownButton<String>(
                                                hint: Text(
                                                  "حوزه مربوطه (اختیاری)",
                                                ),
                                                iconEnabledColor: Colors.blue,
                                                isExpanded: true,
                                                elevation: 16,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                value: reporterSelectedValue,
                                                dropdownColor: Colors.white,
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),

                                                items:
                                                    titleList
                                                        .map<
                                                          DropdownMenuItem<
                                                            String
                                                          >
                                                        >(
                                                          (
                                                            String item,
                                                          ) => DropdownMenuItem<
                                                            String
                                                          >(
                                                            value: item,
                                                            child: Text(
                                                              item.toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    reporterSelectedValue =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        height: 150,
                                        child: TextField(
                                          maxLines: 20,
                                          maxLength: 500,
                                          showCursor: true,
                                          // style: inputFieldTextStyleDispenser,
                                          controller: messageController,
                                          keyboardType: TextInputType.multiline,
                                          textInputAction:
                                              TextInputAction.newline,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),

                                            labelText: 'متن پیام',
                                            alignLabelWithHint: true,

                                            hintText:
                                                'توضیحات مورد نظر را به صورت کامل وارد نمایید',
                                            focusColor: Colors.blue,
                                            fillColor: Colors.blue,
                                            // hintStyle: inputFieldHintTextStyleDispenser,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                            // border: inputFieldDefaultBorderStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => sendMSG(name: "ali", message: 'hello', files: filesList),
                icon: Icon(Icons.arrow_back_ios_new),
                label: Text('ثبت و ارسال پیام'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 10),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
