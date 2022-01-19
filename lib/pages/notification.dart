import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:KollNet/components/notification_stream_wrapper.dart';
import 'package:KollNet/models/notification.dart';
import 'package:KollNet/utils/firebase.dart';
import 'package:KollNet/widgets/notification_items.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(('Collage Events'),
            style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () => deleteAllItems(),
              child: Text(
                'CLEAR',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xfff84646),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          getActivities(),
        ],
      ),
    );
  }

  getActivities() {
    return ActivityStreamWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      stream: notificationRef
          .doc(currentUserId())
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots(),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        ActivityModel activities = ActivityModel.fromJson(snapshot.data());
        return ActivityItems(
          activity: activities,
        );
      },
    );
  }

  deleteAllItems() async {
//delete all notifications associated with the authenticated user
    QuerySnapshot notificationsSnap = await notificationRef
        .doc(firebaseAuth.currentUser.uid)
        .collection('notifications')
        .get();
    notificationsSnap.docs.forEach(
      (doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      },
    );
  }
}
