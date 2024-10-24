import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Fields Demo',
      home: DynamicFields(),
    );
  }
}

class DynamicFields extends StatefulWidget {
  @override
  _DynamicFieldsState createState() => _DynamicFieldsState();
}

class _DynamicFieldsState extends State<DynamicFields> {
  List<Widget> inputFields = [];
  List<TextEditingController> controllers = [];
  List<String> dynamicFieldNames = [];

  void _addField() {
    // Show dialog to get the field name from the user
    TextEditingController nameController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Field'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Enter Field Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: valueController,
                decoration: InputDecoration(hintText: 'Enter Field Value'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    TextEditingController fieldController = TextEditingController();
                    controllers.add(fieldController);
                    dynamicFieldNames.add(nameController.text);

                    inputFields.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(nameController.text), // Field name
                            ),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: fieldController,
                                decoration: InputDecoration(hintText: 'Enter ${nameController.text}'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    fieldController.text = valueController.text; // Set the field value
                  });
                  Navigator.of(context).pop(); // Close dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Generate a string with all the input data
  String _getInputData() {
    String data = '';
    for (int i = 0; i < controllers.length; i++) {
      data += '${dynamicFieldNames[i]}: ${controllers[i].text}\n';
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Input Fields')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addField,
              child: Text('+ Add Field'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: inputFields.length,
                itemBuilder: (context, index) {
                  return inputFields[index];
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final data = _getInputData(); // Get the input data
                if (data.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('QR Code'),
                        content: SizedBox(
                          width: 200,
                          height: 200,
                          child: QrImageView(
                            data: data, // Pass the input data as a string
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Generate QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
