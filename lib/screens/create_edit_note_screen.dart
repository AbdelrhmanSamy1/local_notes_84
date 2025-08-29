import 'package:flutter/material.dart';
import 'package:local_notes_84/db/notes_database.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;
  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late final TextEditingController _titleController  ;
  late final TextEditingController _contentController ;


  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _contentController = TextEditingController(text: widget.note?.content);
  }
  bool isLoading = false;
  Future<void> saveNote()async{
    final title = _titleController.text;
    final content = _contentController.text;

    if(title.isEmpty || content.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("please fill all fields")),
      );
      return;
    }
    setState(() => isLoading = true);

    final note = Note(
      id: widget.note?.id,
        title: title,
        content: content,
        createdTime: widget.note?.createdTime ?? DateTime.now(),
    );

    if(widget.note != null ){
      await NotesDatabase.instance.update(note);
    }else{
      await NotesDatabase.instance.create(note);

    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions:  [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: null, // placeholder
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveNote, // placeholder
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
             Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Type something...',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 16),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
