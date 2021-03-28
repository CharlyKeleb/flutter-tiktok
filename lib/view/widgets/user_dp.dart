import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/models/user.dart';
import 'package:flutter_tiktok/utils/firebase/firebase.dart';

class UserDp extends StatelessWidget {
  final String userId;

  const UserDp({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersRef.doc(userId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          UserModel user = UserModel.fromJson(snapshot.data.data());
          return Container(
            height: 60.0,
            width: 60.0,
            child: Stack(
              children: [
                Positioned(
                  left: (60 / 2) - (50 / 2),
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image(
                        image: NetworkImage(
                          user.photoUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 3.0,
                  left: (60 / 2) - (20 / 2),
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: Icon(Icons.add, size: 18.0),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
