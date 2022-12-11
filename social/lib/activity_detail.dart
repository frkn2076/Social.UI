import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_info_text.dart';
import 'package:social/custome_widgets/custome_joiner_textbutton.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/http/models/activity_detail_response.dart';
import 'package:social/http/models/generic_response.dart';
import 'package:social/private_profile.dart';
import 'package:social/dashboard.dart';
import 'package:social/public_profile.dart';
import 'package:social/utils/condition.dart';
import 'package:social/utils/disk_resources.dart';
import 'package:social/utils/helper.dart';
import 'package:social/http/api.dart';
import 'package:social/utils/holder.dart';
import 'package:social/utils/localization_resources.dart';
import 'package:social/utils/logic_support.dart';

class ActivityDetail extends StatelessWidget {
  final int id;
  const ActivityDetail({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: const Text('Detail'),
        centerTitle: true,
      ),
      body: MyStatefulWidget(id: id),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final int id;
  const MyStatefulWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  var _condition = Condition.none;
  var _isJoined = false;

  String _errorMessage = LocalizationResources.somethingWentWrongError;

  @override
  Widget build(BuildContext context) {
    return _condition == Condition.success
        ? CustomePopup(
            title: 'Success',
            message: LocalizationResources.youJoinedActivitySuccessfully,
            onPressed: () {
              setState(() => _condition = Condition.none);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            })
        : _condition == Condition.fail
            ? CustomePopup(
                title: 'Fail',
                message: _errorMessage,
                onPressed: () {
                  if (!DiskResources.getBool("isMuteOn")) {
                    Feedback.forTap(context);
                  }
                  setState(() => _condition = Condition.none);
                })
            : Container(
                decoration: customeBackground(),
                padding: const EdgeInsets.all(10),
                child: FutureBuilder<GenericResponse<ActivityDetailResponse>>(
                  future: Api().getActivityDetail(widget.id),
                  builder: (context, projectSnap) {
                    return LogicSupport.isSuccessToProceed(projectSnap)
                        ? ListView(
                            children: <Widget>[
                              Container(
                                  height: Holder.height * 0.05,
                                  width: Holder.width * 0.1,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blueAccent),
                                    image: DecorationImage(
                                      image: Helper.getImageByCategory(
                                          projectSnap
                                              .data!.response!.category!),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(15.0),
                                child: Text(
                                  projectSnap.data!.response!.title!,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(15.0),
                                child: Text(
                                  projectSnap.data!.response!.detail!,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                              ),
                              CustomeInfoText(
                                  title: "Date:",
                                  text: Helper.formatDateTime(
                                      projectSnap.data!.response!.date!)),
                              CustomeInfoText(
                                  title: "Location:",
                                  text: projectSnap.data!.response!.location!),
                              CustomeInfoText(
                                  title: "PhoneNumber:",
                                  text: projectSnap.data!.response!.joiners!
                                          .map((x) => x.id)
                                          .contains(Holder.userId!)
                                      ? projectSnap.data!.response!.phoneNumber!
                                      : '(xxx)xxx-xx-xx'),
                              CustomeInfoText(
                                  title: "Capacity:",
                                  text: projectSnap.data!.response!.capacity!
                                      .toString()),
                              projectSnap.data?.response?.joiners?.isEmpty ??
                                      true
                                  ? Container()
                                  : Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          child: const Text(
                                            'JOINERS',
                                            style: TextStyle(fontSize: 22),
                                          ),
                                        ),
                                        Container(
                                          width: Holder.width * 0.8,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          margin: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: projectSnap
                                                .data!.response!.joiners!
                                                .map(
                                              (joiner) {
                                                bool isPrivate = joiner.id! ==
                                                    projectSnap.data!.response!
                                                        .userId!;
                                                if (isPrivate) {
                                                  _isJoined = true;
                                                }
                                                return CustomeJoinerTextButton(
                                                  isPrivate: isPrivate,
                                                  userName: joiner.userName!,
                                                  onTap: () {
                                                    if (!DiskResources.getBool(
                                                        "isMuteOn")) {
                                                      Feedback.forTap(context);
                                                    }
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            isPrivate
                                                                ? const PrivateProfile()
                                                                : PublicProfile(
                                                                    id: joiner
                                                                        .id!),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        )
                                      ],
                                    ),
                              Container(
                                alignment: Alignment.topCenter,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 30),
                                margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: _isJoined
                                          ? Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(LocalizationResources
                                                  .youAlreadyJoinedTheActivity),
                                            )
                                          : projectSnap.data!.response!.joiners!
                                                      .length >=
                                                  projectSnap
                                                      .data!.response!.capacity!
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(LocalizationResources
                                                      .noSpaceForTheActivity),
                                                )
                                              : TextButton(
                                                  child: const Text("Join"),
                                                  onPressed: () {
                                                    if (DiskResources.getBool(
                                                        "isMuteOn")) {
                                                      Feedback.forTap(context);
                                                    }
                                                    Api()
                                                        .joinActivity(widget.id)
                                                        .then(
                                                          (response) =>
                                                              setState(
                                                            () {
                                                              _condition = response
                                                                  .isSuccessful!
                                                                  .conditionParser();
                                                              if (response
                                                                      .isSuccessful !=
                                                                  true) {
                                                                _errorMessage =
                                                                    response
                                                                        .error!;
                                                              }
                                                            },
                                                          ),
                                                        );
                                                  },
                                                ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : LogicSupport.isFailToProceed(projectSnap)
                            ? CustomePopup(
                                title: 'Fail',
                                message: projectSnap.data!.error!,
                                onPressed: () {
                                  if (!DiskResources.getBool("isMuteOn")) {
                                    Feedback.forTap(context);
                                  }
                                })
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                  },
                ),
              );
  }
}
