import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tiktok/utils/firebase/firebase.dart';
import 'package:flutter_tiktok/view/pages/discover/discover.dart';
import 'package:flutter_tiktok/view/pages/home/home.dart';
import 'package:flutter_tiktok/view/pages/inbox/inbox.dart';
import 'package:flutter_tiktok/view/pages/me/me.dart';
import 'package:flutter_tiktok/view/screens/create_post.dart';

import 'package:flutter_tiktok/view_model/post/create_post_view_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          Home(),
          Discover(),
          Text(''),
          Inbox(),
          Me(profileId: firebaseAuth.currentUser.uid),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Theme.of(context).textTheme.headline6.color,
        elevation: 20,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Feather.search,
              size: 30.0,
            ),
            label: "Discover",
          ),
          BottomNavigationBarItem(
            icon: tiktokIcon(context, viewModel),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Feather.message_square,
            ),
            label: "Inbox",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Feather.user,
            ),
            label: "Me",
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  tiktokIcon(BuildContext context, PostsViewModel viewModel) {
    return GestureDetector(
      onTap: () => chooseUpload(context, viewModel),
      child: Container(
        height: 27.0,
        width: 45.0,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.0),
              width: 38.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 45, 108),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10.0),
              width: 38.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 32, 211, 234),
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
            Center(
              child: Container(
                height: double.infinity,
                width: 38.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Icon(
                  Icons.add,
                  size: 20.0,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  chooseUpload(BuildContext context, PostsViewModel viewModel) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    'Upload a video',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  size: 25.0,
                ),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  viewModel.pickVideo(camera: true);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  size: 25.0,
                ),
                title: Text('Gallery'),
                onTap: () async {
                  await viewModel.pickVideo();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreatePost(
                        vid: viewModel.mediaUrl,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
