import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:KollNet/components/custom_image.dart';
import 'package:KollNet/models/user.dart';
import 'package:KollNet/utils/firebase.dart';
import 'package:KollNet/view_models/auth/posts_view_model.dart';
import 'package:KollNet/widgets/indicators.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  @override
  Widget build(BuildContext context) {
    currentUserId() {
      return firebaseAuth.currentUser.uid;
    }

    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        await viewModel.resetPost();
        return true;
      },
      child: ModalProgressHUD(
        progressIndicator: circularProgress(context),
        inAsyncCall: viewModel.loading,
        child: Scaffold(
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Feather.x),
              onPressed: () {
                viewModel.resetPost();
                Navigator.pop(context);
              },
            ),
            title: Text('KollNet collage event'),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () async {
                  await viewModel.uploadPosts(context);
                  Navigator.pop(context);
                  viewModel.resetPost();
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Host a Event'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Color(0xfff84646),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            children: [
              SizedBox(height: 15.0),
              StreamBuilder(
                stream: usersRef.doc(currentUserId()).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromJson(snapshot.data.data());
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(user?.photoUrl),
                      ),
                      title: Text(
                        user?.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        user?.email,
                      ),
                    );
                  }
                  return Container();
                },
              ),
              InkWell(
                onTap: () => showImageChoices(context, viewModel),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    border: Border.all(
                      color: Color(0xfff84646),
                    ),
                  ),
                  child: viewModel.imgLink != null
                      ? CustomImage(
                          imageUrl: viewModel.imgLink,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width - 30,
                          fit: BoxFit.cover,
                        )
                      : viewModel.mediaUrl == null
                          ? Center(
                              child: Text(
                                'Upload a Event Flyer ',
                                style: TextStyle(
                                  color: Color(0xfff84646),
                                ),
                              ),
                            )
                          : Image.file(
                              viewModel.mediaUrl,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width - 30,
                              fit: BoxFit.cover,
                            ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Link for the Event'.toUpperCase(),
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                initialValue: viewModel.description,
                decoration: InputDecoration(
                  hintText: 'Eg. This is very beautiful place!',
                  focusedBorder: UnderlineInputBorder(),
                ),
                maxLines: null,
                onChanged: (val) => viewModel.setDescription(val),
              ),
              SizedBox(height: 20.0),
              Text(
                'Location'.toUpperCase(),
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0.0),
                title: Container(
                  width: 250.0,
                  child: TextFormField(
                    controller: viewModel.locationTEC,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0.0),
                      hintText: 'Amaravati,India!',
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    maxLines: null,
                    onChanged: (val) => viewModel.setLocation(val),
                  ),
                ),
                trailing: IconButton(
                  tooltip: "Use your current location",
                  icon: Icon(
                    CupertinoIcons.map_pin_ellipse,
                    size: 25.0,
                  ),
                  iconSize: 30.0,
                  color: Color(0xfff84646),
                  onPressed: () => viewModel.getLocation(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showImageChoices(BuildContext context, PostsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
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
                child: Text(
                  'Select Image',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Feather.camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(camera: true);
                },
              ),
              ListTile(
                leading: Icon(Feather.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
