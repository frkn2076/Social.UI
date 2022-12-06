import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_focused_textfield.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/http/models/generic_response.dart';
import 'package:social/http/models/private_profile_response.dart';
import 'package:social/owner_activity.dart';
import 'package:social/joined_activity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/http/api.dart';
import 'package:social/utils/condition.dart';
import 'package:social/utils/helper.dart';
import 'package:social/utils/holder.dart';
import 'package:social/utils/localization_resources.dart';
import 'package:social/utils/logic_support.dart';

class PrivateProfile extends StatelessWidget {
  const PrivateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: Text(Holder.userName!),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.nordic_walking_outlined),
              tooltip: 'Joined Ones',
              onPressed: () {
                if (Holder.userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinedActivity(id: Holder.userId!),
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.supervised_user_circle_outlined),
              tooltip: "Created Ones",
              onPressed: () {
                if (Holder.userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OwnerActivity(id: Holder.userId!),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  Condition _condition = Condition.none;
  String? _photo;
  Image? _image;

  String _errorMessage = LocalizationResources.somethingWentWrongError;

  @override
  Widget build(BuildContext context) {
    return _condition == Condition.success
        ? CustomePopup(
            title: 'Success',
            message: LocalizationResources.profileUpdatedSuccessfully,
            onPressed: () => setState(() => _condition = Condition.none))
        : _condition == Condition.fail
            ? CustomePopup(
                title: 'Fail',
                message: _errorMessage,
                onPressed: () => setState(() => _condition = Condition.none))
            : FutureBuilder<GenericResponse<PrivateProfileResponse>>(
                future: Api().getPrivateProfile(),
                builder: (context, projectSnap) {
                  if (LogicSupport.isSuccessToProceed(projectSnap)) {
                    if (projectSnap.data?.response?.name?.isNotEmpty ?? false) {
                      _nameController.text = projectSnap.data!.response!.name!;
                    }
                    if (projectSnap.data?.response?.about?.isNotEmpty ??
                        false) {
                      _aboutController.text =
                          projectSnap.data!.response!.about!;
                    }
                    if (projectSnap.data?.response?.photo?.isNotEmpty ??
                        false) {
                      _image = Helper.imageFromBase64String(
                          projectSnap.data!.response!.photo!);
                    }
                    return Container(
                      decoration: customeBackground(),
                      child: ListView(
                        children: <Widget>[
                          Stack(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.fromLTRB(
                                    100.0, 20.0, 100.0, 0),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                ),
                                child: _image ??
                                    const Image(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          'assets/images/empty_profile.jpg'),
                                    ),
                              ),
                              Positioned(
                                right: 100.0,
                                bottom: 0.0,
                                child: IconButton(
                                  // ignore: prefer_const_constructors
                                  icon: Icon(
                                    size: 40,
                                    Icons.add_circle_outline,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    var pickedFile = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    if (pickedFile?.path != null) {
                                      setState(() {
                                        _photo = Helper.base64StringFromImage(
                                            pickedFile!.path);
                                        File? pickedImage =
                                            File(pickedFile.path);
                                        _image = Image.file(pickedImage);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          CustomeFocusedTextField(
                            padding: const EdgeInsets.fromLTRB(20, 50, 150, 0),
                            labelText: 'Name & Surname',
                            controller: _nameController,
                          ),
                          CustomeFocusedTextField(
                            labelText: 'About me',
                            controller: _aboutController,
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    //this enable feedback helps to turn off the sound on click
                                    enableFeedback: false,
                                  ),
                                  child: const Text("Save"),
                                  onPressed: () => {
                                    Api()
                                        .updatePrivateProfile(
                                            _photo,
                                            _nameController.text,
                                            _aboutController.text)
                                        .then(
                                      (response) {
                                        setState(() {
                                          _condition = response.isSuccessful!
                                              .conditionParser();
                                          if (response.isSuccessful != true) {
                                            _errorMessage = response.error!;
                                          }
                                        });
                                      },
                                    )
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (LogicSupport.isFailToProceed(projectSnap)) {
                    return CustomePopup(
                      title: 'Fail',
                      message: projectSnap.data!.error!,
                      onPressed: () => setState(
                        () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
  }
}
