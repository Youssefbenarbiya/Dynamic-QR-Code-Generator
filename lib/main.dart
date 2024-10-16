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
  int clickCount = 0;

  // List of field names for dynamic fields
  final List<String> fieldNames = [
    'Name',
    'Age',
    'Phone Number',
    'Email',
    'Address',
    'City',
    'State',
    'Country',
    'Zip Code',
    'Date of Birth',
    'Occupation',
    'Company Name',
    'Job Title',
    'Website',
    'LinkedIn',
    'Facebook',
    'Twitter',
    'Instagram',
    'Notes',
    'Other 1',
    'Other 2'
  ];

  void _addField() {
    setState(() {
      if (clickCount < fieldNames.length) {
        TextEditingController controller = TextEditingController();
        controllers.add(controller);  // Store the controller for each field

        inputFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text(fieldNames[clickCount])),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: controller,  // Set the controller to the text field
                    decoration: InputDecoration(hintText: 'Enter ${fieldNames[clickCount]}'),
                    keyboardType: (fieldNames[clickCount] == 'Age' || 
                                   fieldNames[clickCount] == 'Zip Code') 
                        ? TextInputType.number 
                        : TextInputType.text,
                  ),
                ),
              ],
            ),
          ),
        );
        clickCount++;
      }
    });
  }

  // Generate a string with all the input data
  String _getInputData() {
    String data = '';
    for (int i = 0; i < controllers.length; i++) {
      data += '${fieldNames[i]}: ${controllers[i].text}\n';
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
