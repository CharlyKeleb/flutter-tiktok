import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/models/comments.dart';
import 'package:flutter_tiktok/utils/firebase/firebase.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatelessWidget {
  final CommentModel comments;
  final String postId;
  const CommentItem({Key key, this.comments, this.postId}) : super(key: key);

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.red,
            backgroundImage: NetworkImage(comments?.userDp),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comments?.username,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.black),
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comments?.comment,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    timeago.format(comments.timestamp.toDate()),
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildLikeButton(postId),
                  StreamBuilder(
                    stream: commentLikeRef
                        .where('postId', isEqualTo: postId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot snap = snapshot.data;
                        List<DocumentSnapshot> docs = snap.docs;
                        return buildLikesCount(
                            context, docs?.length ?? 0);
                      } else {
                        return buildLikesCount(context, 0);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildLikeButton(String postId) {
    return StreamBuilder(
      stream: commentLikeRef
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: currentUserId())
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> docs = snapshot?.data?.docs ?? [];

          return GestureDetector(
            onTap: () {
              if (docs.isEmpty) {
                commentLikeRef.add({
                  'userId': currentUserId(),
                  'postId': postId,
                  'dateCreated': Timestamp.now(),
                });
              } else {
                commentLikeRef.doc(docs[0].id).delete();
              }
            },
            child: docs.isEmpty
                ? Icon(
                    Icons.favorite,
                    color: Colors.grey,
                    size: 20.0,
                  )
                : Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20.0,
                  ),
          );
        }
        return Container();
      },
    );
  }

  buildLikesCount(BuildContext context, int count) {
    return Text('$count');
  }
}
