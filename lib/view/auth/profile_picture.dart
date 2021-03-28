import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tiktok/view_model/profile/profileVM.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class UploadDP extends StatefulWidget {
  @override
  _UploadDPState createState() => _UploadDPState();
}

class _UploadDPState extends State<UploadDP> {
  @override
  Widget build(BuildContext context) {
    ProfileViewModel viewModel = Provider.of<ProfileViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        viewModel.resetPost();
        return true;
      },
      child: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(),
        inAsyncCall: viewModel.loading,
        child: Scaffold(
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            title: Text('Upload your Profile Photo'),
            centerTitle: true,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            children: [
              InkWell(
                onTap: () => showImageChoices(context, viewModel),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(),
                  child: viewModel.imgLink != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(viewModel.imgLink),
                        )
                      : viewModel.mediaUrl == null
                          ? Center(
                              child: CircleAvatar(
                                radius: 100.0,
                                child: Icon(
                                  Icons.camera,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(
                                viewModel.mediaUrl,
                              ),
                            ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 40.0,
                width: 140.0,
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'done'.toUpperCase(),
                    ),
                  ),
                  onPressed: () => viewModel.uploadProfilePicture(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showImageChoices(BuildContext context, ProfileViewModel viewModel) {
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
                  'Select'.toUpperCase(),
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
