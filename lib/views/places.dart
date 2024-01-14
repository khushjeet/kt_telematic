import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ktr/providers/user_provider.dart';
import 'package:ktr/views/add_content_page.dart';
import 'package:ktr/views/map_play/map_play_page.dart';
import 'package:ktr/views/widget/drawer.dart';
import 'package:ktr/views/widget/places_list.dart';

class PlacesPage extends ConsumerStatefulWidget {
  const PlacesPage({super.key});

  @override
  ConsumerState<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends ConsumerState<PlacesPage> {
  late Future<void> _placeFuture;

  @override
  void initState() {
    _placeFuture = ref.read(userPlaceProvider.notifier).loadPlace();
    super.initState();
  }

  final DrawerPage drawerPage = const DrawerPage();

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(userPlaceProvider);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          //this is for map_play_page
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MapPlayPage();
            }));
          },
          child: const Icon(Icons.play_arrow),
        ),
        drawer: drawerPage,
        appBar: AppBar(
          title: const Text("User 1"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddContentPage()));
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder(
            future: _placeFuture,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const CircularProgressIndicator()
                    : PlacesList(places: places)));
  }
}
