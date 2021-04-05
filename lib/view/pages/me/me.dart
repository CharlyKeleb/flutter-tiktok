import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/components/stream_grid_videps.dart';
import 'package:flutter_tiktok/models/post.dart';
import 'package:flutter_tiktok/models/user.dart';
import 'package:flutter_tiktok/utils/firebase/firebase.dart';
import 'package:flutter_tiktok/view/widgets/grid_tile.dart';

class Me extends StatefulWidget {
  final profileId;

  const Me({this.profileId});

  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  bool isFollowing = false;
  UserModel users;

  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  final DateTime timestamp = DateTime.now();

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  currentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back),
        title: StreamBuilder(
          stream: usersRef.doc(widget.profileId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: Text('No Username'));
            UserModel user = UserModel.fromJson(snapshot.data.data());
            return Text(user?.username);
          },
        ),
        actions: [
          Padding(padding: EdgeInsets.all(10.0), child: Icon(Icons.more_vert)),
        ],
      ),
      body: StreamBuilder(
        stream: usersRef.doc(widget.profileId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          UserModel user = UserModel.fromJson(snapshot.data.data());
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(user?.photoUrl),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    '@${user.username}'.toLowerCase(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          StreamBuilder(
                            stream: followingRef
                                .doc(widget.profileId)
                                .collection('userFollowing')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot snap = snapshot.data;
                                List<DocumentSnapshot> docs = snap.docs;
                                return Text(
                                  docs?.length.toString() ?? 0.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                );
                              } else {
                                return Text(
                                  0.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                );
                              }
                            },
                          ),
                          Text(
                            'Following',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 10.0),
                          ),
                        ],
                      ),
                      Container(
                          height: 20.0, width: 5.0, child: VerticalDivider()),
                      Column(
                        children: [
                          StreamBuilder(
                            stream: followerRef
                                .doc(widget.profileId)
                                .collection('userFollowers')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot snap = snapshot.data;
                                List<DocumentSnapshot> docs = snap.docs;

                                return Text(
                                  docs?.length.toString() ?? 0.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                );
                              } else {
                                return Text(
                                  0.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                );
                              }
                            },
                          ),
                          Text(
                            'Followers',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 10.0),
                          ),
                        ],
                      ),
                      Container(
                          height: 20.0, width: 5.0, child: VerticalDivider()),
                      Column(
                        children: [
                          StreamBuilder(
                            stream: likeRef
                                .where('userId', isEqualTo: currentUserId())
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot snap = snapshot.data;
                                List<DocumentSnapshot> docs = snap.docs;
                                return Text(
                                  docs?.length.toString() ?? 0.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                );
                              } else {
                                return Text(
                                  0.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                );
                              }
                            },
                          ),
                          Text(
                            'Likes',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 10.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  buildButtonLabel(user),
                  SizedBox(height: 20.0),
                  Container(
                    width: 200.0,
                    child: Text(
                      'Official ${user?.username} TikTok | New new coming soon 😊😊',
                      maxLines: null,
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 5.0),
                  buildGridPost(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  unfollowUser() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data());
    setState(() {
      isFollowing = false;
    });
    //remove follower
    followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //remove following
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  followUser() async {
    //gets the current user profile
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data());
    setState(() {
      isFollowing = true;
    });

    //updates the followers collection of the followed user
    followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .set({
      "userId": currentUserId(),
    });

    //updates the following collection of the currentUser
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({
      "userId": widget.profileId,
    });
  }

  buildButtonLabel(user) {
    //if isMe then display "edit profile"
    bool isMe = widget.profileId == currentUserId();

    if (isMe) {
      return buildHandlerButton(
        "Edit Profile",
        () {},
      );

      //if you are already following the user then "unfollow"
    } else if (isFollowing) {
      return buildHandlerButton(
        "Unfollow",
        unfollowUser,
      );
      //if you are not following the user then "follow"
    } else if (!isFollowing) {
      return buildHandlerButton(
        "Follow",
        followUser,
      );
    }
  }

  buildHandlerButton(String label, Function function) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 45.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Theme.of(context).accentColor,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  buildGridPost() {
    return StreamGridWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      stream: postRef
          .where('ownerId', isEqualTo: widget.profileId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        PostModel video = PostModel.fromJson(snapshot.data());
        return PostTile(videos: video);
      },
    );
  }
}
