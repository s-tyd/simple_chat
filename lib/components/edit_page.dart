import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple/components/wide_rounded_button.dart';

typedef UpdateCallback = Future<void> Function(String newValue);

class EditPage extends HookWidget {
  const EditPage({
    required this.title,
    required this.initialValue,
    required this.updateCallback,
    super.key,
  });

  final String title;
  final String initialValue;
  final UpdateCallback updateCallback;

  @override
  Widget build(BuildContext context) {
    final valueController = useTextEditingController(text: initialValue);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: valueController,
              maxLength: 20,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const Spacer(),
            WideRoundedButton(
              title: 'Save',
              onPressed: () async {
                await updateCallback(valueController.text);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
