import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:local_notes_84/screens/create_edit_note_screen.dart';

import '../db/notes_database.dart';
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}



class _NotesScreenState extends State<NotesScreen> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    refreshNotes();
  }

  Future<void> refreshNotes() async{
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EditNoteScreen(),
              ),
            );
            refreshNotes();
          },
        ),
      appBar: AppBar(
        centerTitle: true,
          title: Text(
              "Notes",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

      ),
      body: isLoading ? Center( child:  CircularProgressIndicator(),)
      : notes.isEmpty
      ? Center(child: Text("No Notes Yet", style: TextStyle(
        fontSize: 20,
        color: Colors.grey,
      ),
      ),
      )
      : Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.count(
            crossAxisCount: 2,
            itemCount: notes.length,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemBuilder: (context, index) {
              final note = notes[index];
              return GestureDetector(
                onTap: () async{
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => EditNoteScreen(note: note,))
                  );
                  refreshNotes();
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.primaries[
                      index % Colors.primaries.length
                    ].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(note.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,

                      ),),
                      SizedBox(height: 8,),
                      Text(DateFormat.yMMMd().format(note.createdTime,),style: TextStyle(fontSize: 12, color: Colors.grey),)

                    ],
                  ),
                ),
              );
            }
        ),
      )

    );
  }
}
