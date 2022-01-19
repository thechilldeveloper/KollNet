import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:KollNet/models/user.dart';
import 'package:KollNet/services/services.dart';
import 'package:KollNet/utils/firebase.dart';

class UserService extends Service {
  //get the authenticated uis
  String currentUid() {
    return firebaseAuth.currentUser.uid;
  }

//tells when the user is online or not and updates the last seen for the messages
  setUserStatus(bool isOnline) {
    var user = firebaseAuth.currentUser;
    if (user != null) {
      usersRef
          .doc(user.uid)
          .update({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }

//updates user profile in the Edit Profile Screen
  updateProfile(
      {File image, String username, String bio, String country, String skill}) async {
    DocumentSnapshot doc = await usersRef.doc(currentUid()).get();
    var users = UserModel.fromJson(doc.data());
    users?.username = username;
    users?.bio = bio;
    users?.country = country;
    users?.skill = skill;
    if (image != null) {
      users?.photoUrl = await uploadImage(profilePic, image);
    }
    await usersRef.doc(currentUid()).update({
      'username': username,
      'bio': bio,
      'country': country,
      'skill': skill,
      "photoUrl": users?.photoUrl ?? '',
    });

    return true;
  }
}
