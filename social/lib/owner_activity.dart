import 'package:flutter/material.dart';
import 'package:social/activity_detail.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/http/api.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/register.dart';

class OwnerActivity extends StatelessWidget {
  final int id;
  const OwnerActivity({Key? key, required this.id}) : super(key: key);

  static const String _title = 'Created Activities';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: const Text(_title),
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
      child: FutureBuilder<List<AllActivityResponse>>(
        future: Api().getOwnerActivities(widget.id),
        builder: (context, projectSnap) {
          return projectSnap.connectionState == ConnectionState.done
              ? ListView.builder(
                  itemCount: projectSnap.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        )
                      },
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/ada.jpeg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(
                            projectSnap.data![index].title!,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActivityDetail(
                                    id: projectSnap.data![index].id!)),
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
