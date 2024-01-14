import 'package:flutter/material.dart';
import 'package:ktr/views/places.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User"),
      ),
      body: const PlacesPage(),
    );
  }
}
