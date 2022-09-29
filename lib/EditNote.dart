import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note/sqldb.dart';

import 'home.dart';

class EditNotes extends StatefulWidget {
  final TimePickerThemeData timePickerTheme;

  final note;
  final title;
  final time;
  final id;

  const EditNotes(
      {Key? key,
      this.note,
      this.title,
      this.id,
      this.time,
      required this.timePickerTheme})
      : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  Constants sqlDb = Constants();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController title = TextEditingController();

  @override
  void initState() {
    note.text = widget.note;
    title.text = widget.title;
    time.text = widget.time;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Edit notes"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/edit_bg.jpeg'),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                Form(
                    key: formstate,
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "You have to insert title";
                            }
                          },
                          controller: title,
                          cursorColor: HexColor("#f7f036"),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white24,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Color(0xFFFFFFFF),
                                    width: 0,
                                  )),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFFFFF))),
                              hintText: "Title",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "You have to insert note";
                            }
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 2000,
                          minLines: 5,
                          controller: note,
                          cursorColor: HexColor("#f7f036"),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white24,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Colors.cyan, width: 0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFFFFF), width: 0)),
                              hintText: "note",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                        Container(
                          height: 20,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white.withOpacity(0.20),
                          ),
                          onPressed: () async {
                            int response = await sqlDb.update(
                                'notes',
                                {
                                  'note': "${note.text}",
                                  'title': "${title.text}",
                                  'time': "${time.text}",
                                },
                                'id = ${widget.id}');
                            if (formstate.currentState != null &&
                                formstate.currentState!.validate()) {
                              if (response > 0) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => home()),
                                    (route) => false);
                                final snackBar = SnackBar(
                                  content: Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.asset("assets/check.png"),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "The note edited successfully",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  backgroundColor: HexColor("#201691"),
                                  duration: Duration(seconds: 2),
                                  shape: StadiumBorder(),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 150, horizontal: 12),
                                  elevation: 15,
                                );
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }
                            }
                          },
                          label: Text(
                            "Edit note",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
