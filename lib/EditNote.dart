import 'dart:ffi';

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit notes"),
        centerTitle: true,
        backgroundColor: Colors.cyan[900],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Form(
                  key: formstate,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (String? value) {
                          if (value == null || value.trim().length == 0) {
                            return "You have to insert title";
                          }
                        },
                        controller: title,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFFFFF))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFFFFF))),
                            hintText: "title"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (String? value) {
                          if (value == null || value.trim().length == 0) {
                            return "You have to insert note";
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        controller: note,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: Color(0xFFFFFFFF), width: 4)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: Color(0xFF006064), width: 3)),
                            hintText: "note"),
                      ),
                      Container(
                        height: 20,
                      ),
                      MaterialButton(
                        textColor: Colors.white,
                        color: Colors.cyan[900],
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
                            }
                          }
                        },
                        child: Text("Edit note"),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
