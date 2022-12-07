import 'package:flutter/material.dart';
import 'package:social/activity_detail.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/http/api.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/http/models/generic_response.dart';

import 'package:social/register.dart';
import 'package:social/utils/disk_resources.dart';
import 'package:social/utils/helper.dart';
import 'package:social/utils/logic_support.dart';

class JoinedActivity extends StatelessWidget {
  final int id;
  const JoinedActivity({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: const Text('Joined Activities'),
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
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: customeBackground(),
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<GenericResponse<List<AllActivityResponse>>>(
        future: Api().getJoinedActivities(widget.id),
        builder: (context, projectSnap) {
          return LogicSupport.isSuccessToProceed(projectSnap)
              ? ListView.builder(
                  itemCount: projectSnap.data?.response?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          image: DecorationImage(
                            image: Helper.getImageByCategory(
                                projectSnap.data!.response![index].category!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          projectSnap.data!.response![index].title!,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        ),
                      ),
                      onTap: () {
                        if (!DiskResources.getBool("isMuteOn")) {
                          Feedback.forTap(context);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityDetail(
                                id: projectSnap.data!.response![index].id!),
                          ),
                        );
                      },
                    );
                  },
                )
              : LogicSupport.isFailToProceed(projectSnap)
                  ? CustomePopup(
                      title: 'Fail',
                      message: projectSnap.data!.error!,
                      onPressed: () {
                        if (!DiskResources.getBool("isMuteOn")) {
                          Feedback.forTap(context);
                        }
                        Navigator.pop(context);
                      })
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
        },
      ),
    );
  }
}
