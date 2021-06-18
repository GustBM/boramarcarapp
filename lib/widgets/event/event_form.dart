import 'package:flutter/material.dart';

// Define a custom Form widget.
class EventForm extends StatefulWidget {
  final Function addEvent;

  EventForm(this.addEvent);
  @override
  EventFormState createState() => EventFormState();
}

class EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTimeRange _dateRange = new DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(
      Duration(days: 5),
    ),
  );

  final _nameFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
