import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ktr/models/user_model_one.dart';
import 'package:ktr/providers/user_provider.dart';
import 'package:ktr/views/input_location.dart';

class AddContentPage extends ConsumerStatefulWidget {
  const AddContentPage({super.key});

  @override
  ConsumerState<AddContentPage> createState() => _AddContentPageState();
}

class _AddContentPageState extends ConsumerState<AddContentPage> {
  final _titleController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();

  PlaceLocationOne? _location;

  @override
  void dispose() {
    _titleController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  void _saveContent() {
    final enteredTitle = _titleController.text.trim();
    final userNameController = _userNameController.text.trim();
    final userEmailController = _userEmailController.text.trim();

    if (enteredTitle.isEmpty ||
        userNameController.isEmpty ||
        _location == null ||
        userEmailController.isEmpty) {
      return;
    }
    ref.read(userPlaceProvider.notifier).addUser(
        enteredTitle, userNameController, userEmailController, _location!);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Title"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveContent();
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                controller: _userNameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                controller: _userEmailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 10,
              ),
              //location Input
              InputLocation(
                onLocationPicked: (pickedLocation) {
                  _location = pickedLocation;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
