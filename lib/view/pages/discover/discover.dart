import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tiktok/models/user.dart';
import 'package:flutter_tiktok/view/pages/me/me.dart';
import 'package:flutter_tiktok/view_model/search/search_view_model.dart';
import 'package:flutter_tiktok/view_model/user/user_view_model.dart';
import 'package:provider/provider.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchViewModel>(context, listen: false).getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (BuildContext context, viewModel, Widget child) {
        return Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.arrow_back),
            title: buildSearchBar(viewModel),
            actions: [
              Center(
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Container(width: 15),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Flexible(
                  child: buildList(viewModel),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  buildSearchBar(SearchViewModel viewModel) {
    return Container(
      height: 40.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(color: Colors.grey[200]),
        boxShadow: [
          BoxShadow(
            blurRadius: 60.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 16.0),
            color: Color(0xff4E4F72).withOpacity(0.08),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: TextField(
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.center,
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 8.0),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
            ),
            hintText: "Search a user",
            border: InputBorder.none,
            icon: Icon(
              Feather.search,
              size: 15.0,
              color: Colors.black,
            ),
            suffixIcon: Icon(Feather.x, size: 15.0, color: Colors.black),
          ),
          onChanged: (query) {
            viewModel.search(query);
          },
        ),
      ),
    );
  }

  buildList(SearchViewModel viewModel) {
    var currentUser = Provider.of<UserViewModel>(context, listen: false).user;
    if (!viewModel.loading) {
      if (viewModel.filteredUsers.isEmpty) {
        return Center(child: Text("No users found"));
      } else {
        return ListView.builder(
          itemCount: viewModel.filteredUsers.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = viewModel.filteredUsers[index];
            UserModel user = UserModel.fromJson(doc.data());
            if (doc.id == currentUser?.uid) {
              Timer(Duration(microseconds: 300), () {
                viewModel.removeFromList(index);
              });
            }
            return InkWell(
              onTap: () => showUserProfile(context, profileId: user?.id),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: [
                    Icon(Feather.search, size: 15.0),
                    SizedBox(width: 3.0),
                    Text(
                      user?.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(user?.photoUrl),
                    ),
                    SizedBox(width: 5.0),
                    // Icon(CupertinoIcons.arrow_up_left, size: 15.0),
                    Icon(Icons.arrow_upward, size: 15.0),
                  ],
                ),
              ),
            );
          },
        );
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  showUserProfile(BuildContext context, {String profileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Me(profileId: profileId),
      ),
    );
  }
}
