import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/login.dart';
import 'package:social/utils/disk_resources.dart';
import 'package:social/utils/localization_resources.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _showPopupMessage = false;
  final List<String> _languages = ['Türkçe', 'English'];
  String _currentLanguage = 'Türkçe';
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: Text(LocalizationResources.settings),
        centerTitle: true,
      ),
      body: _showPopupMessage
          ? AlertDialog(
              backgroundColor: const Color.fromARGB(255, 198, 131, 210),
              title: Text(LocalizationResources.info),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(LocalizationResources.areYouSureToExit),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(LocalizationResources.no),
                  onPressed: () => setState(() => _showPopupMessage = false),
                ),
                TextButton(
                  child: Text(LocalizationResources.yes),
                  onPressed: () {
                    DiskResources.removeAll();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                )
              ],
            )
          : Container(
              decoration: customeBackground(),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.15,
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: LocalizationResources.language,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: DropdownButton<String>(
                              dropdownColor:
                                  const Color.fromARGB(255, 167, 143, 234),
                              isExpanded: true,
                              value: _currentLanguage,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? value) {
                                if(value?.isNotEmpty ?? false){
                                  DiskResources.setOrUpdateString('language', value!);
                                  LocalizationResources.updateResources();
                                  setState(() => _currentLanguage = value);
                                }
                              },
                              items: _languages.map(
                                (language) {
                                  return DropdownMenuItem<String>(
                                    value: language,
                                    child: Text(language),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  // will be uncommented later
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         constraints: BoxConstraints(
                  //           maxHeight:
                  //               MediaQuery.of(context).size.height * 0.15,
                  //         ),
                  //         padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  //         child: InputDecorator(
                  //           decoration: InputDecoration(
                  //             labelText: 'Mute',
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(12.0),
                  //             ),
                  //           ),
                  //           child: IconButton(
                  //             icon: Icon(
                  //                 DiskResources.getBool("isMuteOn") == true
                  //                     ? Icons.volume_up
                  //                     : Icons.volume_off,
                  //                 color: Colors.blue),
                  //             onPressed: () => setState(() =>
                  //                 DiskResources.setOrUpdateBool("isMuteOn",
                  //                     !DiskResources.getBool("isMuteOn"))),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const Spacer(),
                  //   ],
                  // ),
                ],
              ),
            ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomAppBar(
      child: Container(
        decoration: customeBackground(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: RotatedBox(
                quarterTurns: 2,
                child: IconButton(
                  icon: const Icon(Icons.logout_outlined, color: Colors.blue),
                  onPressed: () => setState(() => _showPopupMessage = true),
                ),
              ),
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
