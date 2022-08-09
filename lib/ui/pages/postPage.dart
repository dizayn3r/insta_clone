import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/auth/reference/user_data_reference.dart';
import 'package:insta_clone/ui/color.dart';
import 'package:insta_clone/ui/pages/addPostPage.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String? uid;

  @override
  void initState() {
    getUID();
    super.initState();
  }

  Future getUID() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
  }



  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double w = sizingInformation.screenSize.shortestSide / 100;
        return SafeArea(
          child: Scaffold(

            body: StreamBuilder(
                stream: UserDataReference()
                    .userData()
                    .doc(uid)
                    .collection("posts")
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.length == 0) {
                      return Center(
                        child: Text(
                          'No post..',
                          style: TextStyle(
                            color: textColor,
                            fontSize: w * 5,
                          ),
                        ),
                      );
                    }
                    int length = snapshot.data!.docs.length;
                    return ListView.builder(
                      itemCount: length,
                      padding: EdgeInsets.all(w * 4),
                      itemBuilder: (BuildContext context, int index) {
                        String imageUrl =
                            snapshot.data!.docs[index]['imageUrl'];
                        String caption = snapshot.data!.docs[index]['caption'];
                        return postCard(
                          imageUrl: imageUrl,
                          caption: caption,
                          width: w,
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Loading',
                        style: TextStyle(
                          color: textColor,
                          fontSize: w * 5,
                        ),
                      ),
                    );
                  }
                }),
          ),
        );
      },
    );
  }

  Widget postCard(
          {required String imageUrl,
          required String caption,
          required double width}) =>
      Card(
        child: Padding(
          padding: EdgeInsets.all(width * 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                    // height: width * 40,
                    // width: width * 100,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                      offset: Offset(0, width * 12),
                      onSelected: (value) {},
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.edit_rounded),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: width * 3.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.delete_forever_rounded),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: width * 3.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: width * 2),
                alignment: Alignment.topLeft,
                child: Text(
                  caption,
                  style: TextStyle(
                    fontSize: width * 4,
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
