import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/auth/reference/user_data_reference.dart';
import 'package:insta_clone/ui/color.dart';
import 'package:insta_clone/ui/pages/homePage.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddPost extends StatefulWidget {
  final String? userId;
  const AddPost({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? _image;
  final imagePicker = ImagePicker();
  String? imageUrl;
  final TextEditingController _captionController = TextEditingController();

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getFromGallery(context) async {
    final picker = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (picker != null) {
        _image = File(picker.path);
      } else {
        showSnackBar("No File selected", const Duration(milliseconds: 400));
      }
    });
    Navigator.of(context).pop();
  }

  getFromCamera(context) async {
    final picker = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (picker != null) {
        _image = File(picker.path);
      } else {
        showSnackBar("No File selected", const Duration(milliseconds: 400));
      }
    });
    Navigator.of(context).pop();
  }

  Future addPost(
      {required File image,
      required String caption,
      required double w,
      required double h}) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("${widget.userId}/posts")
        .child("post_$imgId");

    await reference.putFile(image);
    imageUrl = await reference.getDownloadURL();

    await UserDataReference()
        .userData()
        .doc(widget.userId)
        .collection("posts")
        .add({"imageUrl": imageUrl, "caption": caption}).whenComplete(
      () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 4)),
                child: Container(
                  height: h * 40,
                  width: w * 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 4),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(w * 4),
                              topRight: Radius.circular(w * 4),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: w * 20,
                                width: w * 20,
                                margin: EdgeInsets.only(bottom: w * 5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.check_rounded, size: w * 10),
                              ),
                              const Text(
                                'Successfully Posted',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        ),
                        child: Container(
                          height: w * 15,
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            horizontal: w * 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(w * 1.5),
                          ),
                          child: Text(
                            'Okay',
                            style: TextStyle(
                                color: Colors.grey.shade900, fontSize: w * 4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double w = sizingInformation.screenSize.shortestSide / 100;
        double h = sizingInformation.screenSize.longestSide / 100;
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(w * 4),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(w * 2),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: textColor),
                      borderRadius: BorderRadius.circular(w * 4),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      padding: EdgeInsets.all(w * 4),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Choose a method to select',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontSize: w * 4),
                                            ),
                                          ),
                                          SizedBox(height: w * 2),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () => getFromCamera(context),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                    EdgeInsets.all(w * 3),
                                                    decoration: BoxDecoration(
                                                      color: primary,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          w * 2),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          color: onPrimary,
                                                        ),
                                                        SizedBox(width: w * 2),
                                                        Text(
                                                          'Camera',
                                                          style: TextStyle(
                                                              color:
                                                              onPrimary,
                                                              fontSize: w * 4),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: w * 2),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () => getFromGallery(context),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                    EdgeInsets.all(w * 3),
                                                    decoration: BoxDecoration(
                                                      color: primary,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          w * 2),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Icon(
                                                          Icons.image_outlined,
                                                          color: onPrimary,
                                                        ),
                                                        SizedBox(width: w * 2),
                                                        Text(
                                                          'Gallery',
                                                          style: TextStyle(
                                                              color:
                                                              onPrimary,
                                                              fontSize: w * 4),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            height: w * 15,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: w * 3),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(w * 2),
                            ),
                            child: Text(
                              'Choose Image',
                              style:
                                  TextStyle(color: onPrimary, fontSize: w * 5),
                            ),
                          ),
                        ),
                        SizedBox(height: w * 2),
                        Container(

                          child: _image == null
                              ? const Center(
                                  child: Text("No image selected"),
                                )
                              : Image.file(_image!),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: w * 4),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade900),
                      borderRadius: BorderRadius.circular(w * 1.5),
                    ),
                    child: TextField(
                      controller: _captionController,
                      minLines: 1,
                      maxLines: 10,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Write a caption',
                        contentPadding: EdgeInsets.fromLTRB(
                          w * 5,
                          w * 4,
                          w * 5,
                          w * 4,
                        ),
                      ),
                      onSubmitted: (value) {
                        _captionController.text = value;
                      },
                    ),
                  ),
                  SizedBox(height: w * 6),
                  GestureDetector(
                    onTap: () {
                      if (_image != null) {
                        addPost(
                          image: _image!,
                          caption: _captionController.text,
                          h: h,
                          w: w,
                        );
                      } else {
                        showSnackBar("No image selected",
                            const Duration(milliseconds: 400));
                      }
                    },
                    child: Container(
                      height: w * 15,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(w * 1.5),
                      ),
                      child: Text(
                        'Submit Post',
                        style: TextStyle(color: onPrimary, fontSize: w * 5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
