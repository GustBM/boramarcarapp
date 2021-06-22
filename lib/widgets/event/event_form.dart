import 'package:boramarcarapp/widgets/event/event_invited_chip.dart';
import 'package:flutter/material.dart';

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
  // final _locationController =

  // final _nameFocus = FocusNode();
  // final _descriptionFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                'assets/images/baloes.jpg',
                fit: BoxFit.cover,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome do Evento'),
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nome Obrigatório';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descrição'),
              controller: _descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Descrição Obrigatória';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: 'Endereço'),
              controller: _descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Endereço Obrigatório';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                } else {}
              },
              child: Text('Criar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}
