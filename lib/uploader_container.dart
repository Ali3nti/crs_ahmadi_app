import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '/my_snack_bar.dart';
import 'package:file_picker/file_picker.dart';


class UploaderContainer extends StatefulWidget {
  const UploaderContainer({
    super.key,
    this.maxFile = 9,
    required this.onChanged,
  });
  final Function(List<dynamic>) onChanged;
  final int maxFile;

  @override
  State<UploaderContainer> createState() => _UploaderContainerState();
}

class _UploaderContainerState extends State<UploaderContainer> {

  List<File> selectedFileList = [];

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFileList.add(File(result.files.single.path!));
      });
      widget.onChanged(selectedFileList);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () async {
          if (selectedFileList.length < widget.maxFile) {
            print((selectedFileList.length > 0) ? selectedFileList.first.toString() : "null");
            pickFile();
          } else {
            MySnackBar(
              context: context,
              message: "تعداد فایل نمیتواند بیشتر از ${widget.maxFile} باشد",
              isWarning: true,
            );
          }
        },
        label: const Text("اضافه کردن"),
        icon: Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        child: DottedBorder(
          padding: const EdgeInsets.all(4),
          radius: const Radius.circular(8),
          borderType: BorderType.RRect,
          dashPattern: const [10, 10],
          strokeWidth: 2,
          color: Colors.blue,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_present_rounded,
                      color: Colors.grey,
                      size: 100,
                    ),
                    Text(
                      ' فایل مورد نظر را در اینجا اضافه کنید',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 15,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children:
                      selectedFileList
                              .map(
                                (item) => InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          alignment: Alignment.center,
                                          content: Container(
                                            width: 80,
                                            height: 90,
                                            margin: const EdgeInsets.all(8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    width: 90,
                                                    height: 90,
                                                    child: const Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          Icons.delete_forever,
                                                          color: Colors.red,
                                                          size: 32,
                                                        ),
                                                        Text('حذف'),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    selectedFileList.removeAt(
                                                      selectedFileList.indexOf(item),
                                                    );
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                    MySnackBar(
                                                      context: context,
                                                      message: 'حذف شد!',
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ); //remove
                                      },
                                    );
                                  },
                                  child: Container(
                                    // padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                      child: Icon(Icons.file_present, size: 60,),
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }

/*
class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
    required this.initials,
  });
  final String initials;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundColor: kPrimaryColor,
              radius: 44,
              foregroundImage: _image != null ? FileImage(_image!) : null,
              child: Text(
                widget.initials,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () async {
            final files = await imageHelper.fromGallery();
            if (files.isNotEmpty) {
              final croppedFile = await imageHelper.crop(
                file: files.first,
                cropStyle: CropStyle.circle,
              );
              if (croppedFile != null) {
                setState(() => _image = File(croppedFile.path));
              }
            }
          },
          child: const Text('Select Photo'),
        ),
      ],
    );
  }
}

class MultipleImages extends StatefulWidget {
  const MultipleImages({super.key});

  @override
  State<MultipleImages> createState() => _MultipleImagesState();
}

class _MultipleImagesState extends State<MultipleImages> {
  List<File> _images = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: _images
              .map(
                (e) => Image.file(
                  e,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () async {
            final files = await imageHelper.fromGallery(multiple: true);
            setState(
              () => _images.addAll(files.map((e) => File(e.path)).toList()),
            );

            // final files = await imageHelper.fromGallery();
            // if (files.isNotEmpty) {
            //   final croppedFile = await imageHelper.crop(
            //     file: files.first,
            //     cropStyle: CropStyle.circle,
            //   );
            //   if (croppedFile != null) {
            //     setState(() => _image = File(croppedFile.path));
            //   }
            // }
          },
          child: const Text('Select Multiple Photos'),
        ),
      ],
    );
  }
}

 */
