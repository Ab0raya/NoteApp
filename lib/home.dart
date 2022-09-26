import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/sqldb.dart';

import 'EditNote.dart';


class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  bool isEmpty = true ;
  var time =DateFormat('hh:mm a').format(DateTime.now());
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        title: Text("HOME PAGE"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[900],
        onPressed: () {
          Navigator.of(context).pushNamed("add notes");
        },
        child: Icon(Icons.add),
      ),
      body: isLoading == true ? Center(child:
          Text(
              "Loading...",
          style:TextStyle(
              color: Colors.cyan[900],
              fontWeight: FontWeight.bold
          ),
          ),
          ) :notes.length==0?const Center(child: Text(
        "There's no notes to show..!",
        style: TextStyle(
          color: Color(0xA8006064),
          fontSize: 27,
          // fontWeight: FontWeight.bold,
        ),
      ),)
          : ListView(
            children: [
               ListView.builder(
                  itemCount: notes.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onDoubleTap: () async {
                        int response = await sqlDb.delete('notes', "id = ${notes[i]['id']}" );
                        if (response > 0) {
                          notes.removeWhere(
                                  (element) => element['id'] == notes[i]['id']);
                          setState(() {});
                        }
                      },
                      onTap: () async {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>EditNotes(
                              time: notes[i]['time'],
                              note:notes[i]['note'] ,
                              title:notes[i]['title'] ,
                              id: notes[i]['id'], timePickerTheme: TimePickerThemeData(),
                            ))
                        );
                      },
                      child: Card(
                        elevation: 10,
                          child: ListTile(
                        title: Text("${notes[i]['title']}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                             subtitle: Text("${time}",style: TextStyle(fontSize: 13,color: Colors.cyan[900]),),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                 Navigator.of(context).push(
                                     MaterialPageRoute(builder: (context)=>EditNotes(
                                       time: notes[i]['time'],
                                       note:notes[i]['note'] ,
                                       title:notes[i]['title'] ,
                                       id: notes[i]['id'], timePickerTheme: TimePickerThemeData(),
                                     ))
                                 );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.cyan[900],
                                )),
                            IconButton(
                                onPressed: () async {
                                  int response = await sqlDb.delete('notes', "id = ${notes[i]['id']}" );
                                  if (response > 0) {
                                    notes.removeWhere(
                                            (element) => element['id'] == notes[i]['id']);
                                    setState(() {});
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),

                          ],
                        ),
                      )),
                    );
                  })
            ],
          ),
    );
  }
}
