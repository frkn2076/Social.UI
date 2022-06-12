import 'package:flutter/material.dart';

class Activity extends StatelessWidget {
  final int id;
  const Activity({Key? key, required this.id}) : super(key: key);

  static const String _title = 'Social';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          _title,
          style: TextStyle(fontSize: 30),
        ),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            height: 120,
            width: 100,
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
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15.0),
            child: const Text(
              'Heybeli Ada Turu',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(15.0),
            child: const Text(
              'Heybeliada or Heybeli Ada is the second largest of the Prince Islands in the Sea of Marmara, near Istanbul. It is officially a neighborhood in the Adalar district of Istanbul, Turkey. The large Naval Cadet School overlooks the jetty to the left as you get off the ferry or seabus',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Container(
            height: 300,
            width: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15.0),
            child: ListView(
              children: List<Widget>.from(
                List<int>.generate(5, (i) => i + 1)
                    .map(
                      (i) => GestureDetector(
                        onTap: () => {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const Register()),
                          // )
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(1),
                          child: Text(
                            'Furkan $i',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          // Container(
          //   alignment: Alignment.center,
          //   padding: const EdgeInsets.all(10),
          //   margin: const EdgeInsets.all(15.0),
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.blueAccent),
          //   ),
          //   child: Text(
          //     'Etkinlik ${widget.id} \nDetaylar... \n ... \n Katılımcılar: \n Furkan \n Tuba \n Öztürk',
          //     style: const TextStyle(
          //         color: Colors.blue,
          //         fontWeight: FontWeight.w500,
          //         fontSize: 30),
          //   ),
          // ),
        ],
      ),
    );
  }
}
