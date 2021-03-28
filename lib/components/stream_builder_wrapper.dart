import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget Function(
  BuildContext context,
  DocumentSnapshot doc,
);

class StreamBuilderWrapper extends StatelessWidget {
  final Stream<dynamic> stream;
  final ItemBuilder<DocumentSnapshot> itemBuilder;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final EdgeInsets padding;

  const StreamBuilderWrapper({
    Key key,
    @required this.stream,
    @required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics = const ClampingScrollPhysics(),
    this.padding = const EdgeInsets.only(bottom: 2.0, left: 2.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var list = snapshot.data.documents.toList();
          return list.length == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Container(
                    height: 60.0,
                    width: 100.0,
                    child: Center(
                      child: Text('No Posts'),
                    ),
                  ),
                )
              : PageView.builder(
                  itemCount: snapshot.data.docs.length,
                  controller: PageController(
                    viewportFraction: 1,
                    initialPage: 0,
                  ),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return itemBuilder(context, list[index]);
                  },
                );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
