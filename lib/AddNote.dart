import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/sqldb.dart';

import 'home.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  Constants sqlDb = Constants();
  int counter = 0;

  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add notes"),
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
                          if (title.text != '' && note.text != '') {
                            int response = await sqlDb.insert('notes', {
                              'note': "${note.text}",
                              'title': "${title.text}",
                              'time': "${time.text}",
                            });
                            counter++;
                          }
                          if (formstate.currentState != null &&
                              formstate.currentState!.validate()) {
                            if (counter > 0) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => home()),
                                  (route) => false);
                            }
                          }
                        },
                        child: Text("Add note"),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
