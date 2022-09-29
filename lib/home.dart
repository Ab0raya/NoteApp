import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:note/sqldb.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditNote.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final style = TextStyle(fontSize: 62, fontWeight: FontWeight.bold);
  bool isEmpty = true;

  var time = DateFormat('hh:mm a').format(DateTime.now());
  Constants sqlDb = Constants();
  late List notes = [];
  bool isLoading = true;

  Future readData() async {
    List<Map> response = await sqlDb.read('notes');
    notes.addAll(response);
    isLoading = false;
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).copyWith(textScaleFactor: 1.0);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Home page"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#c5c4f2"),
        onPressed: () {
          Navigator.of(context).pushNamed("add notes");
        },
        child: Icon(
          Icons.add,
          color: HexColor("#201691"),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/home_bg.jpeg'),
              fit: BoxFit.cover,
            )),
        child: isLoading == true
            ? Center(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white38,
                          spreadRadius: 10,
                          blurRadius: 10,
                          offset: Offset(3, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white38,
                      color: HexColor("#201691"),
                    )),
              )
            : notes.length == 0
                ? Center(
                    child: Container(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/pocket.png",
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(
                          height: 40,
                        ),

                        Text(
                          "There is no notes to show",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 90,
                        ),
                        Column(
                          children: [
                            Text(
                              "You can add a one",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "from add button below",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 13,
                                ),
                                Icon(
                                  Icons.add_circle,
                                  size: 30,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white38,
                          spreadRadius: 10,
                          blurRadius: 10,
                          offset: Offset(3, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 500,
                    width: 300,
                  ))
                : ListView(
                    children: [
                      ListView.builder(
                          itemCount: notes.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return InkWell(
                              onDoubleTap: () async {
                                int response = await sqlDb.delete(
                                    'notes', "id = ${notes[i]['id']}");
                                if (response > 0) {
                                  notes.removeWhere((element) =>
                                      element['id'] == notes[i]['id']);
                                  setState(() {});
                                  final snackBar = SnackBar(
                                    content: Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          children: [
                                            Image.asset(
                                                "assets/trash.png"),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "The note deleted successfully",
                                                style: TextStyle(
                                                    fontSize:
                                                    20,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                                textAlign:
                                                TextAlign
                                                    .center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    backgroundColor:
                                    HexColor("#201691"),
                                    duration:
                                    Duration(seconds: 2),
                                    shape: StadiumBorder(),
                                    behavior: SnackBarBehavior
                                        .floating,
                                    margin:
                                    EdgeInsets.symmetric(
                                        vertical: 150,
                                        horizontal: 12),
                                    elevation: 15,
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                }

                              },
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditNotes(
                                          time: notes[i]['time'],
                                          note: notes[i]['note'],
                                          title: notes[i]['title'],
                                          id: notes[i]['id'],
                                          timePickerTheme:
                                              TimePickerThemeData(),
                                        )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Card(
                                    color: Colors.white30,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(45)),
                                    shadowColor: Colors.white,
                                    elevation: 30,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: ListTile(
                                        title: Text(
                                          "${notes[i]['title']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        subtitle: Text(
                                          "${time}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: HexColor("#201691")),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditNotes(
                                                                time: notes[i]
                                                                    ['time'],
                                                                note: notes[i]
                                                                    ['note'],
                                                                title: notes[i]
                                                                    ['title'],
                                                                id: notes[i]
                                                                    ['id'],
                                                                timePickerTheme:
                                                                    TimePickerThemeData(),
                                                              )));
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: HexColor("#201691"),
                                                )),
                                            IconButton(
                                                onPressed: () async {
                                                  int response = await sqlDb.delete(
                                                      'notes',
                                                      "id = ${notes[i]['id']}");
                                                  if (response > 0) {
                                                    notes.removeWhere(
                                                        (element) =>
                                                            element['id'] ==
                                                            notes[i]['id']);
                                                    setState(() {});
                                                    final snackBar = SnackBar(
                                                      content: Stack(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                  "assets/trash.png"),
                                                              SizedBox(
                                                                width: 25,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  "The note deleted succssfuly",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      backgroundColor:
                                                          HexColor("#201691"),
                                                      duration:
                                                          Duration(seconds: 2),
                                                      shape: StadiumBorder(),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 150,
                                                              horizontal: 12),
                                                      elevation: 15,
                                                    );
                                                    ScaffoldMessenger.of(context)
                                                      ..removeCurrentSnackBar()
                                                      ..showSnackBar(snackBar);
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: HexColor("#201691"),
                                                )),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          })
                    ],
                  ),
      ),
    );
  }
}
