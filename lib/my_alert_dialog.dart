
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitCircle(
              size: 50.0,
              color: Colors.indigo,
            ),
            Text(
              'لطفا منتظر بمانید',
            )
          ],
        ),
      ),
    );
  }
}


class SelectableListDialog extends StatefulWidget {
  const SelectableListDialog({
    super.key,
    required this.title,
    required this.baseList,
    required this.controller,
    required this.onChanged,
    this.selectedItem,
  });
  final String title;
  final List<dynamic> baseList;
  final TextEditingController controller;
  final dynamic selectedItem;
  final Function(dynamic) onChanged;

  @override
  State<SelectableListDialog> createState() => _SelectableListDialogState();
}

class _SelectableListDialogState extends State<SelectableListDialog> {
  late List tempList;
  late dynamic selectedItem;
  @override
  void initState() {
    super.initState();
    tempList = widget.baseList;
    selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 2,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [
          Text(
            widget.title,
          ),
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            margin: const EdgeInsets.only(top: 5, bottom: 15),
            padding: const EdgeInsets.only(),
            child: TextFormField(
              controller: widget.controller,
              decoration: const InputDecoration(
                hintText: "جست و جو",
                contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
              ),
              onChanged: (val) {
                tempList.clear();
                if (val.isNotEmpty && val.length > 2) {
                  tempList.addAll(
                      widget.baseList.where((e) => e.name!.contains(val)));
                } else {
                  tempList.addAll(widget.baseList);
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: tempList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: tempList.length,
                itemBuilder: (BuildContext context, int index) {
                  return RadioListTile<dynamic>(
                      title: Text(
                        '${tempList[index].name}',
                      ),
                      value: tempList[index],
                      groupValue: widget.selectedItem,
                      onChanged: (value) {
                        widget.onChanged(value);
                        selectedItem = value;
                        // widget.baseController?.text = value.name;
                        // print(widget.baseController?.text);
                        setState(() {});
                      });
                })
            : const Center(
                child: Text(
                  "نتیجه ای یافت نشد",
                  textAlign: TextAlign.center,
                ),
              ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text("بستن"))
      ],
    );
  }
}
class FinalAlertDialog extends StatefulWidget {
  const FinalAlertDialog({super.key, this.message});

  final String? message;

  @override
  State<FinalAlertDialog> createState() => _FinalAlertDialogState();
}

class _FinalAlertDialogState extends State<FinalAlertDialog> {
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
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 3),
            Text(
              "پیام شما ثبت شد.",
              style: const TextStyle(
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 3),
            if (widget.message != null)
              Text(
                widget.message ?? '',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.green, foregroundColor: Colors.white),
          child: Text(
            'بازگشت به سایت حرم',
          ),
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
            'بستن صفحه',
            style: const TextStyle(color: Colors.redAccent),
          ),
          onPressed: () {
            html.window.close();
          },
        ),
      ],
    );
  }
}

